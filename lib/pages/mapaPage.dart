import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qrbarcodescanner/models/scanModel.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  //controlador
  Completer<GoogleMapController> _controller = Completer();

  MapType mapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    //se peude almacenar en el uiProvider para compartir desde ahí que viene de MilsitViewPage
    final ScanModel geolocation = ModalRoute.of(context).settings.arguments;

    //Google maps
    final CameraPosition puntoInicial = CameraPosition(
      //se puede obtener desd eel geolocation.valor y substrar() etc
      // target: LatLng(37.42796133580664, -122.085749655962),

      target: geolocation.obtenerCoordenadas(),
      zoom: 18,
      tilt: 50,
    );

    //Marcadorer para markeds:
    Set<Marker> marcadores = new Set<Marker>();
    marcadores.add(new Marker(
        //es obligatorio, este emtodo es para poner algo por defecto
        markerId: MarkerId("geo-location"),
        //posicion donde va a ir el marcador
        position: geolocation.obtenerCoordenadas()));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Map'),
        actions: [
          Row(
            children: [
              Text('Center',
                  style: TextStyle(color: Colors.purple[200], fontSize: 20)),
              IconButton(
                tooltip: "Center map",
                icon: Icon(Icons.center_focus_strong_outlined,
                    color: Colors.purple[200], size: 28),
                onPressed: () async {
                  final GoogleMapController controller =
                      await _controller.future;
                  controller.animateCamera(
                      CameraUpdate.newCameraPosition(puntoInicial));
                },
              )
            ],
          )
        ],
      ),
      body: GoogleMap(
        // myLocationButtonEnabled: true,
        markers: marcadores,
        mapType: mapType,
        initialCameraPosition: puntoInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.layers, color: Colors.white, size: 28),
        onPressed: () {
          if (mapType == MapType.normal) {
            mapType = MapType.hybrid;
          } else {
            mapType = MapType.normal;
          }
          setState(() {});
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
