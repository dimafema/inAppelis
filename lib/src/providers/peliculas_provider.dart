import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:inAppelis/src/models/actores_model.dart';
import 'package:inAppelis/src/models/pelicula_model.dart';



class PeliculasProvider {
  String _apikey   = '793b5ccab5f493cd419a54dd70743999';
  String _url      = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularesPage = 0;//definimos la página inicial 
  bool _cargando     = false; //

  List<Pelicula> _populares = new List(); //contenedor de las películas
  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();//gestionamos los Stream
//recibimos la lista de películas
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;
//escuchamos la lista de películas  
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;
//cerramos el stream
  void disposeStreams() {
    _popularesStreamController?.close();//si tiene algún valor cerrar
  }
  
    Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get( url );
    final decodedData = json.decode(resp.body);
                      //barremos los datos del JSON y guardamos en variable
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
  //retornamos los datos de películas
    return peliculas.items;//y creamos la lista de películas
  }

//cramos una petición get por http
  Future<List<Pelicula>> getEnCines() async {
//contruimos el url
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key'  : _apikey,
      'language' : _language
    });
    return await _procesarRespuesta(url);
  }
  Future<List<Pelicula>> getPopulares() async {
    if ( _cargando ) return [];//si estoy cargando datos no retorna nada
    _cargando = true;//solicitamos datos
    _popularesPage++;//vamos sumando las paginas a visualizar para la paginación
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'  : _apikey,
      'language' : _language,
      'page'     : _popularesPage.toString()
    });
    final resp = await _procesarRespuesta(url);
    _populares.addAll(resp);//añadir peliculas al stream
    popularesSink( _populares );//creamos la lista de películas
    _cargando = false;//paramos de solicitar datos
    return resp;//retornamos los datos
  }
  //buscamos los actores según de la película que seleccionemos
  Future<List<Actor>> getCast( String peliId ) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key'  : _apikey,
      'language' : _language
    });
    final resp = await http.get(url);//llamamos la información del JSON
    final decodedData = json.decode( resp.body );//almacenamos la información como un mapa
    final cast = new Cast.fromJsonList(decodedData['cast']);//apuntamos a la propiedad cast del mapa
    return cast.actores;//y por último retornamos los actores
  }
  Future<List<Pelicula>> buscarPelicula( String query ) async {
    final url = Uri.https(_url, '3/search/movie', {
      'api_key'  : _apikey,
      'language' : _language,
      'query'    : query
    });
    return await _procesarRespuesta(url);
  }

}

