//Lista contenedor de todas las películas que manejamos
class Peliculas {

  List<Pelicula> items = new List();
  Peliculas();
//recibimos el mapa de Json en lista dinámica
  Peliculas.fromJsonList( List<dynamic> jsonList  ) {
//si jsonList es igual a null no hacemos nada
    if ( jsonList == null ) return;
//En cambio si hay datos creamos la lista y lo mandamos a contructor
    for ( var item in jsonList  ) {
      final pelicula = new Pelicula.fromJsonMap(item);
      items.add( pelicula );
    }
  }
}

//Creamos la clase contenedor para gestionar JSON
class Pelicula {
  String uniqueId;
  int voteCount;
  int id;
  bool video;
  double voteAverage;
  String title;
  double popularity;
  String posterPath;
  String originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String backdropPath;
  bool adult;
  String overview;
  String releaseDate;

//contructor de película
  Pelicula({
    this.voteCount,
    this.id,
    this.video,
    this.voteAverage,
    this.title,
    this.popularity,
    this.posterPath,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.backdropPath,
    this.adult,
    this.overview,
    this.releaseDate,
  });

  Pelicula.fromJsonMap( Map<String, dynamic> json ) {
    voteCount        = json['vote_count'];
    id               = json['id'];
    video            = json['video'];
    voteAverage      = json['vote_average'] / 1; //tranformamos de decimal a double
    title            = json['title'];
    popularity       = json['popularity'] / 1;
    posterPath       = json['poster_path'];
    originalLanguage = json['original_language'];
    originalTitle    = json['original_title'];
    genreIds         = json['genre_ids'].cast<int>(); //asignamos a entero
    backdropPath     = json['backdrop_path'];
    adult            = json['adult'];
    overview         = json['overview'];
    releaseDate      = json['release_date'];
  }

  getPosterImg() {//Cogemos la imagen de la caratura
  //Si la imagen no esta regresamos una imagen predeterminada
    if ( posterPath == null ) {
      return 'https://cdn11.bigcommerce.com/s-auu4kfi2d9/stencil/59512910-bb6d-0136-46ec-71c445b85d45/e/933395a0-cb1b-0135-a812-525400970412/icons/icon-no-image.svg';
    } else {//sino regresamos la imagen que nos ha proporcionado el json
      return 'https://image.tmdb.org/t/p/w500/$posterPath';
    }
  }

  getBackgroundImg() {//Cogemos el fondo de la caratula
  //Si la imagen no esta regresamos una imagen predeterminada
    if ( backdropPath == null ) {
      return 'https://cdn11.bigcommerce.com/s-auu4kfi2d9/stencil/59512910-bb6d-0136-46ec-71c445b85d45/e/933395a0-cb1b-0135-a812-525400970412/icons/icon-no-image.svg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$backdropPath';
    }
  }
}


