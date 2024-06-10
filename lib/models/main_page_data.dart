import 'package:movie_app_riverpod/models/movie.dart';
import 'package:movie_app_riverpod/models/search_category.dart';

class MainPageData {
  final String searchCategory;
  final String? searchText;
  final List<Results>? movies;
  final int? page;
  final String? selectedMoviePosterUrl;

  MainPageData({
    required this.searchCategory,
    this.searchText,
    this.movies,
    this.page,
    this.selectedMoviePosterUrl,
  });

  factory MainPageData.initial() {
    return MainPageData(
      searchCategory: SearchCategory.popular,
      searchText: '',
      movies: [],
      page: 1,
      selectedMoviePosterUrl: '',
    );
  }

  MainPageData copyWith({
    String? searchCategory,
    String? searchText,
    List<Results>? movies,
    int? page,
    String? selectedMoviePosterUrl,
  }) {
    return MainPageData(
      searchCategory: searchCategory ?? this.searchCategory,
      searchText: searchText ?? this.searchText,
      movies: movies ?? this.movies,
      page: page ?? this.page,
      selectedMoviePosterUrl: selectedMoviePosterUrl ?? this.selectedMoviePosterUrl,
    );
  }
}
