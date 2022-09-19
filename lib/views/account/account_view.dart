
import 'package:remotesurveyadmin/api/auth_service.dart';
import 'package:remotesurveyadmin/config/constants.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_bloc.dart';
import 'package:remotesurveyadmin/data/blocs/user/user_bloc.dart';
import 'package:remotesurveyadmin/data/repository/user_repository.dart';
import 'package:remotesurveyadmin/storage/storage_keys.dart';
import 'package:remotesurveyadmin/views/complete_profile/complete_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/views/account/components/body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountView extends StatelessWidget {
  static String routeName = "/account";

  @override
  Widget build(BuildContext context) {
    String env = context.read<GlobalBloc>().state.settings[StorageKeys.SettingEnv];
    UserRepository _repository = UserRepository();
    if (env == "PROD")
      _repository = UserRepository(userResource: AuthService());

    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
          onPressed: () {
            Future.delayed(Duration.zero, () {
              Navigator.pop(context);
            });
          },
        ),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: Colors.white),
            onPressed: () {

              Navigator.pushNamed(context, CompleteProfileView.routeName);
            },
          )
        ],
      ),
      body: BlocProvider(
          create: (context) => UserBloc(
              mainBloc: context.read<GlobalBloc>(),
              userRepository: _repository),
          child: Body()),
    );
  }

}