import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_sms_app/feature/smsLogin/viewModel/cubit/sms_auth_cubit.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SmsLoginScreen extends StatelessWidget {
  const SmsLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SMS LOGIN"),
        backgroundColor: const Color(0xff850000),
      ),
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => SmsAuthCubit(),
          child: BlocConsumer<SmsAuthCubit, SmsAuthState>(
            listener: (context, state) {},
            builder: (context, state) {
              SmsAuthCubit read = context.read<SmsAuthCubit>();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                          "https://images.sftcdn.net/images/t_app-icon-s/p/8c698566-454e-46fe-b383-fc876fbc81c1/1045246168/sun-ik-logo"),
                      SizedBox(
                        height: 2.h,
                      ),
                      customContainer(
                          DropdownButton(
                            isExpanded: true,
                            hint: Text(
                              read.selectedCompany ?? 'Şirket Seçiniz',
                            ),
                            items: read.companyNames,
                            onChanged: (value) {
                              read.selectedCompany = value;
                              read.selectedCompanyNameState();
                              print(value);
                            },
                          ),
                          Colors.white),
                      customContainer(
                          DropdownButton(
                            isExpanded: true,
                            hint: Text(
                              read.selectedAreaCode ??
                                  'Türkiye Cumhuriyeti +90',
                            ),
                            items: read.areaCodes,
                            onChanged: (value) {
                              read.selectedAreaCode = value;
                              read.selectedAreaCodeState();
                              print(value);
                            },
                          ),
                          Colors.white),
                      customContainer(
                          TextFormField(
                            controller: read.phoneNumberController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Telefon Numarası",
                            ),
                            validator: (value) {
                              return value;
                            },
                          ),
                          Colors.white),
                      Container(
                          margin: EdgeInsets.only(top: 2.h, bottom: 1.h),
                          width: 100.w,
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: const Color(0xff850000),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  read.verifySms();
                                },
                                child: Center(
                                  child: Text(
                                    "Kod Yolla",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ))),
                      SizedBox(
                        height: 5.h,
                      ),
                      customContainer(
                          TextFormField(
                            controller: read.codeController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "6 Haneli Kod",
                            ),
                            validator: (value) {
                              return value;
                            },
                          ),
                          Colors.white),
                      Container(
                          margin: EdgeInsets.only(top: 2.h, bottom: 1.h),
                          width: 100.w,
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: const Color(0xff850000),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  //girilen numarayı alma
                                  read.inputNumber =
                                      read.phoneNumberController.text;
                                  read.setPhoneNumber();
                                  read.phoneNumberController.text = '';
                                  print(read.setPhoneNumber());

                                  // read.verifySms(); //sms yollama kısmı
                                  read.codeSent(); //gelen kodu girdiğinde gidilecek fonksiyon!
                                },
                                child: Center(
                                  child: Text(
                                    "Giriş Yap",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ))),
                      Text("Durum  ${read.logError ?? ''}")
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Container customContainer(Widget widget, Color color) {
    return Container(
      height: 6.h,
      margin: EdgeInsets.all(2.w),
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black, width: 0.4),
          borderRadius: BorderRadius.circular(2.w)),
      child: widget,
    );
  }
}


//devam et'e basınca read.verifySms();
//bir sonraki kısımda codesent() 
//girip girilmediğini kontrol et ve yazdır
//textfield ile girilen telefon numarasını ayarla 