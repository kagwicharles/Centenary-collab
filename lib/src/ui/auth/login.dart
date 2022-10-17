import 'package:flutter/material.dart';
import 'package:rafiki/src/data/constants.dart';
import 'package:rafiki/src/data/remote/services.dart';
import 'package:rafiki/src/data/repository/repository.dart';
import 'package:rafiki/src/data/user_model.dart';
import 'package:rafiki/src/ui/auth/otp_verification.dart';
import 'package:rafiki/src/ui/home/home.dart';
import 'package:rafiki/src/utils/common_libs.dart';
import 'package:rafiki/src/utils/common_widgets.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var mobileController = TextEditingController();
  var pinController = TextEditingController();
  final _services = TestEndpoint();
  final _hiddenModulesRepository = ModuleToHideRepository();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Centenary login"),
        leading: IconButton(
          icon: const Icon(Icons.cancel_rounded),
          onPressed: (() {
            Navigator.of(context).pop();
          }),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
              const SizedBox(
                height: 24,
              ),
              Text(
                "Welcome back!",
                style: Theme
                    .of(context)
                    .textTheme
                    .headline5,
              ),

              const SizedBox(
                height: 18,
              ),
              TextFormField(
                controller: pinController,
                obscureText: true,
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
                    List<ModuleToHide>? hiddenModules;
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      // debugPrint(
                      //     "Encrypted pin...${CryptLibImpl.encryptField(pinController.text)}");
                      Future.delayed(const Duration(milliseconds: 500),
                              () {
                            _services
                                .login(pinController.text)
                                .then((value) async =>
                            {
                              if (value["Status"] ==
                                  StatusCode.success)
                                {
                                  hiddenModules =
                                  await _hiddenModulesRepository
                                      .getAllModulesToHide(),
                                  Future.delayed(
                                      const Duration(
                                          milliseconds: 1000), () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomePage(
                                                  title: 'Rafiki',
                                                  hiddenModules:
                                                  hiddenModules)),
                                    );
                                    pinController.clear();
                                  }),
                                }
                              else
                                {
                                  CommonWidgets.buildNormalSnackBar(
                                      context: context,
                                      message: value["Message"])
                                },
                              setState(() {
                                loading = false;
                              }),
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
                      : const Text("LOGIN")),
              // TextButton(
              //     onPressed: () {
              //       CommonLibs.navigateToRoute(
              //           context: context, widget: const OTPVerification());
              //     },
              //     child: const Text("Go to OTP"))
            ]),
          )),
    );
  }
}
