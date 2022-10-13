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
import 'package:rafiki/src/data/user_model.dart';
import 'package:rafiki/src/ui/form_components/form_widgets.dart';
import 'package:rafiki/src/utils/app_logger.dart';
import 'package:rafiki/src/utils/common_libs.dart';
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
  final _bankAccountRepository = BankAccountRepository();
  final _frequentAccessedModulesRepository = FrequentAccessedModuleRepository();
  final _beneficiaryRepository = BeneficiaryRepository();
  final _moduleToHideRepository = ModuleToHideRepository();
  final _moduleToDisableRepository = ModuleToDisableRepository();
  final _atmLocationRepository = AtmLocationRepository();
  final _branchLocationRepository = BranchLocationRepository();

  securityFeatureSetUp() async {
    localDevice = await SharedPrefLocal.getLocalDevice();
    localIv = await SharedPrefLocal.getLocalIv();
    localToken = await SharedPrefLocal.getLocalToken();
  }

  baseRequestSetUp() async {
    var imeiNo = await Constants.getImei();
    requestObj = {
      "UNIQUEID": "00000000-40ee-9111-0000-00001d093e12",
      "CustomerID": "4570670220",
      "BankID": "16",
      "Country": "UGANDATEST",
      "VersionNumber": "119",
      "IMEI": CryptLibImpl.encryptField(await CommonLibs.getDeviceUniqueID()),
      "IMSI": CryptLibImpl.encryptField(await CommonLibs.getDeviceUniqueID()),
      "TRXSOURCE": "APP",
      "APPNAME": "CENTEMOBILE",
      "CODEBASE": "ANDROID",
      "LATLON": "0.0,0.0"
    };
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
  }

  Future<int> getToken() async {
    var keys = "";
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
          AppLogger.appLogI(tag: "\n\n$formId REQ", message: decrypted),
          addDataToLocalDb(formId, decryptedData: decrypted),
          AppLogger.writeResponseToFile(
              fileName: formId.name, response: decrypted)
        });
  }

  getStaticData({currentStaticDataVersion}) async {
    String res, decrypted;
    int staticDataVersion;
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
            AppLogger.appLogI(tag: "\n\nSTATIC DATA REQ:", message: decrypted),
            staticDataVersion = json.decode(decrypted)["StaticDataVersion"],
            debugPrint("Updating data version...$staticDataVersion"),
            await _sharedPref.addStaticDataVersion(staticDataVersion),
            if (currentStaticDataVersion != null &&
                currentStaticDataVersion < staticDataVersion)
              {
                getUIData(FormId.MENU),
                getUIData(FormId.FORMS),
                getUIData(FormId.ACTIONS),
              },
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
            json.decode(decrypted)["ATMLocations"].forEach((item) {
              _atmLocationRepository
                  .insertAtmLocation(AtmLocation.fromJson(item));
            }),
            json.decode(decrypted)["BranchLocations"].forEach((item) {
              _branchLocationRepository
                  .insertBranchLocation(BranchLocation.fromJson(item));
            }),
          });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<Map<String, dynamic>> dynamicRequest({
    required requestObj,
    required webHeader,
  }) async {
    String res, decrypted = "";
    AppLogger.appLogE(tag: "Raw request", message: jsonEncode(requestObj));
    await securityFeatureSetUp();

    final encryptedBody =
        CryptLibImpl.encrypt(jsonEncode(requestObj), localDevice, localIv);
    final route = await SharedPrefLocal.getRoute(webHeader);
    debugPrint("Dynamic route...$route");
    var response = dio.post(route,
        options: Options(
          headers: {'T': localToken},
        ),
        data: {"Data": encryptedBody, "UniqueId": Constants.uniqueId});
    InputUtil.encryptedField.clear();
    InputUtil.formInputValues.clear();
    await response.then((value) async => {
          print('Raw response: $value'),
          res = value.data["Response"],
          decrypted = utf8.decode(base64.decode(CryptLibImpl.decrypt(
              base64.normalize(res),
              CryptLibImpl.toSHA256(localDevice, 32),
              localIv))),
          logger.d("\n\nDYNAMIC REQ: $decrypted"),
        });
    Map<String, dynamic> resMap = {};
    resMap["Status"] = jsonDecode(decrypted)["Status"];
    debugPrint(jsonDecode(decrypted)["NotifyText"]);
    resMap["Message"] = jsonDecode(decrypted)["Message"];
    debugPrint("Dynamic res..$resMap");
    return resMap["Status"] == "000" ? jsonDecode(decrypted) : resMap;
  }

  Future<Map<String, dynamic>> login(String pin) async {
    String res, decrypted, message = "";
    String? status;
    var jsonData;
    await securityFeatureSetUp();
    final encryptedPin = CryptLibImpl.encryptField(pin);
    await baseRequestSetUp();
    requestObj["FormID"] = "LOGIN";
    requestObj["MobileNumber"] = "256782993168";
    requestObj["SessionID"] = "ffffffff-84c8-e77e-0000-00001d093e12";
    requestObj["AppNotificationID"] =
        "fA7TX2IURGmcf7RvUgs-8t:APA91bFj_J3wSeFaUa14L5Zort_Pg3aSaPgksbnPt8dnAaO-2Q5X4pPlmCPPZE4yIlNYyWZF75r8CeJ-6ItxEVigmae8xWZYcsEfg4oA3jPeB8a5wbwfC57PER1w4mchbkk7bzQ8EcxQ";
    requestObj["Login"] = {"LoginType": "PIN"};
    requestObj["EncryptedFields"] = {"PIN": "$encryptedPin"};

    AppLogger.appLogE(
        tag: "\n\nLOGIN REQUEST", message: jsonEncode(requestObj));
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
          jsonData = json.decode(decrypted),
          status = jsonData["Status"],
          message = jsonData["Message"],
          if (status == "000")
            {clearAllUserData(), addUserAccountData(jsonData)},
          AppLogger.appLogI(
              tag: "\n\nnACTIVATION RESPONSE", message: decrypted),
          AppLogger.writeResponseToFile(
              fileName: "Login_res", response: decrypted)
        });
    debugPrint("Message: $message");
    Map<String, dynamic> encodedResponse = {};
    encodedResponse["Status"] = status;
    encodedResponse["Message"] = message;
    return encodedResponse;
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

  addUserAccountData(Map<String, dynamic> jsonData) {
    _sharedPref.addUserAccountData(
        key: UserAccountData.FirstName.name, value: jsonData["FirstName"]);
    _sharedPref.addUserAccountData(
        key: UserAccountData.LastName.name, value: jsonData["LastName"]);
    _sharedPref.addUserAccountData(
        key: UserAccountData.IDNumber.name, value: jsonData["IDNumber"]);
    _sharedPref.addUserAccountData(
        key: UserAccountData.EmailID.name, value: jsonData["EMailID"]);
    _sharedPref.addUserAccountData(
        key: UserAccountData.ImageUrl.name, value: jsonData["ImageURL"]);
    _sharedPref.addUserAccountData(
        key: UserAccountData.LastLoginDateTime.name,
        value: jsonData["LastLoginDateTime"]);
    _sharedPref.addStaticDataVersion(jsonData["StaticDataVersion"]);
    jsonData["Accounts"].forEach((item) {
      _bankAccountRepository.insertBankAccount(BankAccount.fromJson(item));
    });
    jsonData["FrequentAccessedModules"].forEach((item) {
      _frequentAccessedModulesRepository
          .insertFrequentModule(FrequentAccessedModule.fromJson(item));
    });
    jsonData["Beneficiary"].forEach((item) {
      _beneficiaryRepository.insertBeneficiary(Beneficiary.fromJson(item));
    });
    jsonData["ModulesToHide"].forEach((item) {
      _moduleToHideRepository.insertModuleToHide(ModuleToHide.fromJson(item));
    });
    jsonData["ModulesToDisable"].forEach((item) {
      _moduleToDisableRepository
          .insertModuleToDisable(ModuleToDisable.fromJson(item));
    });
  }

  clearAllUserData() {
    _bankAccountRepository.clearTable();
    _frequentAccessedModulesRepository.clearTable();
    _beneficiaryRepository.clearTable();
    _moduleToDisableRepository.clearTable();
    _moduleToHideRepository.clearTable();
  }

  clearAllStaticData() async {
    _userCodeRepository.clearTable();
    _onlineAccountProductRepository.clearTable();
    _bankBranchRepository.clearTable();
    _imageDataRepository.clearTable();
    _branchLocationRepository.clearTable();
    _atmLocationRepository.clearTable();
  }
}
