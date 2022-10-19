import 'package:flutter/material.dart';
import 'package:rafiki/src/data/local/shared_pref/shared_preferences.dart';
import 'package:rafiki/src/data/remote/services.dart';
import 'package:rafiki/src/ui/auth/login.dart';
import 'package:rafiki/src/utils/common_libs.dart';
import 'package:rafiki/src/utils/common_widgets.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPVerification extends StatefulWidget {
  OTPVerification({Key? key, required this.mobileNumber}) : super(key: key);
  String mobileNumber;

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> with CodeAutoFill {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _services = TestEndpoint();
  final _sharedPref = SharedPrefLocal();
  String? appSignature;
  String? otpCode;
  bool _loading = false;

  @override
  void codeUpdated() {
    setState(() {
      otpCode = code!;
    });
  }

  @override
  void initState() {
    super.initState();
    listenForCode();

    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        debugPrint("App signature...$signature");
        appSignature = signature;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("OTP Verification"),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      "Enter OTP sent via sms",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: PinFieldAutoFill(
                          controller: _otpController,
                          decoration: const BoxLooseDecoration(
                              strokeColorBuilder:
                                  FixedColorBuilder(Colors.blue)),
                          currentCode: otpCode,
                          onCodeSubmitted: (code) {},
                          onCodeChanged: (code) {
                            if (code!.length == 6) {
                              FocusScope.of(context).requestFocus(FocusNode());
                            }
                          },
                        )),
                    const SizedBox(
                      height: 34,
                    ),
                    ElevatedButton(
                        onPressed: _loading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  if (_otpController.text.length == 6) {
                                    setState(() {
                                      _loading = true;
                                    });
                                    _services
                                        .verifyOTP(
                                            mobileNumber: widget.mobileNumber,
                                            key: _otpController.text)
                                        .then((value) async => {
                                              setState(() {
                                                _loading = false;
                                              }),
                                              if (value["Status"] == "000")
                                                {
                                                  await _sharedPref
                                                      .addActivationData(
                                                          widget.mobileNumber,
                                                          value["CustomerID"]),
                                                  CommonLibs.navigateToRoute(
                                                      context: context,
                                                      widget: const Login())
                                                }
                                              else
                                                {
                                                  CommonWidgets
                                                      .buildNormalSnackBar(
                                                          context: context,
                                                          message:
                                                              value["Message"])
                                                }
                                            });
                                  }
                                }
                              },
                        child: _loading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                    CircularProgressIndicator(),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text("Please wait...")
                                  ])
                            : const Text("Verify OTP")),
                  ],
                ))));
  }
}
