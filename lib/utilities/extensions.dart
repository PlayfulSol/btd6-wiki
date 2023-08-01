extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String capitalizeEveryWord() {
    return split(' ').map((str) => str.capitalize()).join(' ');
  }
}
