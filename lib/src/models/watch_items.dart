class WatchItems {
  static const int MOVIE = 1;
  static const int TV_SHOW = 2;
  static const int COMIC = 3;
  static const int COMMERCIAL = 4;
  static const int SHORT_MOVIE = 5;
  static const int PRELUDE = 6;

  static String getTitle(int type) {
    switch (type) {
      case WatchItems.MOVIE:
        return "Movie";
      case WatchItems.TV_SHOW:
        return "TV Show";
      case WatchItems.COMIC:
        return "Comic";
      case WatchItems.COMMERCIAL:
        return "Commercial";
      case WatchItems.SHORT_MOVIE:
        return "Short Movie";
      case WatchItems.PRELUDE:
        return "Prelude";
      default:
        return "MCU Content";
    }
  }
}
