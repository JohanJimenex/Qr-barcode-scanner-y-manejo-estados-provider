import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:qrbarcodescanner/utility/utilidades.dart';
import 'package:qrbarcodescanner/providers/uiProvider.dart';
import 'package:qrbarcodescanner/widgets/miListViewWidget.dart';
import 'package:qrbarcodescanner/providers/scanListProvider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    abrirScaner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Scan History"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              final uiProvider =
                  Provider.of<UIProvider>(context, listen: false);
              int actualIndex = uiProvider.opcionMenuSeleccionada;

              mostrarAlerta(context, actualIndex);
            },
          )
        ],
      ),
      body: HomePageBody(),
      bottomNavigationBar: MiBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.qr_code_scanner_outlined, size: 30),
        onPressed: () {
          abrirScaner();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void abrirScaner() async {
    String barcodeScanRes;
    //devuelve "-1" si se cancela o el valor del codigo QR si se lee
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.QR);
    print(barcodeScanRes);

    // barcodeScanRes = "https://pub.dev/packages/url_launcher";
    // barcodeScanRes = "geo:45.280089,-75.922405";

    if (barcodeScanRes == "-1") {
      return;
    }
    //scanListProvider es el proveedor que suamos como puente para la BD , y el lister false ya que esta dentro de una funcion
    //y para no redibujar en este punto
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);

    final nuevoScan = await scanListProvider.agregarScan(barcodeScanRes);

    launchURL(context, nuevoScan);
  }
}

class MiBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Obtener el la opcion seleccionada del menu desde el provider
    final uiProvider = Provider.of<UIProvider>(context);
    final actualIndex = uiProvider.opcionMenuSeleccionada;

    return BottomNavigationBar(
      onTap: (int indexBotonPresionado) {
        uiProvider.opcionMenuSeleccionada = indexBotonPresionado;
      },
      elevation: 0,
      iconSize: 35,
      fixedColor: Colors.purple[900],
      currentIndex: actualIndex,
      items: [
        BottomNavigationBarItem(
            label: "Locations", icon: Icon(Icons.location_on_outlined)),
        BottomNavigationBarItem(
            label: "Links", icon: Icon(Icons.link_outlined)),
      ],
    );
  }
}

class HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Obtener el la opcion seleccionada del menu desde el provider
    final uiProvider = Provider.of<UIProvider>(context);
    final actualIndex = uiProvider.opcionMenuSeleccionada;

    //lsiten en false para que no se redibuje en este punto, ya lo hace el scanListProvider
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);

    //Retorna un widge acorde al numero en el index
    switch (actualIndex) {
      case 0:
        scanListProvider.cargarScansPorTipo("geo");
        return MiListViewWidget(tipo: "geo");
      case 1:
        scanListProvider.cargarScansPorTipo("http");
        return MiListViewWidget(tipo: "http");
        break;
      default:
        return MiListViewWidget(tipo: "geo");
    }
  }
}

mostrarAlerta(BuildContext context, int actualIndex) {
  //Similar a un container pero con otras careacteriscia parecido a un modal, box o alert
  showDialog(
    context: context,
    // permite cerrar la alerta haciendo click afuera
    barrierDismissible: true,
    //debe retornar un widget
    builder: (context) {
      //muestra un cuadrito en el centro de la pantalla  modal, dialog, alert etc.
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text("Delete history"),
        content: Column(
          mainAxisSize: MainAxisSize.min, //manejar el tamano de la alerta
          children: [
            Text("Do you want to delete all ?"),
            Icon(Icons.warning, color: Colors.orange, size: 28)
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cancel', style: TextStyle(fontSize: 20)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('Ok', style: TextStyle(fontSize: 20)),
            onPressed: () {
              Provider.of<ScanListProvider>(context, listen: false)
                  .borrarTodos(actualIndex);
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
