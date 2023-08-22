import 'package:batsexplorer/models/user_item.dart';
import 'package:batsexplorer/screens/main_screen.dart';
import 'package:batsexplorer/screens/register_screen.dart';
import 'package:batsexplorer/utils/appstate.dart';
import 'package:batsexplorer/utils/customcolors.dart';
import 'package:batsexplorer/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:page_transition/page_transition.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  String _errorMessage = '';
  bool loading = false;

  void onChange() {
    setState(() {
      _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    emailController.addListener(onChange);
    passwordController.addListener(onChange);

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 80.0,
        child: Image.asset('assets/images/logo.png'),
      ),
    );

    final errorMessage = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '$_errorMessage',
        style: TextStyle(fontSize: 14.0, color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );

    final email = TextFormField(
      validator: (value) {
        if (value!.isEmpty || !value.contains('@')) {
          return 'Please enter a valid email.';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: emailController,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: () => node.nextFocus(),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (v) {
        // FocusScope.of(context).requestFocus(node);
      },
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(12),
          backgroundColor: CustomColors.selectedColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            showLoader();
            signIn(emailController.text, passwordController.text).then((user) {
              getDetails(user!);
            }).catchError((error) {
              hideLoader();
              if (error.code == "ERROR_USER_NOT_FOUND") {
                Utils.showSnackBar(
                    context, "Unable to find user. Please register.");
                // setState(() {
                //   _errorMessage = "Unable to find user. Please register.";
                // });
              } else if (error.code == "ERROR_WRONG_PASSWORD") {
                Utils.showSnackBar(context, "Incorrect password.");
                // setState(() {
                //   _errorMessage = "Incorrect password.";
                // });
              } else {
                // setState(() {
                //   _errorMessage =
                //   "There was an error logging in. Please try again later.";
                // });
                Utils.showSnackBar(context,
                    "There was an error logging in. Please try again later.");
              }
            });
          }
        },

        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = ElevatedButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    final registerButton = Padding(
      padding: EdgeInsets.zero,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(12),
          backgroundColor: CustomColors.buttonRegister,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: RegisterScreen()));
        },

        child: Text('Register', style: TextStyle(color: Colors.white)),
      ),
    );
    return LoadingOverlay(
        isLoading: loading,
        color: CustomColors.greyColors,
        progressIndicator: const CircularProgressIndicator(
          backgroundColor: CustomColors.primaryColor,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    logo,
                    SizedBox(height: 24.0),
                    errorMessage,
                    SizedBox(height: 12.0),
                    email,
                    SizedBox(height: 8.0),
                    password,
                    SizedBox(height: 24.0),
                    loginButton,
                    registerButton,
                    // forgotLabel
                  ],
                ),
              ),
            )));
  }

  Future<User?> signIn(final String email, final String password) async {
    UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user;
  }

  void processError(final PlatformException error) {
    if (error.code == "ERROR_USER_NOT_FOUND") {
      setState(() {
        _errorMessage = "Unable to find user. Please register.";
      });
    } else if (error.code == "ERROR_WRONG_PASSWORD") {
      setState(() {
        _errorMessage = "Incorrect password.";
      });
    } else {
      setState(() {
        _errorMessage =
            "There was an error logging in. Please try again later.";
      });
    }
  }

  void getDetails(User user) async {
    debugPrint(user.uid);
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((userData) {
      try {
        UserItem userItem =
            UserItem.fromMap(userData.data() as Map<String, dynamic>);

        AppState.userId = user.uid;
        AppState.email = user.email!;
        AppState.firstname = userItem.firstName;
        AppState.lastname = userItem.lastName;
        AppState.isLogin = true;
        hideLoader();
        AppState.synchronizeSettingsToPhone().then((value) {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft, child: MainScreen(2)));
        });
      } catch (ex) {
        hideLoader();
        debugPrint(ex.toString());
      }
    });
  }

  void showLoader() {
    setState(() {
      loading = true;
    });
  }

  void hideLoader() {
    setState(() {
      loading = false;
    });
  }
}
