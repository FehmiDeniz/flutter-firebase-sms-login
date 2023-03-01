part of 'sms_auth_cubit.dart';

@immutable
abstract class SmsAuthState {}

class SmsAuthInitial extends SmsAuthState {}

class SmsVerificationCompleted extends SmsAuthState {}

class SmsVerificationFailed extends SmsAuthState {}

class SmsCodeSent extends SmsAuthState {}

class SelectedCompany extends SmsAuthState {}

class SelectedAreaCode extends SmsAuthState {}

class SetPhoneNumber extends SmsAuthState {}
