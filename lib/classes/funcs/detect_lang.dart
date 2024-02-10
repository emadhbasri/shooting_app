import 'package:flutter/widgets.dart';

// recommend to import 'as langdetect' because this package shows a simple function name 'detect'
import '../../package/flutter_langdetect/flutter_langdetect.dart' as langdetect;

Future<String?> detectlang({String text = "how are you?"}) async {
  WidgetsFlutterBinding.ensureInitialized();

  await langdetect
      .initLangDetect(); // This is needed once in your application after ensureInitialized()

  final language = langdetect.detect(text);
  print('Detected language: $language'); // -> "en"
  return language;
  // final probs = langdetect.detectLangs(text);
  // for (final p in probs) {
  //   if(p.prob>0.9){
  //     print("Language: ${p.lang}");
  //     return p.lang;
  //   }
  //   print("Probability: ${p.prob}");  // -> 0.9999964132193504
  // }
  // return null;
}
