import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:inAppelis/src/models/pelicula_model.dart';


class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;
  //con required ordenamos que por fuerza debe de mandar una lista de peliculas al constructor
  CardSwiper({ @required this.peliculas });
  
  @override
  Widget build(BuildContext context) {
    //creamos una variable con la resolución pantalla del dispositivo
    final _screenSize = MediaQuery.of(context).size;

    return Container(
       padding: EdgeInsets.only(top: 10.0),
       child: Swiper(
          layout: SwiperLayout.STACK,
          itemWidth: _screenSize.width * 0.7, //damos el 70% del ancho pantalla a las tarjetas
          itemHeight: _screenSize.height * 0.5,//damos el 50% del alto pantalla a las tarjetas
          itemBuilder: (BuildContext context, int index){

            peliculas[index].uniqueId = '${ peliculas[index].id }-tarjeta';

            return Hero(
              tag: peliculas[index].uniqueId,
              child: ClipRRect( //damos diseño a las tarjetas
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: ()=> Navigator.pushNamed(context, 'detalle', arguments: peliculas[index]),
                  child: FadeInImage(//mandamos la imagen en relación con el index
                    image: NetworkImage( peliculas[index].getPosterImg()  ),//llamamos al método
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    fit: BoxFit.cover,
                  ),
                )
              ),
            );
            
          },
          itemCount: peliculas.length,
      ),
    );

  }
}
