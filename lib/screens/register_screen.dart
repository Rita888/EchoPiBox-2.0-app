import 'package:batsexplorer/models/user_item.dart';
import 'package:batsexplorer/screens/main_screen.dart';
import 'package:batsexplorer/utils/appstate.dart';
import 'package:batsexplorer/utils/customcolors.dart';
import 'package:batsexplorer/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:page_transition/page_transition.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => new _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  final emailTextEditController = new TextEditingController();
  final firstNameTextEditController = new TextEditingController();
  final lastNameTextEditController = new TextEditingController();
  final passwordTextEditController = new TextEditingController();
  final confirmPasswordTextEditController = new TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _errorMessage = '';
  bool loading = false;

  void processError(final PlatformException error) {
    setState(() {
      _errorMessage = error.message!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
        isLoading: loading,
        color: CustomColors.greyColors,
        progressIndicator: const CircularProgressIndicator(
          backgroundColor: CustomColors.primaryColor,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        child: Scaffold(
          backgroundColor: CustomColors.backgroundColor,
          body: Center(
              child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    padding:
                        EdgeInsets.only(top: 36.0, left: 24.0, right: 24.0),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Register',
                          style:
                              TextStyle(fontSize: 36.0, color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '$_errorMessage',
                          style: TextStyle(fontSize: 14.0, color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email.';
                            }
                            return null;
                          },
                          controller: emailTextEditController,
                          keyboardType: TextInputType.emailAddress,
                          autofocus: true,
                          textInputAction: TextInputAction.next,
                          focusNode: _emailFocus,
                          onFieldSubmitted: (term) {
                            FocusScope.of(context)
                                .requestFocus(_firstNameFocus);
                          },
                          decoration: InputDecoration(
                            hintText: 'Email',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your first name.';
                            }
                            return null;
                          },
                          controller: firstNameTextEditController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          autofocus: false,
                          textInputAction: TextInputAction.next,
                          focusNode: _firstNameFocus,
                          onFieldSubmitted: (term) {
                            FocusScope.of(context).requestFocus(_lastNameFocus);
                          },
                          decoration: InputDecoration(
                            hintText: 'First Name',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your last name.';
                            }
                            return null;
                          },
                          controller: lastNameTextEditController,
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          focusNode: _lastNameFocus,
                          onFieldSubmitted: (term) {
                            FocusScope.of(context).requestFocus(_passwordFocus);
                          },
                          decoration: InputDecoration(
                            hintText: 'Last Name',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.length < 8) {
                              return 'Password must be longer than 8 characters.';
                            }
                            return null;
                          },
                          autofocus: false,
                          obscureText: true,
                          controller: passwordTextEditController,
                          textInputAction: TextInputAction.next,
                          focusNode: _passwordFocus,
                          onFieldSubmitted: (term) {
                            FocusScope.of(context)
                                .requestFocus(_confirmPasswordFocus);
                          },
                          decoration: InputDecoration(
                            hintText: 'Password',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          autofocus: false,
                          obscureText: true,
                          controller: confirmPasswordTextEditController,
                          focusNode: _confirmPasswordFocus,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (passwordTextEditController.text.length > 8 &&
                                passwordTextEditController.text != value) {
                              return 'Passwords do not match.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(12),
                            backgroundColor: CustomColors.buttonRegister,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              showLoader();
                              _firebaseAuth
                                  .createUserWithEmailAndPassword(
                                      email: emailTextEditController.text,
                                      password: passwordTextEditController.text)
                                  .then((onValue) {
                                final UserItem userItem = UserItem();

                                userItem.firstName =
                                    firstNameTextEditController.text;
                                userItem.lastName =
                                    lastNameTextEditController.text;
                                userItem.userId = onValue.user!.uid;
                                userItem.email = emailTextEditController.text;

                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(onValue.user!.uid)
                                    .set(userItem.toMap());
                                hideLoader();
                                AppState.userId = onValue.user!.uid;
                                AppState.email = emailTextEditController.text;
                                AppState.firstname =
                                    firstNameTextEditController.text;
                                AppState.lastname =
                                    lastNameTextEditController.text;
                                AppState.isLogin = true;
                                AppState.synchronizeSettingsToPhone()
                                    .then((value) {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: MainScreen(3)));
                                });
                              }).catchError((onError) {
                                hideLoader();
                                // setState(() {
                                //   _errorMessage = onError.message!;
                                // });
                                Utils.showSnackBar(context, onError.message!);
                              });
                            }
                          },
                          child: Text('Sign Up'.toUpperCase(),
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.zero,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(12),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ))
                    ],
                  ))),
        ));
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
