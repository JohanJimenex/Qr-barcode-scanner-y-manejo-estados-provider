import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrbarcodescanner/providers/scanListProvider.dart';
import 'package:qrbarcodescanner/utility/utilidades.dart';

class MiListViewWidget extends StatelessWidget {
  //para definir si es geo o http
  final String tipo;

  const MiListViewWidget({@required this.tipo});

  @override
  Widget build(BuildContext context) {
    //Es un puente , y el lister en este caso es true ya que esta dentro  del build
    final scanListProvider = Provider.of<ScanListProvider>(context);

    if (scanListProvider.listaScans.length == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(tipo == "http" ? Icons.link : Icons.map_outlined,
                color: Colors.purple[900], size: 100),
            Text("You do not have history"),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: scanListProvider.listaScans.length,
        itemBuilder: (BuildContext contex, int index) {
          //swipe que remueve el listTile del listView, delete, borrar
          return Dismissible(
            //UniqueKey() genera una clave por automatica, y Key("") recibe la clave manual.
            key: UniqueKey(),
            background: Container(
                color: Colors.red,
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    Icon(Icons.delete, color: Colors.white),
                    Expanded(child: SizedBox(width: 20)),
                    Icon(Icons.clear, color: Colors.white),
                    SizedBox(width: 20),
                  ],
                )),
            child: ListTile(
              leading: Icon(
                  scanListProvider.listaScans[index].tipo == "geo"
                      ? Icons.location_on_outlined
                      : Icons.link,
                  color: Theme.of(contex).primaryColor,
                  size: 28),
              title: scanListProvider.listaScans[index].tipo == "http"
                  ? Text(extraerNombreDeUrl(
                      scanListProvider.listaScans[index].valor))
                  : Text(scanListProvider.listaScans[index].valor),
              subtitle: Text(scanListProvider.listaScans[index].valor),
              trailing: Icon(Icons.arrow_right, color: Colors.grey, size: 28),
              onTap: () {
                launchURL(context, scanListProvider.listaScans[index]);
              },
            ),
            onDismissed: (DismissDirection direction) {
              Provider.of<ScanListProvider>(context, listen: false)
                  .borrarPorId(scanListProvider.listaScans[index].id);
            },
          );
        },
      );
    }
  }
}
