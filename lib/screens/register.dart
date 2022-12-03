import 'package:flutter/material.dart';
import '../db/registrationdb.dart';
import '../toastHelper/toastHelper.dart';

class Registration extends StatefulWidget {
  final User user;
  Registration({this.user});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();
  var registration;
  var user;
  var status = false;

  @override
  void initState() {
    super.initState();
    registration = RegistrationHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 80),
              alignment: Alignment.topCenter,
              child: Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'BlackwoodCastleShadow',
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.35,
                  left: 55,
                  right: 55,
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _mailController,
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'kingsbridge',
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          color: Colors.white70,
                          fontFamily: 'RiseofKingdom',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.cyan,
                          width: 5,
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextField(
                      controller: _passwordController,
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'kingsbridge',
                        fontSize: 15,
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color: Colors.white70,
                          fontFamily: 'RiseofKingdom',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.cyan,
                          width: 5,
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: _registerButton,
                          child: Text(
                            'Complete Registration',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, 'login');
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Method: Email, password validation. Also checks if a user is already registered with particular email.
  void _registerButton() {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+"
            r"@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_mailController.text);
    if (!emailValid || _mailController.text.isEmpty) {
      AlertMassage("Email should be valid and not empty", context);
    } else if (_passwordController.text.isEmpty) {
      AlertMassage("Password must not empty", context);
    } else if (_passwordController.text.length < 8) {
      AlertMassage("Password must be al least 8 characters long", context);
    } else {
      User user = User(null, _mailController.text, _passwordController.text);
      registration = RegistrationHelper();

      print(_mailController.text);
      print(_passwordController.text);

      registration
          .isRegistered(_mailController.text)
          .then((value) => setState(() {
                status = value;
                if (!status) {
                  AlertMassage("Already Registered with email", context);
                } else {
                  registration.save(user);
                  ToastMassage("SuccessFully Registered", context);
                  Navigator.pushReplacementNamed(context, 'home');
                }
              }));
    }
  }
}
