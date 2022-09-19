import 'dart:async';

import 'package:remotesurveyadmin/api/response_data.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_bloc.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_event.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_state.dart';
import 'package:remotesurveyadmin/data/error/app_error.dart';
import 'package:remotesurveyadmin/data/repository/user_repository.dart';
import 'package:remotesurveyadmin/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final GlobalBloc mainBloc;
  late StreamSubscription<GlobalState> globalSubscription;

  UserBloc({
    required this.userRepository,
    required this.mainBloc,
  }) : super(UserInitial()) {
    globalSubscription = mainBloc.stream.listen((event) {
      if (event is SessionEnded) {
        logout(mainBloc.emit);
      }
    });
  }

  @override
  Future<void> close() {
    globalSubscription.cancel();
    return super.close();
  }

  Future<ResponseData<UserModel>> fetchMe(emit) async {
    String token = mainBloc.state.token;
    String userid = mainBloc.state.userid;
    return userRepository.me({
      "api": {"request": "viewProfile", "token": token, "user": userid},
      "input": {"profile": ""}
    });
  }

  void logout(emit) {
    emit(
      UserInitial(),
    );
  }

  Stream<void> _emitLoading(emit) async* {
    if (state is UserLoaded) {
      yield UserUpdating(model: (((state) as UserLoaded).userModel));
    } else {
      yield UserLoading();
    }
  }

  Stream<void> _emitError(AppError appError, emit) async* {
    if (state is UserLoaded || state is UserUpdating) {
      emit(
        UserErrorWithData(
          userModel: ((state) as UserLoaded).userModel,
          appError: appError,
        ),
      );
      yield UserErrorWithData(
        userModel: ((state) as UserLoaded).userModel,
        appError: appError,
      );
    } else if (state is UserUpdating) {
      emit(
        UserErrorWithData(
          userModel: ((state) as UserUpdating).userModel,
          appError: appError,
        ),
      );
      yield UserErrorWithData(
        userModel: ((state) as UserUpdating).userModel,
        appError: appError,
      );
    } else {
      emit(
        UserError(appError: appError),
      );
      yield UserError(appError: appError);
    }
  }

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserStarted) {
      _emitLoading(emit);
      var value = await fetchMe(emit);
      if (value.error != null)
      {_emitError(value.error!, emit);}
      else
      {
        yield UserLoaded(model: value.serverResponse!);
      }
    }
  }
}
