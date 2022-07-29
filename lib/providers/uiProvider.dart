import 'package:flutter/material.dart';

class UIProvider extends ChangeNotifier {
  /*Los manejadores de estados se usan para indicarle a flutter que tiene que redibujar algun cambio
  como setState pero esta opcion no esta disponible para el scafold
  con esta clase manejamos una sola instancia la cual será compartida
  con get y set obetenemos y modificamos la misma variable de cualqueir variable*/
  int _opcionMenuSeleccionada = 0;

  get opcionMenuSeleccionada {
    return this._opcionMenuSeleccionada;
  }

  set opcionMenuSeleccionada(int i) {
    this._opcionMenuSeleccionada = i;
    //cuando se cambia el valor de la variable se le notifica a todos los que usan la variable que cambió y aplica un setState global
    notifyListeners();
  }
}
