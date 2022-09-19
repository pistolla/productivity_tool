import 'dart:async';

import 'package:remotesurveyadmin/data/blocs/global/global_bloc.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_state.dart';
import 'package:remotesurveyadmin/data/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remotesurveyadmin/data/blocs/authentication/authentication_event.dart';
import 'package:remotesurveyadmin/storage/token_storage.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final TokenStorage tokenStorage;
  final GlobalBloc mainBloc;
  final UserRepository repository;
  late StreamSubscription<GlobalState> globalSubscription;

  AuthenticationBloc({
    required this.mainBloc,
    required this.tokenStorage,
    required this.repository,
  }) : super(AuthInitial()) {
    globalSubscription = mainBloc.stream.listen((event) {

    });
  }

  @override
  Future<void> close() {
    globalSubscription.cancel();
    return super.close();
  }

  Future<void> checkAuth(emit) async {
    final bool hasToken = await tokenStorage.hasToken();
    if (hasToken) {
      emit(
        Authenticated(),
      );
    } else {
      emit(
        Unauthenticated(),
      );
    }
  }

  Stream<void> logout(emit) async* {
    await tokenStorage.clear();
    yield Logout();
    yield Unauthenticated();
  }

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    await tokenStorage.storeAccessToken(event.accessToken);
    yield Authenticated();
  }
}
