// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:flip_panel/flip_panel.dart';
import 'package:random_color/random_color.dart';


final Color background= Colors.white;
final _lightTheme = {
  background: Colors.white,};


final _darkTheme = {
  background: Colors.black,};

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState  createState() => _DigitalClockState();
}


class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  Color  _color;
  Color  _secondColor;

  final List<ColorHue> _hueType = <ColorHue>[
    ColorHue.green,
    ColorHue.red,
    ColorHue.pink,
    ColorHue.purple,
    ColorHue.blue,
    ColorHue.yellow,
    ColorHue.orange
  ];
  final List<ColorHue> _secondHueType = <ColorHue>[
    ColorHue.blue,
    ColorHue.yellow,
    ColorHue.orange,
    ColorHue.green,
    ColorHue.red,
    ColorHue.pink,
    ColorHue.purple,

  ];
  ColorBrightness _colorLuminosity = ColorBrightness.random;
  ColorSaturation _colorSaturation = ColorSaturation.random;



  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
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
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.


    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.



      _timer = Timer(
        Duration(seconds: 1) -
            /* Duration(seconds: _dateTime.second) -*/
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {




    _color= RandomColor().randomColor(
        colorHue: ColorHue.multiple(colorHues: _hueType),
        colorSaturation: _colorSaturation,
        colorBrightness: _colorLuminosity);
    _secondColor= RandomColor().randomColor(
        colorHue: ColorHue.multiple(colorHues: _secondHueType),
        colorSaturation: _colorSaturation,
        colorBrightness: _colorLuminosity);




    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
    DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final second = DateFormat('ss').format(_dateTime);

    return  Scaffold(
           backgroundColor: colors[background],
      body:  Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
               children:<Widget>[
               FlipWidget(child: hour,bgColor: _color,txtColor: Colors.white,duration: Duration(hours: 1),),

                 GradientText(":",
                   gradient: LinearGradient(
                       colors: [Colors.deepPurple, Colors.deepOrange, Colors.pink]),
                   style: TextStyle(fontSize: 100),),

               FlipWidget(child: minute,bgColor:_secondColor,txtColor: Colors.white,duration: Duration(minutes: 1),),

               GradientText(":",
                gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.deepOrange, Colors.pink]),
                style: TextStyle(fontSize: 100),),

               FlipWidget(child: second,bgColor: _secondColor,txtColor: Colors.white,duration: Duration(seconds: 1),),
               ]),

          ],)
          ),

    );

  }
}

class FlipWidget extends StatelessWidget{
 final  String child;
 final  Color bgColor,txtColor;
 final  Duration duration;
  const FlipWidget({ this.child, this.bgColor, this.txtColor ,this.duration});

  @override
  Widget build(BuildContext context) {
    return FlipPanel.builder(
      itemBuilder: (context, index) =>
          Container(
            alignment: Alignment.center,
            width: 96.0,
            height: 128.0,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Text(
              child,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 80.0,
                  color: txtColor),
            ),
          ),
      itemsCount: child.length,
      period: duration,
      loop: -1,
    );


  }

}



