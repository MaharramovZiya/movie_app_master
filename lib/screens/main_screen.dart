import 'dart:ui';
// Paketler
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app_riverpod/models/main_page_data.dart';
// AppSize
import 'package:movie_app_riverpod/constant/app_size.dart';

// Modeller
import '../models/search_category.dart';
import 'package:movie_app_riverpod/models/movie.dart';

// Widget'lar
import '../widgets/movie_tile.dart';

// Controller
import '../controllers/main_page_data_controller.dart';

final mainPageDataControllerProvider =
    StateNotifierProvider<MainPageDataController, MainPageData>((ref) {
  return MainPageDataController();
});

class MainScreen extends ConsumerWidget {
  late MainPageDataController _mainPageDataController;
  late MainPageData _mainPageData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _mainPageDataController =
        ref.watch(mainPageDataControllerProvider.notifier);
    _mainPageData = ref.watch(mainPageDataControllerProvider);

    return _buildUI(context, ref);
  }

  Widget _buildUI(BuildContext context, WidgetRef ref) {
    final appWidgetSize = AppWidgetsSize(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Container(
          height: appWidgetSize.height,
          width: appWidgetSize.width,
          child: Stack(
            alignment: Alignment.center,
            children: [_backgroundWidget(context, ref), _foregroundWidget(context, ref)],
          ),
        ));
  }

  Widget _backgroundWidget(BuildContext context, WidgetRef ref) {
    final appWidgetSize = AppWidgetsSize(context);
    final String selectedPosterUrl = ref.watch(mainPageDataControllerProvider).selectedMoviePosterUrl ?? '';

    bool hasValidUrl =
        selectedPosterUrl.isNotEmpty && Uri.tryParse(selectedPosterUrl)?.isAbsolute == true;

    return Container(
      height: appWidgetSize.height,
      width: appWidgetSize.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: hasValidUrl
            ? DecorationImage(
                image: NetworkImage(selectedPosterUrl),
                fit: BoxFit.cover,
              )
            : null, // Sadece URL geçerliyse resmi uygula
      ),
      child: hasValidUrl
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
              child: Container(
                decoration:
                    BoxDecoration(color: Colors.black.withOpacity(0.2)),
              ),
            )
          : Container(
              color: Colors.black.withOpacity(0.2),
            ), // Geçerli bir URL yoksa geri dönüş
    );
  }

  Widget _foregroundWidget(BuildContext context, WidgetRef ref) {
    final appWidgetSize = AppWidgetsSize(context);

    return Container(
      padding: EdgeInsets.fromLTRB(0, appWidgetSize.height * 0.02, 0, 0),
      width: appWidgetSize.width * 0.88,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _topBarWidget(context),
          Container(
            height: appWidgetSize.height * 0.83,
            padding:
                EdgeInsets.symmetric(vertical: appWidgetSize.height * 0.01),
            child: _movieListViewWidget(context, ref),
          )
        ],
      ),
    );
  }

  Widget _topBarWidget(BuildContext context) {
    final appWidgetSize = AppWidgetsSize(context);

    return Container(
      height: appWidgetSize.height * 0.08,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _searchFieldWidget(context),
          _categorySelectionWidget(context)
        ],
      ),
    );
  }

  Widget _searchFieldWidget(BuildContext context) {
    final appWidgetSize = AppWidgetsSize(context);
    final TextEditingController _searchTextFieldController =
        TextEditingController();
    const _border = InputBorder.none;
    _searchTextFieldController.text = _mainPageData.searchText!;
    return SizedBox(
      height: appWidgetSize.height * 0.05,
      width: appWidgetSize.width * 0.50,
      child: TextField(
        controller: _searchTextFieldController,
        onSubmitted: (_input) =>
            _mainPageDataController.updateTextSearch(_input),
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
            focusedBorder: _border,
            border: _border,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white24,
            ),
            hintStyle: TextStyle(color: Colors.white54),
            filled: false,
            fillColor: Colors.white24,
            hintText: "Search..."),
      ),
    );
  }

  Widget _categorySelectionWidget(BuildContext context) {
    return DropdownButton<String>(
      items: [
        DropdownMenuItem(
          value: SearchCategory.popular,
          child: Text(
            SearchCategory.popular,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        DropdownMenuItem(
          value: SearchCategory.upcoming,
          child: Text(
            SearchCategory.upcoming,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        DropdownMenuItem(
          value: SearchCategory.none,
          child: Text(
            SearchCategory.none,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
      onChanged: (_value) => _value.toString().isNotEmpty
          ? _mainPageDataController.updateSearchCategory(_value.toString())
          : null,
      dropdownColor: Colors.black38,
      value: _mainPageData.searchCategory,
      icon: const Icon(
        Icons.menu,
        color: Colors.white24,
      ),
      underline: Container(
        color: Colors.white24,
        height: 1,
      ),
    );
  }

  Widget _movieListViewWidget(BuildContext context, WidgetRef ref) {
    final appWidgetSize = AppWidgetsSize(context);

    final List<Results> _movies = _mainPageData.movies ?? [];

    if (_movies.isNotEmpty) {
      return NotificationListener(
          onNotification: (_onScrollNotification) {
            if (_onScrollNotification is ScrollNotification) {
              final before = _onScrollNotification.metrics.extentBefore;
              final max = _onScrollNotification.metrics.maxScrollExtent;
              if (before == max) {
                _mainPageDataController.getMovies();
                return true;
              }
              return false;
            }
            return false;
          },
          child: ListView.builder(
            itemCount: _movies.length,
            itemBuilder: (context, int count) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: appWidgetSize.height * 0.01, horizontal: 0),
                child: GestureDetector(
                  onTap: () {
                    ref.read(mainPageDataControllerProvider.notifier)
                        .updateSelectedMoviePosterUrl(_movies[count].posterUrl());
                  },
                  child: MovieTile(
                    movie: _movies[count],
                    height: appWidgetSize.height * 0.20,
                    width: appWidgetSize.width * 0.85,
                  ),
                ),
              );
            },
          ));
    } else {
      return const Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: Colors.white,
        ),
      );
    }
  }
}
