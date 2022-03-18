import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'tabe.dart';

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

BoxDecoration decorImage({img='images/fskldf.jpg'}){
  return BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.fill,
        image: AssetImage(img),
      ),
      color: white
  );
}

//final BoxDecoration decorImage =BoxDecoration(
//    image: DecorationImage(
//      fit: BoxFit.fill,
//      image: AssetImage('images/fskldf.jpg'),
//    ),
//    color: white
//);
//GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
const globalkey = 5;
class Sahm {
  final int id;
  final String name;
  final String namad;
  final int tedad;
  final int price;
  final int priceNow;
  final BigInt priceAll;
  final int persent;
  final BigInt sood;
  Sahm(this.id, this.name, this.namad, this.tedad, this.price, this.priceNow,
      this.priceAll, this.persent, this.sood);
}
final List<BoxShadow> boxShadow = [
  BoxShadow(
      color: Colors.black38,
      blurRadius: 5,
      spreadRadius: -2,
      offset: Offset(0, 5))
];



final conw = Container(
  color: red,
  width: 50,
  height: 50,
);
const inf = double.infinity;
const max = double.maxFinite;
const non = SizedBox();
Widget sizeh(double h) {
  return SizedBox(height: h);
}

Widget sizew(double w) {
  return SizedBox(width: w);
}






final String yekan = 'IRANYekanMobileRegular';
final String aviny = 'aviny';












BigInt big(source) {
  return BigInt.parse(source.toString());
}

double dob(source) {
  return double.parse(source.toString());
}

int Int(data) {
  return int.parse(data.toString());
}

final inv = '"Invalid Phone"';
final inc = 'Invalid Phone';

//---------------------------------------------server
class Palette {
  static Color primaryColor = Colors.white;
  static Color accentColor = Color(0xff4fc3f7);
  static Color secondaryColor = Colors.black;

  static Color gradientStartColor = accentColor;
  static Color gradientEndColor = Color(0xff6aa8fd);
  static Color errorGradientStartColor = Color(0xffd50000);
  static Color errorGradientEndColor = Color(0xff9b0000);

  static Color primaryTextColorLight = Colors.white;
  static Color secondaryTextColorLight = Colors.white70;
  static Color hintTextColorLight = Colors.white70;

  static Color selfMessageBackgroundColor = blue;
//  Color(0xff4fc3f7);
  static Color otherMessageBackgroundColor = Colors.white;

  static Color selfMessageColor = Colors.white;
  static Color otherMessageColor = Color(0xff3f3f3f);

  static Color greyColor = Colors.grey;
}



