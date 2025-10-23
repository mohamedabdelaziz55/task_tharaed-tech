class ApiConstance {
  static const String baseUrl = "https://api.themoviedb.org/3/";
  static const String apiKey = "72df5a9c5f8a1e8edaf68c5a4a5ee245";

  static const String nowPlayingMoviesPath =
      "${baseUrl}movie/now_playing?api_key=$apiKey";
  static const String popularMoviesPath =
      "${baseUrl}movie/popular?api_key=$apiKey";
  static const String topRatedMoviesPath =
      "${baseUrl}movie/top_rated?api_key=$apiKey";
}
