import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'pages/homePage.dart';
import 'package:qrbarcodescanner/pages/mapaPage.dart';
import 'package:qrbarcodescanner/providers/uiProvider.dart';
import 'package:qrbarcodescanner/providers/scanListProvider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    /*
    Los manejadores de estados se usan para indicarle a flutter que tiene que redibujar algun cambio
    como setState de los botones pero esta opcion no esta disponible para el scafol.
    Se utiliza para decirle a nuestra app, "necesito que busques el UiProvider para usarlo"
    se usa un MultiProvider porque posiblemente se utiliza varios proveedores
    */
    return MultiProvider(
      /*
      Es la instruccion que se ejecuta cuando no hay ninguna instancia del provider creado
      automaticamente se agrega al context
      */
      providers: [
        ChangeNotifierProvider(create: (_) => UIProvider()),
        ChangeNotifierProvider(create: (_) => ScanListProvider()),
      ],

      //
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QR Scanner',
        initialRoute: "homePage",
        routes: {
          "homePage": (_) => HomePage(),
          "mapaPage": (_) => MapaPage(),
        },
        // theme: ThemeData.dark(),
        theme: ThemeData(
          primaryColor: Colors.grey[900],
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.black),
        ),
      ),
    );
  }
}
