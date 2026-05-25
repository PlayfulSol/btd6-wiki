String capitalize(String value) {
  return value[0].toUpperCase() + value.substring(1);
}

String capitalizeEveryWord(String value) {
  return value.split(' ').map((word) => capitalize(word)).toList().join(' ');
}

