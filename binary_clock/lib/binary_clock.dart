// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:ui';

import 'package:binary_clock/binary_widget.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';

class BinaryClock extends StatefulWidget {
  const BinaryClock(this.model);

  final ClockModel model;

  @override
  _BinaryClockState createState() => _BinaryClockState();
}

class _BinaryClockState extends State<BinaryClock> {
  var _now = DateTime.now();
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';
  var _location = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(BinaryClock oldWidget) {
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
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return getBinaryClock();
  }

  Widget getInfoText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.white70,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget getBinaryClock() {
    final time = DateFormat.Hms().format(DateTime.now());
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Binary clock with time $time',
        value: time,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff223144), Color(0xff112233), Color(0xff0d1421)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  children: <Widget>[
                    getInfoText(_location),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: getInfoText(_condition),
                      ),
                    ),
                    getInfoText(_temperature),
                    getInfoText(_temperatureRange),
                  ],
                ),
              ),
              BinaryTitleContainer(),
              BinaryListContainer(
                value: _now.hour,
              ),
              BinaryListContainer(
                value: _now.minute,
              ),
              BinaryListContainer(
                value: _now.second,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
