import 'package:shooting_app/ui_items/dialogs/privacy.dart';
import 'package:shooting_app/ui_items/shots/index.dart';
import '../../classes/services/authentication_service.dart';
import '../../classes/services/my_service.dart';
import '../../main.dart';
import '../../ui_items/dialogs/team.dart';
import 'login.dart';
import 'team.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController name = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  bool obscureText = true;
  @override
  void initState() {
    statusSet(trans);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decorImage(img: 'assets/images/stadium.jpg'),
      child: Scaffold(
        backgroundColor: trans,
        body: Stack(
          children: <Widget>[
            Container(
              width: max,
              height: max,
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(horizontal: doubleWidth(4.5)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ClipRRect(
                      child: Container(
                        width: max,
                        height: doubleHeight(7),
                        color: Color.fromRGBO(216, 216, 216, 1),
                        child: Center(
                          child: TextField(
                            controller: name,
                            decoration: InputDecoration(
                                prefixText: '        ',
                                border: InputBorder.none,
                                hintText: 'FullName'),
                          ),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    sizeh(doubleHeight(2)),
                    ClipRRect(
                      child: Container(
                        width: max,
                        height: doubleHeight(7),
                        color: Color.fromRGBO(216, 216, 216, 1),
                        child: Center(
                          child: TextField(
                            controller: username,
                            decoration: InputDecoration(
                                prefixText: '        ',
                                border: InputBorder.none,
                                hintText: 'Username'),
                          ),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    sizeh(doubleHeight(2)),
                    ClipRRect(
                      child: Container(
                        width: max,
                        height: doubleHeight(7),
                        color: Color.fromRGBO(216, 216, 216, 1),
                        child: Center(
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: email,
                            decoration: InputDecoration(
                                prefixText: '        ',
                                border: InputBorder.none,
                                hintText: 'Email'),
                          ),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    sizeh(doubleHeight(2)),
                    ClipRRect(
                      child: Container(
                        width: max,
                        height: doubleHeight(7),
                        color: Color.fromRGBO(216, 216, 216, 1),
                        child: Center(
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            controller: phone,
                            decoration: InputDecoration(
                                prefixText: '        ',
                                border: InputBorder.none,
                                hintText: 'PhoneNumber'),
                          ),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // Container(
                    //   width: max,
                    //   child: Text(
                    //     'Use Phone Number?',
                    //     textAlign: TextAlign.right,
                    //     style: TextStyle(
                    //       color: mainGreen,
                    //       fontSize: doubleWidth(3)
                    //     ),
                    //   ),
                    // ),
                    sizeh(doubleHeight(2)),
                    ClipRRect(
                      child: Container(
                        width: max,
                        height: doubleHeight(7),
                        color: Color.fromRGBO(216, 216, 216, 1),
                        child: Center(
                          child: TextField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: password,
                            obscureText: obscureText,
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      obscureText = !obscureText;
                                    });
                                  },
                                  child: Icon(!obscureText
                                      ? Icons.remove_red_eye
                                      : Icons.visibility_off),
                                ),
                                prefixText: '        ',
                                border: InputBorder.none,
                                hintText: 'Password'),
                          ),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    sizeh(doubleHeight(7)),
                    Container(
                      width: max,
                      height: doubleHeight(8),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: RaisedButton(
                          onPressed: () async {
                            if (!phone.value.text.trim().contains('+') ||
                                phone.value.text.trim().length < 12) {
                              toast('The phoneNumber is not a valid.');
                              return;
                            }
                            MyService service = getIt<MyService>();
                            bool back = await AuthenticationService.register(
                                service,
                                fullName: name.value.text.trim(),
                                userName: username.value.text.trim(),
                                phoneNumber: phone.value.text.trim(),
                                email: email.value.text.trim(),
                                password: password.value.text.trim(),
                                confirmPassword: password.value.text.trim());
                            if (back) {
                              service.getToken().then((bool value) {
                                Go.pushSlideAnim(context, Team());
                              });
                            } else {
                              print('nononono');
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: mainBlue,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: doubleWidth(5), color: white),
                          ),
                        ),
                      ),
                    ),
                    sizeh(doubleHeight(3)),
                    GestureDetector(
                      onTap: () {
                        Go.replace(context, Login());
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            children: [
                              TextSpan(text: 'Already have an account?  '),
                              TextSpan(
                                  text: 'Log In',
                                  style: TextStyle(
                                      color: mainGreen,
                                      fontStyle: FontStyle.italic)),
                            ],
                            style: TextStyle(
                              color: white,
                              fontSize: doubleWidth(4.5),
                            )),
                      ),
                    ),
                    Divider(
                      color: gray,
                      height: doubleHeight(6),
                      indent: doubleWidth(6),
                      endIndent: doubleWidth(6),
                      thickness: doubleHeight(0.2),
                    ), //Privacy
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'By signing up you agree to our ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: white,
                            fontSize: doubleWidth(3),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            showDialog(context: context, builder: (_)=>TeamDialog());
                          },
                          child: Text('Terms of Use',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainGreen,
                                  fontSize: doubleWidth(3),
                                  fontStyle: FontStyle.italic)),
                        ),
                        Text(
                          ' and',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: white,
                            fontSize: doubleWidth(3),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: (){
                        showDialog(context: context, builder: (_)=>Privacy());
                      },
                      child: Text('Privacy Policy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: mainGreen,
                              fontSize: doubleWidth(3),
                              fontStyle: FontStyle.italic)),
                    ),
                    // RichText(
                    //   textAlign: TextAlign.center,
                    //   text: TextSpan(
                    //       children: [
                    //         TextSpan(text: 'By signing up you agree to our '),
                    //         TextSpan(
                    //             text: 'Terms of Use',
                    //             style: TextStyle(
                    //                 color: mainGreen,
                    //                 fontStyle: FontStyle.italic)),
                    //         TextSpan(text: ' and'),
                    //         TextSpan(
                    //             text: '\nPrivacy Policy',
                    //             style: TextStyle(
                    //                 color: mainGreen,
                    //                 fontStyle: FontStyle.italic)),
                    //       ],
                    //       style: TextStyle(
                    //         color: white,
                    //         fontSize: doubleWidth(3),
                    //       )),
                    // ),
                    sizeh(doubleHeight(7)),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, -0.7),
              child: Text(
                'WELCOME',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: doubleWidth(5),
                    color: white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
