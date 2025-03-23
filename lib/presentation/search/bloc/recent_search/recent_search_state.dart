abstract class RecentSearchState {}

class RecentSearchInitial extends RecentSearchState {}

class RecentSearchLoading extends RecentSearchState {}

class RecentSearchLoaded extends RecentSearchState {
  final List<String> results; // Map hasil pencarian
  RecentSearchLoaded(this.results);
}

class RecentSearchError extends RecentSearchState {}
