// SizedBox(
//   width: max,
//   height: doubleHeight(9),
//   child: SingleChildScrollView(
//     scrollDirection: Axis.horizontal,
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         Container(
//           width: doubleHeight(9),
//           height: doubleHeight(9),
//           padding: EdgeInsets.all(doubleWidth(2)),
//           child: Container(
//             decoration: BoxDecoration(
//                 color: white,
//                 borderRadius: BorderRadius.circular(100),
//                 image: DecorationImage(
//                   image: AssetImage('images/158023.png'),
//                 )),
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100),
//                 color: mainBlue.withOpacity(0.6),
//               ),
//               child: Center(
//                 child: Icon(
//                   Icons.add,
//                   color: white,
//                   size: doubleWidth(9),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         ...List.generate(15, (index) {
//           return index;
//         })
//             .map(
//               (e) => Container(
//                 width: doubleHeight(9),
//                 height: doubleHeight(9),
//                 padding: EdgeInsets.all(doubleWidth(2)),
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: white,
//                       border: Border.all(color: mainGreen),
//                       borderRadius: BorderRadius.circular(100),
//                       image: DecorationImage(
//                           image: AssetImage('images/158023.png'))),
//                 ),
//               ),
//             )
//             .toList()
//       ],
//     ),
//   ),
// ),
