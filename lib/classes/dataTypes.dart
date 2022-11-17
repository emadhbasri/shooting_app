

import 'package:flutter/material.dart';


const warnColor = Color(0xFFFF0266);
const successColor = Color(0xFF0336FF);

const grayCallDark = Color.fromRGBO(120, 120, 120, 1);
const grayCall = Color.fromRGBO(168, 168, 170, 1);
const grayCallLight = Color.fromRGBO(245, 245, 245, 1);
const purple=Colors.purple;
const white = Colors.white;
const black = Colors.black;
const green = Colors.green;
const mainGreen = Color.fromRGBO(78, 255, 187, 1);
const mainGreen1 = Color.fromRGBO(0, 218, 136, 1);
const red = Colors.red;
const pink = Colors.pink;
const gray = Colors.grey;
const trans = Colors.transparent;
const blue = Colors.blue;






const Color myGreenDark = Color(0xFF29363D);
const Color myGreenLight = Color(0xFF4EFFBB);

const Color myPurple = Color(0xFF3F3177);

const Color myGray = Color(0xFF8D98A3);
const Color myGray1 = Color(0xFFA7A7A7);
const Color myGray2 = Color(0xFF8D98A3);
const Color myGray3Shot = Color(0xFF313132);
const TextStyle contentShot = TextStyle(
  color: myGray3Shot,
  fontWeight: FontWeight.w500
);
const TextStyle titleShot = TextStyle(
  color: myGray3Shot,
  fontWeight: FontWeight.w700
);

const Color myBlack = Color(0xFFE0DAFE);
const Color myDarkScaffold = Color(0xFF222D33);
const Color myDarkMatchItem = Color(0xFF29363D);

const Color myInputBack = Color(0xFFF4F4F4);
const Color myInputHint = Color.fromARGB(3, 0, 0, 0);
const Color mySendMessageBack = Color(0xFF8D98A3);
const Color myRed = Color(0xFFF85054);




const Color greenCall = myGreenLight;
const mcolor=myPurple;
const Color mainBlue = myPurple;
const Color mainBlueDark = myGreenDark;

// const Color greenCall = Color.fromRGBO(78, 255, 187, 1);
// const mcolor=Color(0xFF4d53e0);
// const Color mainBlue = Color.fromRGBO(63, 49, 119, 1);
// const Color mainBlueDark = Color(0xFF332940);

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






