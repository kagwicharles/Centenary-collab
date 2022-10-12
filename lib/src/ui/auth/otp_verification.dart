import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPVerification extends StatefulWidget {
  const OTPVerification({Key? key}) : super(key: key);

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> with CodeAutoFill {
  final _formKey = GlobalKey<FormState>();
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
                      "Fill in OTP received to continue",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child:PinFieldAutoFill(
                      decoration: const BoxLooseDecoration(
                          strokeColorBuilder: FixedColorBuilder(Colors.blue)),
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
                                  setState(() {
                                    _loading = true;
                                  });
                                  // debugPrint(
                                  //     "Encrypted pin...${CryptLibImpl.encryptField(pinController.text)}");

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
                            : const Text("LOGIN")),
                  ],
                ))));
  }
}
