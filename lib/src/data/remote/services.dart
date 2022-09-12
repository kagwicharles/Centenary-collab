import 'dart:convert';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'package:rafiki/src/data/constants.dart';
import 'package:rafiki/src/data/local/shared_pref/shared_preferences.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/repository/repository.dart';
import 'package:rafiki/src/utils/crypt_lib.dart';

class TestEndpoint {
  var localDevice, localIv, localToken, testBody;
  final dio = Dio();
  Map<String, String> tb = {};

  final _moduleRepository = ModuleRepository();
  final _formRepository = FormsRepository();

  baseRequestSetUp(String formId) async {
    localDevice = await SharedPrefLocal.getLocalDevice();
    localIv = await SharedPrefLocal.getLocalIv();
    localToken = await SharedPrefLocal.getLocalToken();

    var imeiNo = await Constants.getImei();
    print("Key: ${CryptLibImpl.toSHA256(localDevice, 32)}, Local IV: $localIv");

    tb = {
      "FormID": formId,
      "UNIQUEID": "ffffffff-a104-c869-0000-00002eac7df5",
      "CustomerID": "25600116",
      "BankID": "16",
      "Country": "UGANDATEST",
      "VersionNumber": "119",
      // '"IMEI"': '"PhopDKGobwkZeMkDgFXa1g=="',
      // '"IMSI"': '"PhopDKGobwkZeMkDgFXa1g=="',
      "IMEI": CryptLibImpl.encryptField(imeiNo),
      "IMSI": CryptLibImpl.encryptField(imeiNo),
      "TRXSOURCE": "APP",
      "APPNAME": "CENTEMOBILE",
      "CODEBASE": "ANDROID",
      "LATLON": "0.0,0.0"
    };
    print("JSON ENCODE TEST: ${jsonEncode(tb)}");

    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
  }

  Future<int> getToken() async {
    var keys = "";
    var routes, device, iv = "";
    var data;
    var token;
    List<int> dataArr;
    List<String> deviceCharArray;

    Map<String, String> requestBody = {
      'appName': Constants.appName,
      'codeBase': Constants.codeBase,
      'Device': Constants.device,
      'lat': Constants.getLat(),
      'longit': Constants.getLong(),
      'MobileNumber': Constants.mobileNumber,
      'rashi': Constants.rashi,
      "UniqueId": Constants.uniqueId
    };

    final response = await http.post(
        Uri.parse("${Constants.baseUrl}/ElmaAuthDynamic/api/auth/apps"),
        body: requestBody);

    if (response.statusCode == 200) {
      final res = response.body.toString();
      routes = jsonDecode(res)["payload"]["Routes"];
      device = jsonDecode(res)["payload"]["Device"];
      data = jsonDecode(res)["data"];
      token = jsonDecode(res)["token"];

      deviceCharArray = device.split('');
      dataArr = data.cast<int>();
      dataArr.forEach((i) {
        keys += deviceCharArray[i];
      });
      iv = jsonDecode(res)["payload"]["Ran"];
      await SharedPrefLocal.addDeviceData(token, keys, iv);
      print(
          "\n\nROUTES REQ: ${CryptLibImpl.decrypt(routes, CryptLibImpl.toSHA256(keys, 32), iv)}");
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  void getModules() async {
    await baseRequestSetUp("MENU");
    String res, decrypted;

    final encryptedBody =
        CryptLibImpl.encrypt(jsonEncode(tb), localDevice, localIv);

    var response =
        dio.post(Constants.baseUrl + "/ElmaWebOtherDynamic/api/elma/other",
            options: Options(
              headers: {'T': localToken},
            ),
            data: {"Data": encryptedBody, "UniqueId": Constants.uniqueId});
    response.then((value) => {
          _moduleRepository.clearTable(),
          res = value.data["Response"],
          decrypted = utf8.decode(base64.decode(CryptLibImpl.decrypt(
              base64.normalize(res),
              CryptLibImpl.toSHA256(localDevice, 32),
              localIv))),
          json.decode(decrypted)[0]["Modules"].forEach((item) {
            _moduleRepository.insertModuleItem(ModuleItem.fromJson(item));
          }),
          print("\n\nMODULES REQ: $decrypted}")
        });
  }

  getForms() async {
    await baseRequestSetUp("FORMS");
    String res, decrypted;

    final encryptedBody =
        CryptLibImpl.encrypt(jsonEncode(tb), localDevice, localIv);
    var response =
        dio.post(Constants.baseUrl + "/ElmaWebOtherDynamic/api/elma/other",
            options: Options(
              headers: {'T': localToken},
            ),
            data: {"Data": encryptedBody, "UniqueId": Constants.uniqueId});
    response.then((value) async => {
          _formRepository.clearTable(),
          res = value.data["Response"],
          decrypted = utf8.decode(base64.decode(CryptLibImpl.decrypt(
              base64.normalize(res),
              CryptLibImpl.toSHA256(localDevice, 32),
              localIv))),
          json.decode(decrypted)[0]["FormControls"].forEach((item) {
            _formRepository.insertFormItem(FormItem.fromJson(item));
          }),
          print("\n\nFORMS REQ: $decrypted"),
        });
  }

  getActionControls() async {
    await baseRequestSetUp("ACTIONS");
    String res, decrypted;

    final encryptedBody =
        CryptLibImpl.encrypt(jsonEncode(tb), localDevice, localIv);
    var response =
        dio.post(Constants.baseUrl + "/ElmaWebOtherDynamic/api/elma/other",
            options: Options(
              headers: {'T': localToken},
            ),
            data: {"Data": encryptedBody, "UniqueId": Constants.uniqueId});
    response.then((value) async => {
          _formRepository.clearTable(),
          res = value.data["Response"],
          decrypted = utf8.decode(base64.decode(CryptLibImpl.decrypt(
              base64.normalize(res),
              CryptLibImpl.toSHA256(localDevice, 32),
              localIv))),
          json.decode(decrypted)[0]["ActionControls"].forEach((item) {
            // _formRepository.insertFormItem(FormItem.fromJson(item));
          }),
          print("\n\nACTION CONTROLS REQ: $decrypted"),
        });
  }
}
