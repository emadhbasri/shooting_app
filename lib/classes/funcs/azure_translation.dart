import 'package:microsoft_azure_translator/microsoft_azure_translator.dart';

Future<String?> azureTranslation({
  String text = "how are you?",
  String start = "en",
  String end = "fa",
}) async {
  MicrosoftAzureTranslator.initialize(
      '60818d93930d42daa52ff4fbe1587575', //sub
      'southafricanorth' //reg
      );

  List<dynamic>? translated = await MicrosoftAzureTranslator.instance.translate(text, start, end);

  if (translated != null) {
    print('received translation from package..');
    print(translated);

    if (translated.isNotEmpty) {
      return translated.first["text"];
    } else {
      return null;
    }
  }
  return null;
}
