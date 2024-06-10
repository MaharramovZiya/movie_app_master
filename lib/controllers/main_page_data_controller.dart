import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app_riverpod/models/movie.dart';
import 'package:movie_app_riverpod/models/search_category.dart';
import 'package:movie_app_riverpod/services/movie_service.dart';
import '../models/main_page_data.dart';

class MainPageDataController extends StateNotifier<MainPageData> {
  MainPageDataController([MainPageData? state])
      : super(state ?? MainPageData.initial()) {
    getMovies();
  }

  final MovieService _movieService = GetIt.instance.get<MovieService>();

  Future<void> getMovies() async {
    try {
      List<Results> _movies = [];

      if (state.searchText!.isEmpty) {
        if (state.searchCategory == SearchCategory.popular) {
          _movies = await _movieService.getPopularMovies(page: state.page);
        } else if (state.searchCategory == SearchCategory.upcoming) {
          _movies = await _movieService.getUpcomingMovies(page: state.page);
        } else if (state.searchCategory == SearchCategory.none) {
          _movies = [];
        }
      } else {
        _movies = await _movieService.searchMovies(state.searchText!);
      }

      print('Fetched Movies: ${_movies.length}');
      state = state.copyWith(
        movies: [...state.movies!, ..._movies],
        page: state.page! + 1,
      );
    } catch (e) {
      print("Error fetching movies: $e");
    }
  }

  // Update dropdown search category and also movies
  void updateSearchCategory(String _category) {
    try {
      state = state.copyWith(
          movies: [], page: 1, searchCategory: _category, searchText: '');
      getMovies();
    } catch (e) {
      print(e);
    }
  }

  // Update search text and fetch movies
  void updateTextSearch(String _searchText) {
    try {
      state = state.copyWith(
          movies: [],
          page: 1,
          searchCategory: SearchCategory.none,
          searchText: _searchText);

      getMovies();
    } catch (e) {
      print(e);
    }
  }

  // Update selected movie poster URL
  void updateSelectedMoviePosterUrl(String newPosterUrl) {
    state = state.copyWith(selectedMoviePosterUrl: newPosterUrl);
  }
}
