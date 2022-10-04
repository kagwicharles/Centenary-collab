import 'dart:convert';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'package:rafiki/src/data/constants.dart';
import 'package:rafiki/src/data/local/shared_pref/shared_preferences.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/repository/repository.dart';
import 'package:rafiki/src/utils/app_logger.dart';
import 'package:rafiki/src/utils/crypt_lib.dart';

class TestEndpoint {
  var localDevice, localIv, localToken, tesrequestObjody;
  final dio = Dio();
  Map<String, dynamic> requestObj = {};
  var logger = Logger();
  String currrenrequestObjaseUrl = "";

  TestEndpoint() {
    currrenrequestObjaseUrl = Constants.test ? Constants.uat : Constants.live;
  }

  final _sharedPref = SharedPrefLocal();

  final _moduleRepository = ModuleRepository();
  final _formRepository = FormsRepository();
  final _actionControlRepository = ActionControlRepository();
  final _userCodeRepository = UserCodeRepository();
  final _onlineAccountProductRepository = OnlineAccountProductRepository();
  final _bankBranchRepository = BankBranchRepository();
  final _imageDataRepository = ImageDataRepository();

  securityFeatureSetUp() async {
    localDevice = await SharedPrefLocal.getLocalDevice();
    localIv = await SharedPrefLocal.getLocalIv();
    localToken = await SharedPrefLocal.getLocalToken();
    print("Key: ${CryptLibImpl.toSHA256(localDevice, 32)}, Local IV: $localIv");
  }

  baseRequestSetUp() async {
    var imeiNo = await Constants.getImei();
    requestObj = {
      "UNIQUEID": "ffffffff-a104-c869-0000-00002eac7df5",
      "CustomerID": "4570670220",
      "BankID": "16",
      "Country": "UGANDATEST",
      "VersionNumber": "119",
      "IMEI": "h1AAV9QQ1mxlBqJxVrL97q7mCxduYDdbzIAW9tsQC+A=",
      "IMSI": "h1AAV9QQ1mxlBqJxVrL97q7mCxduYDdbzIAW9tsQC+A=",
      // "IMEI": CryptLibImpl.encryptField(imeiNo),
      // "IMSI": CryptLibImpl.encryptField(imeiNo),
      "TRXSOURCE": "APP",
      "APPNAME": "CENTEMOBILE",
      "CODEBASE": "ANDROID",
      "LATLON": "0.0,0.0"
    };
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
  }

