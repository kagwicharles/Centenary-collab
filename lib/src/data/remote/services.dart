import 'dart:convert';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'package:rafiki/src/data/constants.dart';
import 'package:rafiki/src/data/local/shared_pref/shared_preferences.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/repository/repository.dart';
import 'package:rafiki/src/utils/crypt_lib.dart';

class TestEndpoint {
  var localDevice, localIv, localToken, testBody;
  final dio = Dio();
  Map<String, dynamic> tb = {};
  var logger = Logger();

  final _sharedPref = SharedPrefLocal();

  final _moduleRepository = ModuleRepository();
  final _formRepository = FormsRepository();
  final _actionControlRepository = ActionControlRepository();
  final _userCodeRepository = UserCodeRepository();
  final _onlineAccountProductRepository = OnlineAccountProductRepository();
  final _bankBranchRepository = BankBranchRepository();
  final _carouselRepository = CarouselRepository();

  baseRequestSetUp() async {
    localDevice = await SharedPrefLocal.getLocalDevice();
    localIv = await SharedPrefLocal.getLocalIv();
    localToken = await SharedPrefLocal.getLocalToken();

    var imeiNo = await Constants.getImei();
    print("Key: ${CryptLibImpl.toSHA256(localDevice, 32)}, Local IV: $localIv");

    tb = {
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

  void getModules() async {
    await baseRequestSetUp();
    tb["FormID"] = "MENU";
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
    await baseRequestSetUp();
    tb["FormID"] = "FORMS";

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
    await baseRequestSetUp();
    tb["FormID"] = "ACTIONS";

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
          _actionControlRepository.clearTable(),
          res = value.data["Response"],
          decrypted = utf8.decode(base64.decode(CryptLibImpl.decrypt(
              base64.normalize(res),
              CryptLibImpl.toSHA256(localDevice, 32),
              localIv))),
          json.decode(decrypted)[0]["ActionControls"].forEach((item) {
            _actionControlRepository
                .insertActionControl(ActionItem.fromJson(item));
          }),
          logger.d("\n\nACTION CONTROLS REQ: $decrypted"),
        });
  }

  getStaticData() async {
    String res, decrypted;
    await baseRequestSetUp();
    tb["FormID"] = "STATICDATA";
    tb["SessionID"] = "ffffffff-9ed9-414d-0000-00001d093e12";
    print('Raw request: $tb');

    final encryptedBody =
        CryptLibImpl.encrypt(jsonEncode(tb), localDevice, localIv);
    final route = await SharedPrefLocal.getRoute("staticdata");
    print("Getting static data...");
    var response = dio.post(route,
        options: Options(
          headers: {'T': localToken},
        ),
        data: {"Data": encryptedBody, "UniqueId": Constants.uniqueId});
    response.then((value) async => {
          print('Raw response: $value'),
          res = value.data["Response"],
          decrypted = CryptLibImpl.gzipDecompressStaticData(res),
          await _sharedPref.addStaticDataVersion(
              json.decode(decrypted)["StaticDataVersion"]),
          await _sharedPref
              .addAppIdleTimeout(json.decode(decrypted)["AppIdleTimeout"]),
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
            _carouselRepository.insertBankBranch(Carousel.fromJson(item));
          }),
          logger.d("\n\nSTATIC DATA REQ: $decrypted"),
        });
  }

  dynamicRequest(String formID,
      {required merchantId,
      required moduleId,
      required data,
      required webHeader}) async {
    await baseRequestSetUp();
    String res, decrypted;
    tb["FormID"] = "DBCALL";
    tb["MerchantID"] = merchantId;
    tb["ModuleID"] = moduleId;
    tb["DynamicForm"] = data;
    print('Raw request: $tb');

    final encryptedBody =
        CryptLibImpl.encrypt(jsonEncode(tb), localDevice, localIv);
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

  Future<String> activateMobile({mobileNumber, plainPin}) async {
    String res, decrypted;
    var status = "";
    var message = "";

    await baseRequestSetUp();
    final encryptedPin =
        CryptLibImpl.encrypt(jsonEncode(plainPin), localDevice, localIv);
    tb["FormID"] = "ACTIVATIONREQ";
    tb["SessionID"] = Constants.uniqueId;
    tb["MobileNumber"] = mobileNumber;
    tb["Activation"] = {};
    tb["EncryptedFields"] = {"PIN": "$encryptedPin"};
    final encryptedBody =
        CryptLibImpl.encrypt(jsonEncode(tb), localDevice, localIv);
    var response = dio
        .post(Constants.baseUrl + "/ElmaWebAuthDynamic/api/elma/authentication",
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
}
