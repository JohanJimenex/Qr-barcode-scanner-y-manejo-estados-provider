// import 'dart:convert';
// ScanModel scanModelFromJson(String str) => ScanModel.fromJson(json.decode(str));
// String scanModelToJson(ScanModel data) => json.encode(data.toJson());

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show LatLng; //tomamo solo esto

class ScanModel {
  int id;
  String tipo;
  String valor;

  ScanModel({@required this.valor}) {
    if (this.valor.contains("http")) {
      this.tipo = "http";
    } else if (this.valor.contains("geo")) {
      this.tipo = "geo";
    }
  }

  //constructor con nombre para convertir el mapa que viene de la base de dato a un objeto tipo ScanModel y poder usarlo
  ScanModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    tipo = json["tipo"];
    valor = json["valor"];
  }

//retorna un mapa para luego mandarlo a la base de datos mas facil
//ya que la base de datos tiene la opcion de insertar un mapa y acepta el mismo
  Map<String, dynamic> convertirAMapa() {
    return {
      "id": id,
      "tipo": tipo,
      "valor": valor,
    };
  }

  // retornaremos  la latitud y longitud , se puede tomar del objeto en crudo en mapaPage.dar pero esta forma es mas "organizada"
  LatLng obtenerCoordenadas() {
    final latLng = valor.substring(4).split(','); //devuelve una Lista
    //convertimos cada uno a double
    final latitud = double.parse(latLng[0]);
    final longitud = double.parse(latLng[1]);

    return LatLng(latitud, longitud);
  }
}
//retorna la instancia
// factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
//       id: json["id"],
//       tipo: json["tipo"],
//       valor: json["valor"],
//     );

/*
// import 'dart:convert';
// ScanModel scanModelFromJson(String str) => ScanModel.fromJson(json.decode(str));
// String scanModelToJson(ScanModel data) => json.encode(data.toJson());

import 'package:flutter/material.dart';

class ScanModel {
  int id;
  String tipo;
  String valor;

  ScanModel({@required this.id, @required this.tipo, @required this.valor}) {
    if (this.tipo.contains("http")) {
      this.tipo = "http";
    } else if (this.tipo.contains("geo")) {
      this.tipo = "geo";
    } else {
      this.tipo = "Others";
    }
  }

  //constructor con nombre
  ScanModel.fromJson(Map<String, dynamic> json) {
    id=
    json["id"];
    tipo=
    json["tipo"];
    valor=
    json["valor"];
  }
}
*/
