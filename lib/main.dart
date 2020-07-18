import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mychat/home.dart';
import 'package:mychat/provider/userpreferences.dart';
import 'package:mychat/services/database.dart';
import 'package:mychat/services/helper.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _userLoggedInState;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() {
    HelperFunctions.getUserLoggedInPreference()
        .then((value) => {
          setState((){
            _userLoggedInState = value;
          })
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserPrefs(),
        )
      ],
      child: MaterialApp(
        home: _userLoggedInState != null
            ? _userLoggedInState ? HomePage() : LoginPage()
            : LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  String phoneNumber;
  String verificationCode;
  String optCode;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: TextField(
                      controller: phoneNumberController,
                      onChanged: (value) => this.phoneNumber = value,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        hintText: "Enter Phone Number",
                        labelText: "Phone Number",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 250,
                      height: 50,
                      child: OutlineButton(
                        highlightElevation: 10.0,
                        borderSide: BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        onPressed: _signInWithNumber,
                        child: Text(
                          "Verify and Login",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithNumber() async {
    final PhoneVerificationCompleted verificationSuccess =
        (AuthCredential credential) {
          HelperFunctions.savePhoneNumberSharedPreference(
              phoneNumberController.text);
      Map<String, String> userInfoMap = {
        "phoneNumber": phoneNumberController.text
      };
      databaseMethods.uploadUserInfo(userInfoMap);
          print("Verification Successful and data has been uploaded to FireStore auth");
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException exception) {
      print("Verification failed with following exception: ${exception.message}");
    };

    final PhoneCodeSent phoneCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationCode = verId;
      otpCodeDialog(context).then((value) => print("Code Sent"));
    };

    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeOut = (String verId) {
      print("Code Time Out");
      this.verificationCode = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91$phoneNumber",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationSuccess,
        verificationFailed: verificationFailed,
        codeSent: phoneCodeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeOut);
  }

  Future<bool> otpCodeDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Enter OTP Code",
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
          content: TextField(
            onChanged: (value) {
              optCode = value;
            },
            controller: otpController,
          ),
          contentPadding: EdgeInsets.all(10),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Close",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            FlatButton(
              onPressed: () async {
                await FirebaseAuth.instance.currentUser().then((user) => {
                      if (user != null)
                        {
                          HelperFunctions.saveUserLoggedInPreference(true),
                          Navigator.pop(context),
                          print("Logged in user with uid on this phone : ${user.uid}"),
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          )
                        }
                      else
                        {
                          otpOnOtherPhone(),
                        }
                    }).whenComplete((){phoneNumberController.clear();otpController.clear();}).catchError((e){print("Verification of the number on this phone failed because: $e");});
              },
              child: Text(
                "Verify",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  otpOnOtherPhone() {
    AuthCredential phoneAuthCredential = PhoneAuthProvider.getCredential(
        verificationId: verificationCode, smsCode: otpController.text);
    FirebaseAuth.instance.signInWithCredential(phoneAuthCredential).then(
      (user) {
        HelperFunctions.saveUserLoggedInPreference(true);
        Navigator.pop(context);
        print("Logged in user : $user and uid creation successful");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      },
    ).whenComplete((){phoneNumberController.clear();otpController.clear();}).catchError((e) {
      print("Verification on other phone failed due to: $e");
    }); // TODO show Toast {e== We have blocked all requests from this device due to unusual activity. Try again later.}
  }
}
