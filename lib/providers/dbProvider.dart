//Creamos un singleton para que no importa donde se use o donde se instancie, siempre será la misma instancia
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qrbarcodescanner/models/scanModel.dart';
// export 'package:qrbarcodescanner/models/scanModel.dart';

class DBProvider {
  static Database _dataBase;

  //singleton, cada vez que se haga un new DBProvider, siempre devuelve la misma instancia
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get dataBase async {
    //si no se ha instanciao una clase, retorna la misma base de datos
    if (_dataBase != null) return _dataBase;
    //de lo contrario si no se ha instanciado retorna una base de datos :
    _dataBase = await iniciarDB();

    return _dataBase;
  }

  //crear base de datos
  Future<Database> iniciarDB() async {
    //Ruta de donde se almacena la base de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    //sirve para unir rutas , como __dirname de node.js
    final ruta = join(documentsDirectory.path, "ScansDB.db");

    print(ruta);

    return await openDatabase(
      ruta,
      //siemrpe hay que incrementar la version cuando se modifica la base de datos
      version: 1,
      //ejecutar algo
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Scans(
            id INTEGER PRIMARY KEY,
            tipo TEXT,
            valor TEXT
          )''');
      },
    );
  }

//Retorna el numero del registro insertado, el cual usaremos como el id,
  Future<int> insert(ScanModel nuevoScan) async {
    //obetener la referencia a la base de datos, puede que no este lsita o en proceso de creacion por eso se usa await
    //usamos nuestro Getter, ejecuta toda la inciciacion de la base de datos antes de llegar aqui
    final db = await dataBase;
    //insertar dentor de la tabla Scans, un mapa (objeto igualq eu el json en JS)
    final resp = await db.insert('Scans', nuevoScan.convertirAMapa());

    //retorna el id del ultimo resigstro insertado
    return resp;
  }

  Future<ScanModel> selectById(ScanModel id) async {
    final db = await dataBase;
    //Hace un select y regresa una Lista de Mapas,
    // se puede poner mas condiciones como AND, OR etc,
    //al colocar el signo ? esta esperando whereArgs[] donde pasaremos los parametros para el id,
    //si hubieran mas como where: 'id = ? AND nombreColumna = ?' entonces se pasa en el la misma lista [id, nombreColumna]
    final resp = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    //condicion if flecha
    return resp.isNotEmpty ? ScanModel.fromJson(resp[0]) : null;
  }

  Future<List<ScanModel>> selectAll() async {
    final db = await dataBase;
    //Hace un select y regresa una Mapa de Mapas,
    final resp = await db.query('Scans');

    //condicion if flecha
    return resp.isNotEmpty
        //el.map, recorre como forEach y retorna una lista con cada elemento
        ? resp.map((item) => ScanModel.fromJson(item)).toList()
        : [];
  }

  Future<List<ScanModel>> selectPorTipo(String tipo) async {
    final db = await dataBase;
    //Hace un select y regresa una Mapa de Mapas,
    final resp = await db.query('Scans', where: 'tipo = ?', whereArgs: [tipo]);

    //condicion if flecha
    return resp.isNotEmpty
        //el.map, recorre como forEach y retorna una lista con cada elemento
        ? resp.map((item) => ScanModel.fromJson(item)).toList()
        : [];
  }

  //Regresa la cantidad int de registros actualizados
  Future<int> update(ScanModel scan) async {
    final db = await dataBase;
    final resp = await db.update('Scan', scan.convertirAMapa(),
        where: 'id = ?', whereArgs: [scan.id]);
    return resp;
  }

  //Regresa la cantidad int de registros borrados
  Future<int> deleteOne(int id) async {
    final db = await dataBase;
    final resp = await db.delete("Scans", where: 'id = ?', whereArgs: [id]);
    return resp;
  }

  //Regresa la cantidad int de registros borrados
  Future<int> deleteAll(int actualIndex) async {
    final db = await dataBase;

    if (actualIndex == 0) {
      final resp =
          await db.delete("Scans", where: 'tipo = ?', whereArgs: ["geo"]);
      return resp;
    } else {
      final resp =
          await db.delete("Scans", where: 'tipo = ?', whereArgs: ["http"]);
      return resp;
    }
  }

  /*//otra forma mas comun ara SQL
    nuevoScanRaw(ScanModel nuevoScan) async {
      //obetener la referencia a la base de datos, puede que no este lsita o en proceso de creacion por eso se usa await
      //usamos nuestro Getter, ejecuta toda la inciciacion de la base de datos antes de llegar aqui
      final db = await dataBase;

      final resp = await db.rawInsert('''
        INSERT INTO Scans(id, tipo, valor)
          VALUES(${nuevoScan.id}, '${nuevoScan.tipo}', '${nuevoScan.tipo}')
      ''');

      return resp;
    }
  */

}
