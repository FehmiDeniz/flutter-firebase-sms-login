import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'sms_auth_state.dart';

class SmsAuthCubit extends Cubit<SmsAuthState> {
  SmsAuthCubit() : super(SmsAuthInitial());

  TextEditingController codeController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
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
      const DropdownMenuItem(
          value: "+1", child: Text("Emulator AreaCode +1")),
    ];
    return menuItems;
  }

  Future<void> verifySms() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+1-555-123-4567',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        verify = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
    emit(SmsVerificationCompleted());
  }

  Future<void> codeSent() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verify!, smsCode: "123456");
    print("credential $credential");
    print("verify $verify");

    await auth.signInWithCredential(credential);
    emit(SmsCodeSent());
  }

  selectedAreaCodeState() {
    emit(SelectedAreaCode());
  }

  selectedCompanyNameState() {
    emit(SelectedCompany());
  }

  setPhoneNumber() {
    if (selectedAreaCode != null && codeController.text.isNotEmpty) {
      var x = selectedAreaCode.toString() + codeController.text;
      emit(SetPhoneNumber());
      print(x);
    } else {
      print("Değer Giriniz!");
    }
  }
}
