//llamada de los siguientes paquetes necesario para el funcionamiento de código
import 'package:flutter/material.dart';

import 'package:inAppelis/src/providers/peliculas_provider.dart';
import 'package:inAppelis/src/search/search_delegate.dart';
import 'package:inAppelis/src/widgets/card_swiper_widget.dart';
import 'package:inAppelis/src/widgets/movie_horizontal.dart';


class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulares();//llamamos al metodo para el infinity scroll
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Películas expuestas en salas'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.search ),
            onPressed: () {
              showSearch(//cuando pulsamos hacemos una busqueda
                context: context, 
                delegate: DataSearch(),
                );
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),//widget para crear las tarjetas
            _footer(context)
          ],
        ),
      )
       
    );
  }
  //método para crear las tarjetas del body
  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),//llamamos al método provider
      //retornamos una lista de peliculas
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        //Si tenemos información 
        if ( snapshot.hasData ) {  //le mandamos una lista de películas
          return CardSwiper( peliculas: snapshot.data );
        } else {
          //Mientras no haya datos mostramos un circulo de progreso
          return Container(
            height: 400.0,
            child: Center(//centramos el circulo
              child: CircularProgressIndicator()
            )
          );
        }
      },
    );
  }

//Scroll de pelicula populares
  Widget _footer(BuildContext context){
    return Container(
      width: double.infinity,//ocupamos todo el ancho del dispositivo
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Populares', style: Theme.of(context).textTheme.subhead  )//configuramos globalmente el interfaz de la app
          ),
          SizedBox(height: 5.0),
          StreamBuilder(//utilizamos un Stream para manejar los datos
            stream: peliculasProvider.popularesStream,
            //cargamos lista de películas populares
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              //si existe dato 
              if ( snapshot.hasData ) {
                return MovieHorizontal( //mostramos películas de manera horizontal
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares,//a medida que avanzamos cargamos peliculas en la página
                );
              } else {//sino mostramos un circulo de progreso
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}