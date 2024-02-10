import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) {
  getFile();
}

getFile() async {
  File keyFile = File('assets/l10n/keys.txt');
  List<String> keys = await keyFile.readAsLines();

  File fileJson = File('assets/l10n/app_cs.json');
  String read = await fileJson.readAsString();
  Map<String, dynamic> json = jsonDecode(read);
  // print('first');
  // json.forEach((key, value) {
  //   print('$value');
  // });
  // print('-----------------------------------');
  //* new translate
  File file = File('assets/l10n/tln.txt');
  List<String> tln = await file.readAsLines();
  for (int j = 0; j < keys.length; j++) {
    String key = keys[j];
    String tr = tln[j];
    json[key] = tr;
  }
  // json.forEach((key, value) {
  //   print('$value');
  // });
  await fileJson.writeAsString(jsonEncode(json));
  print('done');
}
