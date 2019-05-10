import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  final String name;
  final IconData icon;
  final MaterialColor color;

  Category(this.name, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 100,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          highlightColor: this.color,
          splashColor: this.color,
          onTap: () {
            print('I was tapped!');
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  child: Icon(
                    this.icon,
                    size: 60,
                  ),
                  padding: EdgeInsets.all(16.0),
                ),
                Center(
                  child: Text(
                    this.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
