

import 'package:flutter/material.dart';

const Color greenCall = Color.fromRGBO(78, 255, 187, 1);

const warnColor = Color(0xFFFF0266);
const successColor = Color(0xFF0336FF);
const mcolor=Color(0xFF4d53e0);
const grayCallDark = Color.fromRGBO(120, 120, 120, 1);
const grayCall = Color.fromRGBO(168, 168, 170, 1);
const grayCallLight = Color.fromRGBO(245, 245, 245, 1);
const purple=Colors.purple;
const white = Colors.white;
const black = Colors.black;
const green = Colors.green;
const mainGreen = Color.fromRGBO(78, 255, 187, 1);
const red = Colors.red;
const pink = Colors.pink;
const gray = Colors.grey;
const trans = Colors.transparent;
const blue = Colors.blue;
const Color mainBlue = Color.fromRGBO(63, 49, 119, 1);
const gold = Color.fromRGBO(255, 203, 5, 1);
final con = Container(color: red);

BoxDecoration decorImage({required String img}){
  return BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.fill,
        image: AssetImage(img),
      ),
      color: white
  );
}

const max = double.maxFinite;
const non = SizedBox();
Widget sizeh(double h) {
  return SizedBox(height: h);
}

Widget sizew(double w) {
  return SizedBox(width: w);
}






