String capitalize(String value) {
  return value[0].toUpperCase() + value.substring(1);
}

String capitalizeEveryWord(String value) {
  return value.split(' ').map((word) => capitalize(word)).toList().join(' ');
}

String cleanString(String value) {
  String lowercaseString = value.toLowerCase();
  String cleanedString = lowercaseString.replaceAll('&', 'and');
  cleanedString = cleanedString.replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  cleanedString = cleanedString.replaceAll(RegExp(r'^_|_$'), '');
  return cleanedString;
}
