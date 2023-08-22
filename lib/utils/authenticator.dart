import '../utils/constants.dart';
import 'dart:async';

import 'appstate.dart';

class Authenticator {

  var nameValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (username,sink){
        // String namePattern = r'(^[a-zA-Z ]*$)';
        String namePattern = r'^[a-z A-Z,.\-]+$';
        RegExp regExp = new RegExp(namePattern);
        if (username.length == 0) {
            sink.addError("Name is Required");
        } else if(!regExp.hasMatch(username)){
            sink.addError("Name must be a-z and A-Z");
        } else{
          sink.add(username);
        }
      }
  );


  var regNumValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (regnum,sink){
        String namePattern = r'(^[a-zA-Z ]*$)';
        RegExp regExp = new RegExp(namePattern);
        if (regnum.length == 0) {
          sink.addError("Registration Num is Required");
        } else{
          sink.add(regnum);
        }
      }
  );


  var stateValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (regnum,sink){
        String namePattern = r'(^[a-zA-Z ]*$)';
        RegExp regExp = new RegExp(namePattern);
        if (regnum.length == 0) {
          sink.addError("State is Required");
        } else{
          sink.add(regnum);
        }
      }
  );

  var genderValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (gender,sink){
        String namePattern = r'(^Male$|^Female$|^Other$)';
        RegExp regExp = new RegExp(namePattern);
        if (gender.length == 0) {
            sink.addError("Name is Required");
        } else if(!regExp.hasMatch(gender)){
            sink.addError("Name must be a-z and A-Z");

        } else{
          sink.add(gender);
        }
      }
  );

  final emailValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (email,sink){
        String emailPattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regExp = new RegExp(emailPattern);
        if (email.length == 0) {
            sink.addError("Email is Required");
        } else if(!regExp.hasMatch(email)){
            sink.addError("Email is not valid");

        } else{
          sink.add(email);
        }
      }
  );



  final numberValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (number,sink){
        String numPattern = r'(^[0-9]*$)';
        RegExp regExp = new RegExp(numPattern);
        if (number.length == 0) {
            sink.addError("Mobile No is Required");
        }
        // else if(number.length<10){
        //     sink.addError("Mobile No must be greater then 10 digits");
        //
        // }
        else if (!regExp.hasMatch(number)) {
            sink.addError("Mobile No must be digits");
        }else{
          sink.add(number);
        }
      }
  );

  final otpValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (number,sink){
        String numPattern = r'(^[0-9]*$)';
        RegExp regExp = new RegExp(numPattern);
        if (number.length == 0) {
          sink.addError("Otp is Required");
        } else if(number.length<4 || number.length>4){
          sink.addError("Otp must be equal to 4 digits");
        } else if (!regExp.hasMatch(number)) {
          sink.addError("Otp must be digits");


        }else{
          sink.add(number);
        }
      }
  );


  final cardNumberValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (number,sink){
        String numPattern = r'(^[0-9]*$)';
        RegExp regExp = new RegExp(numPattern);
        if (number.length == 0) {
          sink.addError("Card Number No is Required");
        } else if(number.length!=16){
          sink.addError("Card Number must 16 digits");
        } else if (!regExp.hasMatch(number)) {
          sink.addError("Card Number must be digits");
        }else{
          sink.add(number);
        }
      }
  );

  final cvvValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (number,sink){
        String numPattern = r'(^[0-9]*$)';
        RegExp regExp = new RegExp(numPattern);
        if (number.length == 0) {
          sink.addError("Cvv is Required");
        } else if(number.length!=3){
          sink.addError("Cvv must 3 digits");

        } else if (!regExp.hasMatch(number)) {
          sink.addError("Cvv must be digits");


        }else{
          sink.add(number);
        }
      }
  );


  final passwordValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (password,sink){
        if (password.length > 7) {
          sink.add(password);
        } else {
          if (password.length == 0) {
            sink.addError("Password is Required");
          } else if (password.length<8) {
              sink.addError("Password must be equal or greater than 8 digits");
          }
        }
      }
  );

  var confirmpasswordValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (confirmPassword,sink){
        if (confirmPassword.length == 0) {
            sink.addError("Confirm Password is required");

        } else if (confirmPassword.length<6) {
            sink.addError("Password must be equal or greater than 6 digits");

        } else{
          sink.add(confirmPassword);
        }
      }
  );


  var dateValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (date,sink){
        if (date.length == 0) {
          sink.addError("Date is Required");
        } else{
          sink.add(date);
        }
      }
  );


  static bool authenticateValue(String field,String value,String pass){
    bool results=false;
    String namePattern = r'(^[a-zA-Z ]*$)';
    String numPattern = r'(^[0-9]*$)';
    String emailPattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    switch(field){
      case Constants.USERNAME:
        RegExp regExp = new RegExp(namePattern);
        if (value.length == 0) {
          results=false;
        } else if (!regExp.hasMatch(value)) {
          results=false;
        }else{
          results = true;
        }
        break;

      case Constants.EMAIL:
        RegExp regExp = new RegExp(emailPattern);
        if (value.length == 0) {
          results= false;
        } else if(!regExp.hasMatch(value)){
          results= false;
        }else{
          results = true;
        }
        break;

    }

    return results;
  }


}