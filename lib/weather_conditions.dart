import 'package:flutter/material.dart';

String weatherImage(String condition) {
  if (condition == 'sunny') {
    return '☀️';
  }
  if (condition == 'cloudy') {
    return '☁️';
  }
  if (condition == 'foggy') {
    return '🌫';
  }
  if (condition == 'rainy') {
    return '☔️';
  }
  if (condition == 'snowy') {
    return '☃️';
  }
  if (condition == 'thunderstorm') {
    return '🌩';
  }
  if (condition == 'windy') {
    return '🍃';
  } else {
    return '🤷‍';
  }
}

Color barColor(String condition) {
  if (condition == 'sunny') {
    return Colors.orange[300];
  }
  if (condition == 'snowy') {
    return Colors.lightBlue[200];
  }
  if (condition == 'windy') {
    return Colors.teal[700];
  }
  if (condition == 'cloudy' || condition == 'foggy') {
    return Colors.blueGrey[600];
  } else {
    return Colors.indigo[700];
  }
}
