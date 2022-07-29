import 'package:flutter/material.dart';
import 'package:qrbarcodescanner/models/scanModel.dart';
import 'package:qrbarcodescanner/providers/dbProvider.dart';

/*
Estoe s un puente, desde nuestro front aqui y de aqui a la base de datos y viceversa,
esta clase se usara para manejar los cambios , a hacer consultas a la base de datos haremos que refresque el cambio
ya que el dbProvider no renderiza los cambios como setState() en los botone
*/
class ScanListProvider extends ChangeNotifier {
  List<ScanModel> listaScans = [];
  //Este valor viene desde el homepage pasado por parametro, pro defecto tiene http
  String tipoSeleccionado = "http";

  Future<ScanModel> agregarScan(String valorRecibido) async {
    final nuevoScan = new ScanModel(valor: valorRecibido);

    //la base de dato retorna el numero de registro que usaremos como id
    final idFromDB = await DBProvider.db.insert(nuevoScan);

    //le agregamnos el id que no tiene que viene de la DB
    nuevoScan.id = idFromDB;

    if (this.tipoSeleccionado == nuevoScan.tipo) {
      listaScans.add(nuevoScan);
      notifyListeners();
    }
    //solo usaremos este return en el hompage para enviarlo como parametro
    return nuevoScan;
  }

  cargarScans() async {
    final selectScans = await DBProvider.db.selectAll();
    //remplazamos el contenido de la lista de scans por el query de la base de datos ... es todo
    listaScans = [...selectScans];
    //para actualizar todo
    notifyListeners();
  }

  cargarScansPorTipo(String tipo) async {
    final selectScans = await DBProvider.db.selectPorTipo(tipo);
    //remplazamos el contenido de la lsita de scans por el query de la base de datos ... es todo
    listaScans = [...selectScans];
    tipoSeleccionado = tipo;
    //para actualizar todo
    notifyListeners();
  }

  borrarTodos(int actualIndex) async {
    await DBProvider.db.deleteAll(actualIndex);
    listaScans = [];
    notifyListeners();
  }

  borrarPorId(int id) async {
    await DBProvider.db.deleteOne(id);
    // notifyListeners();

    //eliminar y probar
    cargarScansPorTipo(tipoSeleccionado);
  }
}
