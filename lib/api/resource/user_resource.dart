import 'package:remotesurveyadmin/api/response_data.dart';

abstract class UserResource {
  Future<ResponseData> fetchProfile(Map<String, dynamic> params);
  Future<ResponseData> updateProfile(Map<String, dynamic> params);

  Future<ResponseData> newUser(Map<String, dynamic> params);
  Future<ResponseData> authenticate(Map<String, dynamic> params);
  Future<ResponseData> forgotPassword(Map<String, dynamic> params);
  Future<ResponseData> resetPassword(Map<String, dynamic> params);
  Future<ResponseData> otpPassword(Map<String, dynamic> params);
}