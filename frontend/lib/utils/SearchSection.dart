class SearchEngineUtils {
  // Filters a list of items based on a query (case-insensitive)
  static List<T> filterList<T>(List<T> items, String query, String Function(T) keySelector) {
    final lowerQuery = query.toLowerCase();
    return items.where((item) => keySelector(item).toLowerCase().contains(lowerQuery)).toList();
  }

  // Sorts a list alphabetically by a specified key
  static List<T> sortAlphabetically<T>(List<T> items, String Function(T) keySelector) {
    items.sort((a, b) => keySelector(a).compareTo(keySelector(b)));
    return items;
  }

  // Highlights query matches in a string
  static String highlightMatches(String text, String query) {
    if (query.isEmpty || !text.toLowerCase().contains(query.toLowerCase())) return text;

    final startIndex = text.toLowerCase().indexOf(query.toLowerCase());
    final endIndex = startIndex + query.length;

    return '${text.substring(0, startIndex)}<b>${text.substring(startIndex, endIndex)}</b>${text.substring(endIndex)}';
  }

  // Generates suggestions based on a query
  static List<String> generateSuggestions(String query, List<String> options) {
    return options.where((option) => option.toLowerCase().startsWith(query.toLowerCase())).toList();
  }
}
