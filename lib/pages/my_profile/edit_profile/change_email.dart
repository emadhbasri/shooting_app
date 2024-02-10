import 'package:flutter/material.dart';
import 'package:shooting_app/classes/dataTypes.dart';
import '../../../classes/services/authentication_service.dart';
import '../../../classes/services/my_service.dart';
import '../../../main.dart';
import 'change_email_done.dart';

import '../../../classes/functions.dart';

class ChangeEmail extends StatefulWidget {
  final String email;

  const ChangeEmail({Key? key,required this.email}) : super(key: key);

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  TextEditingController controller=TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text(AppLocalizations.of(context)!.change_email)),
      // backgroundColor: Color.fromRGBO(247, 247, 247, 1),
      body: SizedBox.expand(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: doubleWidth(4)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: doubleHeight(6)),
          Text(
            AppLocalizations.of(context)!.your_current_email_is,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: doubleHeight(2)),
          Text(
            widget.email,
            style: TextStyle(color: grayCall),
          ),
          SizedBox(height: doubleHeight(8)),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.symmetric(horizontal: doubleWidth(8)),
            child: TextField(
              style: TextStyle(
                  color: Colors.black
              ),
              controller: controller,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Color.fromRGBO(214, 216, 217, 1)),
                  hintText: AppLocalizations.of(context)!.enter_new_email,
                  border: InputBorder.none),
            ),
          ),
          SizedBox(height: doubleHeight(8)),
          SizedBox(
            width: double.maxFinite,
            child: ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    // backgroundColor: MaterialStateProperty.all(mainBlue),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: doubleHeight(2.5)))),
                onPressed: () async{
                  if(controller.value.text.trim() !=''){
                    MyService service = getIt<MyService>();
                    bool back = await AuthenticationService.changeEmail(service,
                        controller.value.text);
                    if(back){
                      Go.replaceSlideAnim(context, ChangeEmailDone(email: controller.value.text,));
                    }
                  } else
                    toast(AppLocalizations.of(context)!.please_fill_the_field);
                },
                child: Text(AppLocalizations.of(context)!.verify)),
          )
        ]),
      )),
    );
  }
}
