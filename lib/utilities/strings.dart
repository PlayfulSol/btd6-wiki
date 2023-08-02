String capitalize(value) {
  return value[0].toUpperCase() + value.substring(1);
}

String capitalizeEveryWord(value) {
  return value.split(' ').map((word) => capitalize(word)).toList().join(' ');
}
