import 'package:flutter/material.dart';
import '../db/registrationdb.dart';
import '../toastHelper/toastHelper.dart';

class LogIn extends StatefulWidget {
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();
  var registration;
  var status;

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
                'Log In',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'BlackwoodCastleShadow',
                  fontWeight: FontWeight.bold,
                  fontSize: 60,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.32,
                  left: 55,
                  right: 55,
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _mailController,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'kingsbridge',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'RiseofKingdom',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
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
                        color: Colors.black,
                        fontFamily: 'kingsbridge',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color: Colors.black,
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
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blueGrey,
                          child: IconButton(
                            color: Colors.black,
                            onPressed: logInButton,
                            icon: Icon(Icons.arrow_forward),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, 'register');
                          },
                          child: Text(
                            'Register / Sign Up',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
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

  /// Method: Checks the login validation
  void logInButton() {
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
      registration = RegistrationHelper();
      registration
          .isValidUser(_mailController.text, _passwordController.text)
          .then((value) => setState(() {
                status = value;
                if (!status) {
                  AlertMassage("Invalid Username or Password", context);
                } else {
                  ToastMassage("SuccessFully Logged In", context);
                  Navigator.pushReplacementNamed(context, 'home');
                }
              }));
    }
  }
}
