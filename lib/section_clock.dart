import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import './weather_conditions.dart';
import './random_strings.dart';

final _lightColors = const [Color(0x00ECE9E6), Color(0x00FFFFFF)];
final _darkColors = const [Colors.black45, Colors.black38];

class SectionClock extends StatefulWidget {
  final ClockModel model;
  const SectionClock(this.model);

  @override
  _SectionClockState createState() => _SectionClockState();
}

class _SectionClockState extends State<SectionClock> {
  var _dateTime = DateTime.now();
  var _temperature = '';
  var _condition = '';
  var _location = '';
  Timer _timer;
  double _hourSpent;
  var _moveBlob = false;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(SectionClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(Duration(minutes: 1) - Duration(seconds: _dateTime.second),
          _updateTime);
      _hourSpent = (_dateTime.minute + _dateTime.second / 60) / 60;
      _moveBlob = !_moveBlob;
    });
  }

  @override
  Widget build(BuildContext context) {
    final blobTravelRange = ([300.0, 500.0, 600.0, 1000.0, 1200.0]..shuffle());
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final fullDate = DateFormat('yMMMMd').format(_dateTime);
    final weekday = DateFormat('EEEE').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightColors
        : _darkColors;

    final clockTextStyle = TextStyle(
      fontFamily: 'Signika',
      fontSize: screenHeight * 0.55,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: Colors.grey[300],
          offset: const Offset(4, 0),
        ),
      ],
    );
    final detailsTextStyle = TextStyle(
      fontFamily: 'Signika',
      fontSize: screenHeight * 0.05,
    );

    return Stack(
      children: <Widget>[
        // This animates the flare actor. Width is selected randomly from a list
        // Height animates only when the hour changes
        AnimatedPositioned(
          curve: Curves.easeOut,
          duration: const Duration(seconds: 10),
          top: _moveBlob ? screenHeight * 0.51 : screenHeight * 0.515,
          width: _moveBlob ? blobTravelRange.first : blobTravelRange.first,
          height: minute == '00' ? screenHeight * 0.8 : screenHeight * 0.5,
          child: Container(
            height: screenHeight * 0.5,
            child: FlareActor(
              'assets/animations/green_leaf_blob.flr',
              fit: BoxFit.contain,
              animation: RandomStrings().getRandomAnimation(),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: colors,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight),
            border: Border.all(
              color: barColor(_condition),
              width: 4,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          // This changes between the main clock face and the hourly message
          child: AnimatedCrossFade(
            crossFadeState: minute == '00'
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 1000),
            firstCurve: Curves.easeOutQuint,
            secondCurve: Curves.easeInQuint,
            firstChild: hourlyMessage(
                condition: _condition,
                location: _location,
                screenHeight: screenHeight),
            secondChild: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(hour, style: clockTextStyle),
                    Text(':', style: clockTextStyle),
                    Text(minute, style: clockTextStyle),
                  ],
                ),
                SizedBox(height: screenHeight * 0.1),
                // This stack contains the hourly progess bar
                Stack(
                  children: <Widget>[
                    Container(
                      height: screenHeight * 0.03,
                      width: screenWidth * 0.75,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.linear,
                      height: screenHeight * 0.03,
                      width: _hourSpent * screenWidth * 0.75,
                      decoration: BoxDecoration(
                        color: barColor(_condition),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // This row displays the current date and weather conditions
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(_temperature, style: detailsTextStyle),
                    Text(' ● '),
                    Text(weatherImage(_condition), style: detailsTextStyle),
                    Text(' '),
                    Text(_condition, style: detailsTextStyle),
                    Text(' ● '),
                    Text(fullDate, style: detailsTextStyle),
                    Text(' ● '),
                    Text(weekday, style: detailsTextStyle),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Every hour this displays a random text string with the hour, day, and location.
Widget hourlyMessage(
    {@required double screenHeight,
    @required String condition,
    @required String location}) {
  final _dateTime = DateTime.now();
  final weekday = DateFormat('EEEE').format(_dateTime);
  final hourwithAmPm = DateFormat('h a').format(_dateTime);
  final _randomString = RandomStrings().getRandomString();
  final hourlyMessageTextStyle = TextStyle(
    fontFamily: 'Signika',
    fontSize: screenHeight * 0.11,
    color: barColor(condition),
  );
  final hourlyMessageTextStyleVariant = TextStyle(
    fontFamily: 'Signika',
    fontSize: screenHeight * 0.11,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );
  return Center(
    child: Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(30.0),
      child: RichText(
        text: TextSpan(style: hourlyMessageTextStyle, children: <TextSpan>[
          const TextSpan(text: 'It\'s '),
          TextSpan(
            text: hourwithAmPm,
            style: hourlyMessageTextStyleVariant,
          ),
          const TextSpan(text: ' on a '),
          TextSpan(
            text: weekday,
            style: hourlyMessageTextStyleVariant,
          ),
          const TextSpan(text: ' at '),
          TextSpan(
            text: location,
          ),
          TextSpan(text: ' and $_randomString!'),
        ]),
      ),
    ),
  );
}
