import 'package:remotesurveyadmin/api/resource/user_resource.dart';
import 'package:remotesurveyadmin/api/response_data.dart';
import 'package:remotesurveyadmin/helper/date_formatter_util.dart';
import 'package:remotesurveyadmin/models/user_model.dart';

class UserDataSource extends UserResource {


  @override
  Future<ResponseData> fetchProfile(Map<String, dynamic> params) {
    Map<String, String> model = {"avatar": "https://i.pravatar.cc/300", "email": "testprofile@place.bo", "names": "petri dish", "registrationDate": DateFormatterUtil().format(date: DateTime.now())};
    return Future.value(ResponseData.success({"status": 1, "statusDesc": "", "data": model}));
  }

  @override
  Future<ResponseData> authenticate(Map<String, dynamic> params) {
    // TODO: implement authenticate
    throw UnimplementedError();
  }

  @override
  Future<ResponseData> forgotPassword(Map<String, dynamic> params) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<ResponseData> newUser(Map<String, dynamic> params) {
    // TODO: implement newUser
    throw UnimplementedError();
  }

  @override
  Future<ResponseData> otpPassword(Map<String, dynamic> params) {
    // TODO: implement otpPassword
    throw UnimplementedError();
  }

  @override
  Future<ResponseData> resetPassword(Map<String, dynamic> params) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<ResponseData<UserModel>> updateProfile(Map<String, dynamic> params) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }
}