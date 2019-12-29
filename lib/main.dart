import 'package:flutter/material.dart';

import 'package:inAppelis/src/pages/home_page.dart';
import 'package:inAppelis/src/pages/pelicula_detalle.dart';

///PÁGINA INICIO APLICACIÓN///

//Notación 1, importante método de arranque aplicación
void main() => runApp(MyApp());
 
//Notación 2, Clase StatelessWidget
class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,//se quita marca del simulador
      title: 'InAppelis_pueba_git', //título de la aplicación
      initialRoute: '/', //Ruta de inicio de la app
      routes: { //Navegación diferentes páginas
        '/'       : ( BuildContext context ) => HomePage(),
        'detalle' : ( BuildContext context ) => PeliculaDetalle(),
      },
    );
  }
}