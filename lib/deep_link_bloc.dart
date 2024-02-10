
// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// abstract class Bloc {
//   void dispose();
// }
// class DeepLinkBloc extends Bloc {

//   //Event Channel creation
//   dynamic stream =  EventChannel('footballbuzz.footballbuzz.co/events');

//   //Method channel creation
//   static const platform = const MethodChannel('footballbuzz.footballbuzz.co/channel');

//   StreamController<String> _stateController = StreamController();

//   Stream<String> get state => _stateController.stream;

//   Sink<String> get stateSink => _stateController.sink;


//   //Adding the listener into contructor
//   DeepLinkBloc() {
//     //Checking application start by deep link
//     startUri().then(_onRedirected);
//     //Checking broadcast stream, if deep link was clicked in opened appication
//     stream.receiveBroadcastStream().listen((d) => _onRedirected(d));
//   }


//   _onRedirected(String uri) {
//     // Here can be any uri analysis, checking tokens etc, if it’s necessary
//     // Throw deep link URI into the BloC's stream
//     stateSink.add(uri);
//   }


//   @override
//   void dispose() {
//     _stateController.close();
//   }


//   Future<String> startUri() async {
//     try {
//       return await platform.invokeMethod('initialLink');
//     } on PlatformException catch (e) {
//       return "Failed to Invoke: '${e.message}'.";
//     }
//   }
// }

// class PocWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context);
//     return StreamBuilder<String>(
//       stream: _bloc.state,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Container(
//               child: Center(
//                   child: Text('No deep link was used  ',
//                       )));
//         } else {
//           return Container(
//               child: Center(
//                   child: Padding(
//                       padding: EdgeInsets.all(20.0),
//                       child: Text('Redirected: ${snapshot.data}',
//                           ))));
//         }
//       },
//     );
//   }
// }