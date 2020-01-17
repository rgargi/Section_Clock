import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import './weather_conditions.dart';
import './random_strings.dart';

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
  var _randomString = '';
  Timer _timer;
  double _hourSpent;

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
      _randomString = RandomStrings().getRandomString();
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
          Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
          _updateTime);
      // This calculates the fraction of the hour passed
      _hourSpent = (_dateTime.minute + _dateTime.second / 60) / 60;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final hourwithAmPm = DateFormat('h a').format(_dateTime);
    final fullDate = DateFormat('yMMMMd').format(_dateTime);
    final weekday = DateFormat('EEEE').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final clockTextStyle = TextStyle(
      fontFamily: 'Signika',
      // fontSize: screenWidth / 3.5,
      fontSize: screenHeight * 0.55,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: Colors.grey[300],
          offset: Offset(4, 0),
        ),
      ],
    );
    final detailsTextStyle = TextStyle(
      fontFamily: 'Signika',
      fontSize: screenHeight * 0.05,
    );
    final secondChildTextStyle = TextStyle(
      fontFamily: 'Signika',
      fontSize: screenHeight * 0.11,
      color: barColor(_condition),
    );
    final secondChildTextStyleColorVariant = TextStyle(
      fontFamily: 'Signika',
      fontSize: screenHeight * 0.11,
      color: Colors.grey,
    );

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: barColor(_condition),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedCrossFade(
          crossFadeState: minute == '00'
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 1000),
          firstCurve: Curves.easeOutQuint,
          secondCurve: Curves.easeInQuint,
          firstChild: Center(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(30.0),
              child: RichText(
                text:
                    TextSpan(style: secondChildTextStyle, children: <TextSpan>[
                  TextSpan(text: 'It\'s '),
                  TextSpan(
                    text: hourwithAmPm,
                    style: secondChildTextStyleColorVariant,
                  ),
                  TextSpan(text: ' on a '),
                  TextSpan(
                    text: weekday,
                    style: secondChildTextStyleColorVariant,
                  ),
                  TextSpan(text: ' at '),
                  TextSpan(
                    text: _location,
                    style: secondChildTextStyleColorVariant,
                  ),
                  TextSpan(text: ' and the $_randomString!'),
                ]),
              ),
            ),
          ),
          secondChild: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(hour, style: clockTextStyle),
                  Text(':', style: clockTextStyle),
                  Text(minute, style: clockTextStyle),
                ],
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              Stack(
                children: <Widget>[
                  Container(
                    height: 15,
                    width: screenWidth * 0.75,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(seconds: 2),
                    curve: Curves.linear,
                    height: 15,
                    width: _hourSpent * screenWidth * 0.75,
                    decoration: BoxDecoration(
                      color: barColor(_condition),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
