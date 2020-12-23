import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: SixJarsRoute()));
}

class SixJarsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Six Jars Page"),
      backgroundColor: Color(0xff52575D),
    );
  }
}
