import 'package:flutter/material.dart';

import 'package:inAppelis/src/models/pelicula_model.dart';
import 'package:inAppelis/src/providers/peliculas_provider.dart';

//clase de busqueda de películas
class DataSearch extends SearchDelegate {
  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();
  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar, es el icono de cancela la busqueda o buscar
    return [
      IconButton(
        icon: Icon( Icons.clear ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar, el icono de buscador
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close( context, null );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe
    //si el query esta vacio retornamos un contenedor sin nada
    if ( query.isEmpty ) {
      return Container();
    }
    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
          //si existen datos
          if( snapshot.hasData ) {
            final peliculas = snapshot.data;//asignamos los datos a la variable
           return ListView(
              children: peliculas.map( (pelicula) {
                  return ListTile(
                      leading: FadeInImage(
                      image: NetworkImage( pelicula.getPosterImg() ),
                      placeholder: AssetImage('assets/img/no-image.jpg'),
                      width: 50.0,
                      fit: BoxFit.contain,
                    ),
                    title: Text( pelicula.title ),
                    subtitle: Text( pelicula.originalTitle ),
                    onTap: (){
                      close( context, null);
                      pelicula.uniqueId = '';
                      Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                    },
                  );
              }).toList()
            );
          } else {
            return Center(//mientras no haya datos regresamos un circular progress
              child: CircularProgressIndicator()
            );
          }
      },
    );
  }
}

