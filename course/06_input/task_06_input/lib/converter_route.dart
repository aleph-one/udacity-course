// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'unit.dart';

const _padding = EdgeInsets.all(16.0);

/// [ConverterRoute] where users can input amounts to convert in one [Unit]
/// and retrieve the conversion in another [Unit] for a specific [Category].
///
/// While it is named ConverterRoute, a more apt name would be ConverterScreen,
/// because it is responsible for the UI at the route's destination.
class ConverterRoute extends StatefulWidget {
  /// This [Category]'s name.
  final String name;

  /// Color for this [Category].
  final Color color;

  /// Units for this [Category].
  final List<Unit> units;

  /// This [ConverterRoute] requires the name, color, and units to not be null.
  const ConverterRoute({
    @required this.name,
    @required this.color,
    @required this.units,
  })  : assert(name != null),
        assert(color != null),
        assert(units != null);

  @override
  _ConverterRouteState createState() => _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {
  Unit inputUnit;
  String inputText;
  String inputError;

  Unit outputUnit;
  TextEditingController outputText = TextEditingController();

  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  double _parse(String input) {
    double result = double.tryParse(input);
    if (result == null) {
      inputError = 'Not a number';
      return null;
    } else {
      inputError = null;
      return result;
    }
  }

  createDropdown() {
    return widget.units.map((Unit unit) {
      return DropdownMenuItem<Unit>(
        child: Text(unit.name),
        value: unit,
      );
    }).toList();
  }

  convertInput() {
    double x = _parse(this.inputText);
    if (x != null && this.inputUnit != null && this.outputUnit != null) {
      double result = x / this.inputUnit.conversion * this.outputUnit.conversion;
      this.outputText.text =_format(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    var inp = Padding(
      padding: _padding,
      child: Column(
        children: <Widget>[
          TextField(
            onChanged: (input) {
              setState(() {
                this.inputText = input;
                convertInput();
              });
            },
            keyboardType:
                TextInputType.numberWithOptions(decimal: true, signed: true),
            decoration: InputDecoration(
              labelText: 'Input',
              border: OutlineInputBorder(),
              errorText: this.inputError,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              child: DropdownButton(
                isDense: true,
                isExpanded: true,
                underline: null,
                value: this.inputUnit,
                items: createDropdown(),
                onChanged: (unit) {
                  setState(() {
                    this.inputUnit = unit;
                    convertInput();
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
    var comp = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    var outp = Padding(
      padding: _padding,
      child: Column(
        children: <Widget>[
          TextField(
            controller: outputText,
            keyboardType:
                TextInputType.numberWithOptions(decimal: true, signed: true),
            decoration: InputDecoration(
              labelText: 'Output',
              border: OutlineInputBorder(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              child: DropdownButton(
                isDense: true,
                isExpanded: true,
                underline: null,
                value: this.outputUnit,
                items: createDropdown(),
                onChanged: (unit) {
                  setState(() {
                    this.outputUnit = unit;
                    convertInput();
                  });
                },
              ),
            ),
          )
        ],
      ),
    );

    return Padding(
      child: Column(
        children: <Widget>[
          inp,
          comp,
          outp,
        ],
      ),
      padding: _padding,
    );
  }
}
