import 'package:flutter/material.dart';

import 'package:inAppelis/src/models/pelicula_model.dart';
import 'package:inAppelis/src/models/actores_model.dart';
import 'package:inAppelis/src/providers/peliculas_provider.dart';


class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    //recogemos los argumentos enviados
    return Scaffold(
      body: CustomScrollView(//mandamos una lista vertical 
        slivers: <Widget>[
          _crearAppbar( pelicula ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox( height: 10.0 ),
                _posterTitulo( context, pelicula ),
                _descripcion( pelicula ),
                _crearCasting( pelicula )
              ]
            ),
          )
        ],
      )
    );
  }
  Widget _crearAppbar( Pelicula pelicula ){//
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(//para que se redimensiones cuando pulsamos hacia arriba
        centerTitle: true,
        title: Text(
          pelicula.title,//damos título que hemos cogido de los argumentos
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage( pelicula.getBackgroundImg() ),//mostramos de fondo la carátula de la película
          placeholder: AssetImage('assets/img/loading.gif'),//mientras carga mostramos el gif
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );

  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula ){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage( pelicula.getPosterImg() ),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis ),
                Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis ),
                Row(
                  children: <Widget>[
                    Icon( Icons.star_border ),
                    Text( pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subhead )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );

  }
  Widget _descripcion( Pelicula pelicula ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );

  }
//creamos método del casting de actores
  Widget _crearCasting( Pelicula pelicula ) {
    final peliProvider = new PeliculasProvider();//llamamos al método 

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),//filtamos por ID de la película
      builder: (context, AsyncSnapshot<List> snapshot) {  
        if( snapshot.hasData ) {//si no hay datos
          return _crearActoresPageView( snapshot.data );//retornamos los datos
        } else {
          return Center(child: CircularProgressIndicator());//sino mientras un circulos de progreso
        }
      },
    );
  }
  Widget _crearActoresPageView( List<Actor> actores ) {//creamos una lista horizontal de actores
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemCount: actores.length,
        itemBuilder: (context, i) =>_actorTarjeta( actores[i] ),
      ),
    );

  }
  Widget _actorTarjeta( Actor actor ) {//creamos la tarjeta del actor en cuestión
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage( actor.getFoto() ),//cogemos el perfil foto del actor
              placeholder: AssetImage('assets/img/no-image.jpg'),//sino un foto neutra
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,//nombre del actor
            overflow: TextOverflow.ellipsis,
          )
        ],
      )
    );
  }
}