import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app_riverpod/models/movie.dart';

class MovieTile extends StatelessWidget {
  final GetIt _getIt = GetIt.instance;
  final double height;
  final double width;
  final Results movie;

  MovieTile({required this.movie, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _moviePosterWidget(movie.posterUrl()),
          SizedBox(width: 8), // Add some space between the poster and the info
          Expanded(child: _movieInfoWidget())
        ],
      ),
    );
  }

  Widget _movieInfoWidget() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                movie.title ?? "",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Text(
              "${movie.voteAverage}",
              style: const TextStyle(color: Colors.white, fontSize: 22),
            )
          ],
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, height * 0.02, 0, 0),
          child: Text(
            "${movie.originalLanguage!.toUpperCase()} | R: ${movie.adult} | ${movie.releaseDate}",
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, height * 0.07, 0, 0),
          child: Text(
            movie.overview ?? "",
            maxLines: 9,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        )
      ],
    );
  }

  Widget _moviePosterWidget(String _imageUrl) {
    return Container(
      height: height,
      width: width * 0.35,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
