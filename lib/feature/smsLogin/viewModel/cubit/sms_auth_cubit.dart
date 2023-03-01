import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'sms_auth_state.dart';

class SmsAuthCubit extends Cubit<SmsAuthState> {
  SmsAuthCubit() : super(SmsAuthInitial());

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  String? logError;
  String? selectedCompany;
  String? selectedAreaCode;
  String? verify;
  String? inputNumber;

  List<DropdownMenuItem<String>> get companyNames {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
          value: "Sun",
          child: Text(
            "Sun",
            textAlign: TextAlign.center,
          )),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get areaCodes {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
          value: "+90", child: Text("Türkiye Cumhuriyeti +90")),
      const DropdownMenuItem(value: "+1", child: Text("Emulator AreaCode +1")),
    ];
    return menuItems;
  }

  Future<void> verifySms() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: setPhoneNumber(),
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          verify = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
      emit(SmsVerificationCompleted());
      logError = "Verify Sms Accept";
    } catch (e) {
      logError = "Verify Sms Error!";
      emit(SmsVerificationFailed());
    }
  }

  Future<void> codeSent() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verify!, smsCode: codeController.text);

      await auth.signInWithCredential(credential);
      emit(SmsCodeSent());
      logError = "Login Succesfull";
    } catch (e) {
      logError = "Login Error!";
      emit(SmsVerificationFailed());
    }
  }

  selectedAreaCodeState() {
    emit(SelectedAreaCode());
  }

  selectedCompanyNameState() {
    emit(SelectedCompany());
  }

  String? setPhoneNumber() {
    if (selectedAreaCode != null && phoneNumberController.text.isNotEmpty) {
      var x = "$selectedAreaCode-${phoneNumberController.text}";
      emit(SetPhoneNumber());
      print(x);
      return x;
    }
  }
}
