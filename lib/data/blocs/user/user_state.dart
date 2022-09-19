import 'package:remotesurveyadmin/data/error/app_error.dart';
import 'package:remotesurveyadmin/models/user_model.dart';

abstract class UserState {
  late UserModel userModel;
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  UserLoaded({required UserModel model}){
    userModel = model;
  }
}

class UserUpdating extends UserState {
  UserUpdating({required UserModel model}){
    userModel = model;
  }
}

class UserErrorWithData extends UserState {
  final UserModel userModel;
  final AppError appError;

  UserErrorWithData({
    required this.userModel,
    required this.appError,
  });
}

class UserError extends UserState {
  final AppError appError;

  UserError({required this.appError});
}
