import 'package:remotesurveyadmin/api/resource/user_data_source.dart';
import 'package:remotesurveyadmin/api/resource/user_resource.dart';
import 'package:remotesurveyadmin/api/response.dart';
import 'package:remotesurveyadmin/api/response_data.dart';
import 'package:remotesurveyadmin/helper/date_formatter_util.dart';
import 'package:remotesurveyadmin/models/user_model.dart';

class UserRepository {
  late UserResource userDataSource;

  UserRepository({UserResource? userResource}) {
    userDataSource = userResource ?? UserDataSource();
  }

  Future<ResponseData<UserModel>> me(Map<String, dynamic> params) async {
    try {
      print("Request___" + params.toString());
      final ResponseData _result = await userDataSource.fetchProfile(params);
      print(_result.serverResponse);
      if (_result.serverResponse != null) {
        print(_result.serverResponse);
        Response response = _result.serverResponse!;
        print(response.statusDesc);
        print(response.data);
        List names = response.data["names"].toString().split(" ");

        UserModel model = new UserModel(
            email: response.data["email"],
            firstName: names[0],
            lastName: names[1],
            phone: response.data["phone"].toString(),
        registrationDate: response.data["registrationDate"] != null ? response.data["registrationDate"] : DateFormatterUtil().format(date: DateTime(1970)));
        return ResponseData<UserModel>.success(model);
      } else {
        return ResponseData<UserModel>.error(_result.error!.error);
      }
    } catch (error) {
      return ResponseData<UserModel>.error(error);
    }
  }

  Future<ResponseData> authenticateUser(Map<String, Map<String, Object>> map) {
    return userDataSource.authenticate(map);
  }
}