  Future<int> getToken() async {
    var keys = "";
    Map routeMap;
    var routes, device, iv = "";
    var data;
    var token;
    List<int> dataArr;
    List<String> deviceCharArray;

    Map<String, String> requestObj = {
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
        Uri.parse("$currrenrequestObjaseUrl/ElmaAuthDynamic/api/auth/apps"),
        body: requestObj);

    if (response.statusCode == 200) {
      final res = response.body.toString();
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
      routes = CryptLibImpl.decrypt(jsonDecode(res)["payload"]["Routes"],
          CryptLibImpl.toSHA256(keys, 32), iv);
      print("\n\nROUTES REQ: $routes");
      await SharedPrefLocal.addRoutes(json.decode(routes));
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  void getUIData(FormId formId) async {
    String res, status, decrypted;
    await securityFeatureSetUp();
    await baseRequestSetUp();
    requestObj["FormID"] = formId.name;

    final encryptedBody =
        CryptLibImpl.encrypt(jsonEncode(requestObj), localDevice, localIv);
    print("Request..." + requestObj.toString());

    var response =
        dio.post(currrenrequestObjaseUrl + "/ElmaWebDataDynamic/api/elma/data",
            options: Options(
              headers: {'T': localToken},
            ),
            data: {"Data": encryptedBody, "UniqueId": Constants.uniqueId});
    response.then((value) => {
          res = value.data["Response"],
          decrypted = CryptLibImpl.gzipDecompressStaticData(res),
          AppLogger.appLog(tag: "\n\n$formId REQ", message: decrypted),
          addDataToLocalDb(formId, decryptedData: decrypted)
        });
  }

  getStaticData() async {
    String res, decrypted;
    await securityFeatureSetUp();
    await baseRequestSetUp();
    requestObj["FormID"] = "STATICDATA";
    requestObj["SessionID"] = "ffffffff-9ed9-414d-0000-00001d093e12";

    final encryptedBody =
        CryptLibImpl.encrypt(jsonEncode(requestObj), localDevice, localIv);
    final route = await SharedPrefLocal.getRoute("staticdata");
    print("Getting static data...");
    var response = dio.post(route,
        options: Options(
          headers: {'T': localToken},
        ),
        data: {"Data": encryptedBody, "UniqueId": Constants.uniqueId});
    try {
      response.then((value) async => {
            res = value.data["Response"],
            decrypted = CryptLibImpl.gzipDecompressStaticData(res),
            AppLogger.appLog(tag: "\n\nSTATIC DATA REQ:", message: decrypted),
            await _sharedPref.addStaticDataVersion(
                json.decode(decrypted)["StaticDataVersion"]),
            await _sharedPref
                .addAppIdleTimeout(json.decode(decrypted)["AppIdleTimeout"]),
            await clearAllStaticData(),
            json.decode(decrypted)["UserCode"].forEach((item) {
              _userCodeRepository.insertUserCode(UserCode.fromJson(item));
            }),
            json.decode(decrypted)["OnlineAccountProduct"].forEach((item) {
              _onlineAccountProductRepository.insertOnlineAccountProduct(
                  OnlineAccountProduct.fromJson(item));
            }),
            json.decode(decrypted)["BankBranch"].forEach((item) {
              _bankBranchRepository.insertBankBranch(BankBranch.fromJson(item));
            }),
            json.decode(decrypted)["Images"].forEach((item) {
              _imageDataRepository.insertImageData(ImageData.fromJson(item));
            }),
          });
    } catch (e) {
      print("Error: $e");
    }
  }

  dynamicRequest({required requestObj, required webHeader}) async {
    String res, decrypted;
    print('Raw request: $requestObj');
    await securityFeatureSetUp();

    final encryptedBody =
        CryptLibImpl.encrypt(jsonEncode(requestObj), localDevice, localIv);
    final route = await SharedPrefLocal.getRoute(webHeader);

    var response = dio.post(route,
        options: Options(
          headers: {'T': localToken},
        ),
        data: {"Data": encryptedBody, "UniqueId": Constants.uniqueId});
    response.then((value) async => {
          print('Raw response: $value'),
          res = value.data["Response"],
          decrypted = utf8.decode(base64.decode(CryptLibImpl.decrypt(
              base64.normalize(res),
              CryptLibImpl.toSHA256(localDevice, 32),
              localIv))),
          logger.d("\n\nDYNAMIC REQ: $decrypted"),
        });
  }

  login(String pin) async {
    String res, decrypted, status, message = "";
    await securityFeatureSetUp();
    final encryptedPin = CryptLibImpl.encryptField(pin);
    await baseRequestSetUp();
    requestObj["FormID"] = "LOGIN ";
    requestObj["MobileNumber"] = "256782993168";
    requestObj["SessionID"] = "ffffffff-84c8-e77e-0000-00001d093e12";
    requestObj["AppNotificationID"] =
        "fA7TX2IURGmcf7RvUgs-8t:APA91bFj_J3wSeFaUa14L5Zort_Pg3aSaPgksbnPt8dnAaO-2Q5X4pPlmCPPZE4yIlNYyWZF75r8CeJ-6ItxEVigmae8xWZYcsEfg4oA3jPeB8a5wbwfC57PER1w4mchbkk7bzQ8EcxQ";
    requestObj["Login"] = {"LoginType": "PIN"};
    requestObj["EncryptedFields"] = {"PIN": "ifQnUKt1FJLWlyJoLdY3vQ=="};

    print("Request..." + jsonEncode(requestObj));
    final encryptedBody =
        CryptLibImpl.encrypt(jsonEncode(requestObj), localDevice, localIv);
    var response = dio.post(
        currrenrequestObjaseUrl + "/ElmaWebAuthDynamic/api/elma/authentication",
        options: Options(
          headers: {'T': localToken},
        ),
        data: {"Data": encryptedBody, "UniqueId": Constants.uniqueId});
    await response.then((value) => {
          res = value.data["Response"],
          decrypted = utf8.decode(base64.decode(CryptLibImpl.decrypt(
              base64.normalize(res),
              CryptLibImpl.toSHA256(localDevice, 32),
              localIv))),
          status = json.decode(decrypted)["Status"],
          message = json.decode(decrypted)["Message"],
          logger.d("\n\nACTIVATION RESPONSE: $decrypted"),
        });
    debugPrint("Message: $message");
    return message;
  }

  Future<String> activateMobile({mobileNumber, plainPin}) async {
    String res, decrypted;
    var status = "";
    var message = "";
    await securityFeatureSetUp();
    await baseRequestSetUp();
    final encryptedPin =
        CryptLibImpl.encrypt(jsonEncode(plainPin), localDevice, localIv);
    requestObj["FormID"] = "ACTIVATIONREQ";
    requestObj["SessionID"] = Constants.uniqueId;
    requestObj["MobileNumber"] = mobileNumber;
    requestObj["Activation"] = {};
    requestObj["EncryptedFields"] = {"PIN": "$encryptedPin"};
    final encryptedBody =
        CryptLibImpl.encrypt(jsonEncode(requestObj), localDevice, localIv);
    var response = dio.post(
        currrenrequestObjaseUrl + "/ElmaWebAuthDynamic/api/elma/authentication",
        options: Options(
          headers: {'T': localToken},
        ),
        data: {"Data": encryptedBody, "UniqueId": Constants.uniqueId});
    await response.then((value) => {
          res = value.data["Response"],
          decrypted = utf8.decode(base64.decode(CryptLibImpl.decrypt(
              base64.normalize(res),
              CryptLibImpl.toSHA256(localDevice, 32),
              localIv))),
          status = json.decode(decrypted)["Status"],
          message = json.decode(decrypted)["Message"],
          logger.d("\n\nACTIVATION RESPONSE: $decrypted"),
        });
    print("Message: $message");
    return message;
  }

  addDataToLocalDb(FormId formId, {required decryptedData}) {
    switch (formId) {
      case FormId.MENU:
        {
          _moduleRepository.clearTable();
          json
              .decode(decryptedData)[0][DynamicDataType.Modules.name]
              .forEach((item) {
            _moduleRepository.insertModuleItem(ModuleItem.fromJson(item));
          });
        }
        break;
      case FormId.FORMS:
        _formRepository.clearTable();
        json
            .decode(decryptedData)[0][DynamicDataType.FormControls.name]
            .forEach((item) {
          _formRepository.insertFormItem(FormItem.fromJson(item));
        });
        break;
      case FormId.ACTIONS:
        _actionControlRepository.clearTable();
        json
            .decode(decryptedData)[0][DynamicDataType.ActionControls.name]
            .forEach((item) {
          _actionControlRepository
              .insertActionControl(ActionItem.fromJson(item));
        });
        break;
    }
  }

  clearAllStaticData() async {
    _userCodeRepository.clearTable();
    _onlineAccountProductRepository.clearTable();
    _bankBranchRepository.clearTable();
    _imageDataRepository.clearTable();
  }
}
