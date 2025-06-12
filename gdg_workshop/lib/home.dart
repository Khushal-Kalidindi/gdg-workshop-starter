import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

import 'package:flutter/material.dart';

import 'shaped_container.dart';
import 'shape.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Shape> shapes;
  late String journalText;
  //Initialize models here
  
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    journalText = '';
    shapes = [
      Shape(
        R: 25,
        a: 2,
        n: 3,
        width: 200,
        height: 200,
        color: Colors.pink,
        rotationLen: 5,
        top: 100,
        left: 100,
      ),
      Shape(
        R: 25,
        a: 3,
        n: 4,
        width: 200,
        height: 200,
        color: Colors.blue,
        rotationLen: 2,
        top: 0,
        left: 0,
      ),
      
    ];
  }

  void handleButtonPress() async {
    //Add code to handle button press
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Flexible(
                child: TextField(
                  decoration: InputDecoration(labelText: 'Enter Journal'),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: controller,
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // Handle button press
                  handleButtonPress();
                },
                child: Text('Submit'),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: Stack(
              children: shapes.map((shape) {
                return Positioned(
                  top: shape.top,
                  left: shape.left,
                  child: ShapedContainer(
                    width: shape.width,
                    height: shape.height,
                    R: shape.R,
                    a: shape.a,
                    n: shape.n,
                    steps: shape.steps,
                    color: shape.color,
                    rotationLen: shape.rotationLen,
                    child: shape.child,
                  ),
                );
              }).toList(),

              // Add more Positioned widgets for additional shapes
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
