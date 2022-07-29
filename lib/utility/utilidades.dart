import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qrbarcodescanner/models/scanModel.dart';

//Para navegar a otra pantalla usamos el context, y el scan es quien tiene la informacion
//el scan es cada objeto individual de cada scanner con su id, su tipo y su valor que esta en el listView / listTile onPress
void launchURL(BuildContext context, ScanModel scan) async {
  if (scan.tipo == "http") {
    await canLaunch(scan.valor)
        ? await launch(scan.valor)
        : throw 'Could not launch $scan.valor';
  } else {
    Navigator.pushNamed(context, "mapaPage", arguments: scan);
  }
}

//Extrae el nombre de la url sin los puntos
String extraerNombreDeUrl(String url) {
  String nombreExtraido =
      url.substring(url.indexOf(":") + 3, url.lastIndexOf(".") + 4);
  return nombreExtraido;
}
