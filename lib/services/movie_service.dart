import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app_riverpod/models/movie.dart';
import 'package:movie_app_riverpod/services/http_service.dart';

class MovieService {
  final GetIt getIt = GetIt.instance;

  late HttpService _http;

  MovieService() {
    _http = getIt.get<HttpService>();
  }
//get popular movies
  Future<List<Results>> getPopularMovies({int? page}) async {
  Response? _response = await _http.get('/movie/popular', queryParameters: {
    'page': page,
  });

  print('API Response: ${_response?.data}');

  if (_response!.statusCode == 200) {
    Map<String, dynamic> _data = _response.data;
    List<Results> _movies = (_data['results'] as List)
        .map<Results>((_movieData) => Results.fromJson(_movieData))
        .toList();
    return _movies;
  } else {
    throw Exception("Couldn't load popular movies.");
  }
}

//get upcoming movies

  Future<List<Results>> getUpcomingMovies({int? page}) async {
  Response? _response = await _http.get('/movie/upcoming', queryParameters: {
    'page': page,
  });

  print('API Response: ${_response?.data}');

  if (_response!.statusCode == 200) {
    Map<String, dynamic> _data = _response.data;
    List<Results> _movies = (_data['results'] as List)
        .map<Results>((_movieData) => Results.fromJson(_movieData))
        .toList();
    return _movies;
  } else {
    throw Exception("Couldn't load upcoming movies.");
  }
}

  Future<List<Results>> searchMovies(String _searchTerm,{int? page}) async {
  Response? _response = await _http.get('/search/movie', queryParameters: {
    'page': page,
    'query': _searchTerm
  });

  print('API Response: ${_response?.data}');

  if (_response!.statusCode == 200) {
    Map<String, dynamic> _data = _response.data;
    List<Results> _movies = (_data['results'] as List)
        .map<Results>((_movieData) => Results.fromJson(_movieData))
        .toList();
    return _movies;
  } else {
    throw Exception("Couldn't perform movies search.");
  }
}



}


//ucuncu problem olarsa bura bax movie result ile deyisdir