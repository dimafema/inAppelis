import 'package:flutter/material.dart';
import 'package:inAppelis/src/models/pelicula_model.dart';


//al ser statelesswidget es inmutable
class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientePagina;
  MovieHorizontal({ @required this.peliculas, @required this.siguientePagina });
  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3
  );

  @override
  Widget build(BuildContext context) {
    //miramos la resolución de la pantatalla del dispositivo
    final _screenSize = MediaQuery.of(context).size;
    //controlamos en la página que estamos en el scroll para cargar mas películas
    _pageController.addListener( () {
      if ( _pageController.position.pixels >= _pageController.position.maxScrollExtent - 200 ){
        siguientePagina();
      }
    });
    return Container(
      height: _screenSize.height * 0.2,
      child: PageView.builder(//nos crea una lista de scroll, bajo demanda con builder
        pageSnapping: false,
        controller: _pageController,
        itemCount: peliculas.length,//renderizamos las peluculas que tengamos en datos
        itemBuilder: ( context, i ) => _tarjeta(context, peliculas[i] ),//se reduce el código con función de flecha
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula) {
    pelicula.uniqueId = '${ pelicula.id }-poster';
    final tarjeta = Container(//creamos una variable llamada tarjeta
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            Hero(//le damos un efecto especial para que la imagen se redimensiona en el cambio de pantalla
              tag: pelicula.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  image: NetworkImage( pelicula.getPosterImg() ),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                  height: 115.0,
                ),
              ),
            ),
            SizedBox(height: 1.0),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    return GestureDetector(//detectamos si pulsamos sobre la tarjeta
      child: tarjeta,
      onTap: (){
        Navigator.pushNamed(context, 'detalle', arguments: pelicula );
                            //si hacemo tap navegamos hasta la página detalle
                            //cogiendo los agrumentos de la película
      },
    );
  }
}
