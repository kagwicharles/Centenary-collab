import 'package:flutter/material.dart';
import 'package:rafiki/src/data/remote/services.dart';
import 'package:rafiki/src/ui/home/home.dart';
import 'package:rafiki/src/utils/common_widgets.dart';
import 'package:rafiki/src/utils/utils.dart';

class AccountActivation extends StatefulWidget {
  @override
  State<AccountActivation> createState() => _AccountActivationState();
}

class _AccountActivationState extends State<AccountActivation> {
  final _formKey = GlobalKey<FormState>();
  var mobileController = TextEditingController();
  var pinController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mobile Activation"),
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: (() {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        title: 'Rafiki',
                      )),
            );
          }),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: mobileController,
                  decoration: InputDecoration(hintText: "Enter Mobile Number"),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: pinController,
                  decoration: InputDecoration(hintText: "Enter PIN"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pin';
                    }
                    return null;
                  },
                ),
                SizedBox(
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
                                TestEndpoint()
                                    .activateMobile(
                                        mobileNumber: mobileController.text,
                                        plainPin: pinController.text)
                                    .then((value) => {
                                          setState(() {
                                            loading = false;
                                          }),
                                          CommonWidgets.buildNormalSnackBar(
                                              context: context, message: value)
                                        });
                              });
                            }
                          },
                    child: loading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                CircularProgressIndicator(),
                                SizedBox(
                                  width: 15,
                                ),
                                Text("Please wait...")
                              ])
                        : Text("ACTIVATE ACCOUNT"))
              ],
            ),
          )),
    );
  }
}
