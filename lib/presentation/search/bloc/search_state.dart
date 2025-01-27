import 'package:spotify_clone/domain/entity/song/song.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final Map<String, dynamic> results; // Map hasil pencarian
  SearchLoaded(this.results);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
