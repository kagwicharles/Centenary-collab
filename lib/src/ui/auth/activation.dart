import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:rafiki/src/data/local/shared_pref/shared_preferences.dart';
import 'package:rafiki/src/data/remote/services.dart';
import 'package:rafiki/src/ui/auth/otp_verification.dart';
import 'package:rafiki/src/utils/common_libs.dart';
import 'package:rafiki/src/utils/common_widgets.dart';

class AccountActivation extends StatefulWidget {
  @override
  State<AccountActivation> createState() => _AccountActivationState();
}

class _AccountActivationState extends State<AccountActivation> {
  final _formKey = GlobalKey<FormState>();
  final _sharedPref = SharedPrefLocal();
  final _services = TestEndpoint();
  var mobileController = TextEditingController();
  var pinController = TextEditingController();
  bool loading = false;
  String? _countryCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mobile Activation"),
        leading: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: (() {
            Navigator.of(context).pop();
          }),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 24,
                ),
                Text("Hello Friend!",
                    style: Theme.of(context).textTheme.headline4),
                const SizedBox(
                  height: 8,
                ),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text("Welcome to Centenary Bank",
                        style: Theme.of(context).textTheme.titleMedium)),
                const SizedBox(
                  height: 24,
                ),
                IntlPhoneField(
                  controller: mobileController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Mobile Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode: 'KE',
                  onChanged: (phone) {
                    _countryCode = phone.countryCode;
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  obscureText: true,
                  controller: pinController,
                  decoration: const InputDecoration(hintText: "Enter PIN"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pin';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 34,
                ),
                ElevatedButton(
                    onPressed: loading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                // _sharedPref.addActivationData(
                                //     "256782993168", "4570670220");
                                _services
                                    .activateMobile(
                                        mobileNumber:
                                            formatPhone(mobileController.text),
                                        plainPin: pinController.text)
                                    .then((value) => {
                                          setState(() {
                                            loading = false;
                                          }),
                                          if (value["Status"] == "000")
                                            {
                                              CommonLibs.navigateToRoute(
                                                  context: context,
                                                  widget: OTPVerification(
                                                      mobileNumber: formatPhone(
                                                          mobileController
                                                              .text)))
                                            }
                                          else
                                            {
                                              CommonWidgets.buildNormalSnackBar(
                                                  context: context,
                                                  message: value["Message"])
                                            }
                                        });
                              });
                            }
                          },
                    child: loading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                                CircularProgressIndicator(),
                                SizedBox(
                                  width: 15,
                                ),
                                Text("Please wait...")
                              ])
                        : const Text("ACTIVATE ACCOUNT"))
              ],
            ),
          )),
    );
  }

  String formatPhone(String phoneInput) {
    String code = _countryCode!.substring(1);
    String number = phoneInput.substring(1);
    return code + number;
  }
}
