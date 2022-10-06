import 'package:flutter/material.dart';
import 'package:rafiki/src/data/constants.dart';
import 'package:rafiki/src/data/remote/services.dart';
import 'package:rafiki/src/ui/home/home.dart';
import 'package:rafiki/src/ui/others/map_view.dart';
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
  bool loading = false;
  final _services = TestEndpoint();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        // leading: IconButton(
        //   icon: const Icon(Icons.cancel),
        //   onPressed: (() {
        //
        //   }),
        // ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 24,
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
                                    .then((value) => {
                                          setState(() {
                                            loading = false;
                                          }),
                                          if (value == StatusCode.success)
                                            {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage(
                                                          title: 'Rafiki',
                                                        )),
                                              )
                                            }
                                          else
                                            {
                                              CommonWidgets.buildNormalSnackBar(
                                                  context: context,
                                                  message: value)
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
                        : const Text("LOGIN")),
                const SizedBox(
                  height: 60,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MapView()));
                    },
                    child: const Text("Show maps"))
              ],
            ),
          )),
    );
  }
}
