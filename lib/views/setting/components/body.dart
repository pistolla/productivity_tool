import 'package:remotesurveyadmin/config/constants.dart';
import 'package:remotesurveyadmin/config/size_config.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_bloc.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_event.dart';
import 'package:remotesurveyadmin/helper/date_formatter_util.dart';
import 'package:remotesurveyadmin/storage/storage_keys.dart';
import 'package:remotesurveyadmin/widgets/adaptive/alert_dialog/adaptive_form_dialog_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;
  static const channel = MethodChannel('com.mpaya.remotesurveyadmin/ringtones');
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  var settingEnv;
  var settingBio;
  var settingLang;
  var settingRemember;
  var settingOffline;
  var settingNotify;
  var settingCurrency;
  var settingNotificationSound;
  var settingDateFormat;
  var settingTimezone;
  var settingRememberUsername;
  var settingRememberPassword;
  var settingFirstDay;
  var settingUnitWater;
  var settingUnitElectricity;
  var settingUnitGas;

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    loadSettings();
    return SingleChildScrollView(
        child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 20.0),
      height: getProportionateScreenHeight(730),
      child: buildSettingsList(),
    ));
  }

  Widget buildSettingsList() {
    return SettingsList(
      sections: [
        SettingsSection(
          title: Text('Common'),
          tiles: [
            SettingsTile(
              title: Text('Language'),
              trailing: Text("$settingLang"),
              leading: Icon(Icons.language),
              onPressed: (context) {},
            ),
            SettingsTile(
              title: Text('Timezone'),
              trailing: Text("$settingTimezone"),
              leading: Icon(Icons.language),
              onPressed: (context) {},
            ),
            CustomSettingsTile(
              child: Container(
                color: Color(0xFFEFEFF4),
                padding: EdgeInsetsDirectional.only(
                  start: 14,
                  top: 12,
                  bottom: 30,
                  end: 14,
                ),
                child: Text(
                  'You cant change the language, timezone in this version',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w400,
                    fontSize: 13.5,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
            SettingsTile(
              title: Text('Environment'),
              trailing: Text(settingEnv == "PROD" ? "Production" : "Testing"),
              leading: Icon(Icons.cloud_queue),
              onPressed: (context) {
                AdaptiveFormDialogFactory.showOKAlert(context,
                    title: 'Environment',
                    child: StatefulBuilder(builder: (context, setState) {
                  return Container(
                    height: 150,
                    width: 400,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: 400,
                            height: 50,
                            child: ListTile(
                              title: Text("Production"),
                              leading: Radio(
                                  value: "PROD",
                                  groupValue: settingEnv,
                                  onChanged: (value) {
                                    setState(() {
                                      settingEnv = value;
                                    });
                                  }),
                            ),
                          ),
                          SizedBox(
                            width: 400,
                            height: 50,
                            child: ListTile(
                              title: Text("Testing"),
                              leading: Radio(
                                  value: "DEBUG",
                                  groupValue: settingEnv,
                                  onChanged: (value) {
                                    setState(() {
                                      settingEnv = value;
                                    });
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }), onPressed: () {
                  Future.delayed(Duration.zero, () {
                    context.read<GlobalBloc>().add(SettingChanged(
                        settings: {StorageKeys.SettingEnv: settingEnv}));
                    Navigator.pop(context);
                    loadSettings();
                  });
                });
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text('Account'),
          tiles: [
            SettingsTile.switchTile(
              title: Text('Remember Me'),
              leading: Icon(Icons.check_box_outlined),
              onToggle: (bool value) {
                setState(() {
                  settingRemember = value;
                  settingRememberPassword =
                      value ? settingRememberPassword : "";
                  settingRememberUsername =
                      value ? settingRememberUsername : "";
                });
                Future.delayed(Duration.zero, () {
                  context.read<GlobalBloc>().add(SettingChanged(settings: {
                        StorageKeys.SettingRememberMe: settingRemember
                      }));
                  loadSettings();
                });
              },
              initialValue: settingRemember,
            ),
            SettingsTile(
              title: Text('Username'),
              leading: Icon(Icons.person),
              trailing: Text("$settingRememberUsername"),
            ),
            SettingsTile(
              title: Text('Password'),
              leading: Icon(Icons.lock_outline),
              trailing: Text(settingRememberPassword != null
                  ? settingRememberPassword.replaceAll(RegExp(r'^[A-Za-z0-9]+$'), "*")
                  : ""),
            ),
          ],
        ),
        SettingsSection(
          title: Text('Data Formatting'),
          tiles: [
            SettingsTile(
              title: Text('Date Format'),
              leading: Icon(Icons.phone),
              trailing: Text(DateFormatterUtil()
                  .format(date: DateTime.now(), pattern: settingDateFormat)),
              onPressed: (context) => {
                AdaptiveFormDialogFactory.showOKAlert(context,
                    title: 'Select date formatting',
                    child: StatefulBuilder(builder: (context, setState) {
                  return Container(
                    height: 150,
                    width: 400,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: 400,
                            height: 50,
                            child: ListTile(
                              title: Text("MM/dd/yyyy"),
                              leading: Radio(
                                  value: "MM/dd/yyyy",
                                  groupValue: settingDateFormat,
                                  onChanged: (value) {
                                    setState(() {
                                      settingDateFormat = value;
                                    });
                                  }),
                            ),
                          ),
                          SizedBox(
                            width: 400,
                            height: 50,
                            child: ListTile(
                              title: Text("dd/MM/yyyy"),
                              leading: Radio(
                                  value: "dd/MM/yyyy",
                                  groupValue: settingDateFormat,
                                  onChanged: (value) {
                                    setState(() {
                                      settingDateFormat = value;
                                    });
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }), onPressed: () {
                  Future.delayed(Duration.zero, () {
                    context.read<GlobalBloc>().add(SettingChanged(settings: {
                          StorageKeys.SettingDateFormat: settingDateFormat
                        }));
                    Navigator.pop(context);
                    loadSettings();
                  });
                })
              },
            ),
            SettingsTile(
              title: Text('Currency'),
              trailing: Text("$settingCurrency"),
              leading: Icon(Icons.monetization_on_outlined),
              onPressed: (context) => {
                AdaptiveFormDialogFactory.showOKAlert(context,
                    title: 'Select Currency',
                    child: StatefulBuilder(builder: (context, setState) {
                  return Container(
                    height: 150,
                    width: 400,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: 400,
                            height: 50,
                            child: ListTile(
                              title: Text("Kenyan Shilling"),
                              leading: Radio(
                                  value: "KES",
                                  groupValue: settingCurrency,
                                  onChanged: (value) {
                                    setState(() {
                                      settingCurrency = value;
                                    });
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }), onPressed: () {
                  Future.delayed(Duration.zero, () {
                    context.read<GlobalBloc>().add(SettingChanged(settings: {
                          StorageKeys.SettingCurrency: settingCurrency
                        }));
                    Navigator.pop(context);
                    loadSettings();
                  });
                })
              },
            ),
            SettingsTile(
              title: Text('First Day of Week'),
              trailing: Text(settingFirstDay == DateTime.monday
                  ? "Monday"
                  : settingFirstDay == DateTime.tuesday
                      ? "Tuesday"
                      : settingFirstDay == DateTime.wednesday
                          ? "Wednesday"
                          : settingFirstDay == DateTime.thursday
                              ? "Thursday"
                              : settingFirstDay == DateTime.friday
                                  ? "Friday"
                                  : settingFirstDay == DateTime.saturday
                                      ? "Saturday"
                                      : settingFirstDay == DateTime.sunday
                                          ? "Sunday"
                                          : "Not set"),
              leading: Icon(Icons.calendar_today),
              onPressed: (context) => {
                AdaptiveFormDialogFactory.showOKAlert(context,
                    title: 'Select Day of the Week',
                    child: StatefulBuilder(builder: (context, setState) {
                  return Container(
                    height: 150,
                    width: 400,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: 400,
                            height: 50,
                            child: ListTile(
                              title: Text("Sunday"),
                              leading: Radio(
                                  value: DateTime.sunday,
                                  groupValue: settingFirstDay,
                                  onChanged: (value) {
                                    setState(() {
                                      settingFirstDay = value;
                                    });
                                  }),
                            ),
                          ),
                          SizedBox(
                            width: 400,
                            height: 50,
                            child: ListTile(
                              title: Text("Monday"),
                              leading: Radio(
                                  value: DateTime.monday,
                                  groupValue: settingFirstDay,
                                  onChanged: (value) {
                                    setState(() {
                                      settingFirstDay = value;
                                    });
                                  }),
                            ),
                          ),
                          SizedBox(
                            width: 400,
                            height: 50,
                            child: ListTile(
                              title: Text("Tuesday"),
                              leading: Radio(
                                  value: DateTime.tuesday,
                                  groupValue: settingFirstDay,
                                  onChanged: (value) {
                                    setState(() {
                                      settingFirstDay = value;
                                    });
                                  }),
                            ),
                          ),
                          SizedBox(
                            width: 400,
                            height: 50,
                            child: ListTile(
                              title: Text("Wednesday"),
                              leading: Radio(
                                  value: DateTime.wednesday,
                                  groupValue: settingFirstDay,
                                  onChanged: (value) {
                                    setState(() {
                                      settingFirstDay = value;
                                    });
                                  }),
                            ),
                          ),
                          SizedBox(
                            width: 400,
                            height: 50,
                            child: ListTile(
                              title: Text("Thursday"),
                              leading: Radio(
                                  value: DateTime.thursday,
                                  groupValue: settingFirstDay,
                                  onChanged: (value) {
                                    setState(() {
                                      settingFirstDay = value;
                                    });
                                  }),
                            ),
                          ),
                          SizedBox(
                            width: 400,
                            height: 50,
                            child: ListTile(
                              title: Text("Friday"),
                              leading: Radio(
                                  value: DateTime.friday,
                                  groupValue: settingFirstDay,
                                  onChanged: (value) {
                                    setState(() {
                                      settingFirstDay = value;
                                    });
                                  }),
                            ),
                          ),
                          SizedBox(
                            width: 400,
                            height: 50,
                            child: ListTile(
                              title: Text("Saturday"),
                              leading: Radio(
                                  value: DateTime.saturday,
                                  groupValue: settingFirstDay,
                                  onChanged: (value) {
                                    setState(() {
                                      settingFirstDay = value;
                                    });
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }), onPressed: () {
                  Future.delayed(Duration.zero, () {
                    context.read<GlobalBloc>().add(SettingChanged(settings: {
                          StorageKeys.SettingFirstDay: settingFirstDay
                        }));
                    Navigator.pop(context);
                    loadSettings();
                  });
                })
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text('Notifications'),
          tiles: [
            SettingsTile.switchTile(
              title: Text('Enable Notifications'),
              enabled: settingOffline == false,
              leading: Icon(Icons.notifications_active),
              initialValue: settingNotify,
              onToggle: (value) {
                setState(() => {settingNotify = value});
                context.read<GlobalBloc>().add(SettingChanged(settings: {
                      StorageKeys.SettingNotifications: settingNotify
                    }));
                loadSettings();
              },
            ),
            SettingsTile(
              title: Text('Notification Sound'),
              trailing: Text("$settingNotificationSound"),
              leading: Icon(Icons.ring_volume),
              onPressed: (context) => {
                AdaptiveFormDialogFactory.showOKAlert(context,
                    title: 'Select Notification Ringtone',
                    child: StatefulBuilder(builder: (context, setState) {
                  return Container(
                    height: 150,
                    width: 400,
                    child: SingleChildScrollView(
                        child: FutureBuilder(
                      future: channel.invokeMethod('getAllRingtones'),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("loading..."),
                            );
                          } else if (snapshot.hasData) {
                            final data = snapshot.data as List;

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (var s in data)
                                  SizedBox(
                                    width: 400,
                                    height: 50,
                                    child: ListTile(
                                      title: Text("$s"),
                                      leading: Radio(
                                          value: "$s",
                                          groupValue: settingNotificationSound,
                                          onChanged: (value) {
                                            setState(() {
                                              settingNotificationSound = value;
                                            });
                                          }),
                                    ),
                                  ),
                              ],
                            );
                          } else {
                            return Center(child: Text("Loading ringtones..."));
                          }
                        } else {
                          return Center(child: Text("Loading ringtones..."));
                        }
                      },
                    )),
                  );
                }), onPressed: () {
                  Future.delayed(Duration.zero, () {
                    context.read<GlobalBloc>().add(SettingChanged(settings: {
                          StorageKeys.SettingNotificationSound:
                              settingNotificationSound
                        }));
                    Navigator.pop(context);
                    loadSettings();
                  });
                })
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text('Security'),
          tiles: [
            SettingsTile.switchTile(
              title: Text('Offline mode'),
              leading: Icon(Icons.save_outlined),
              onToggle: (bool value) {
                setState(() {
                  settingOffline = value;
                  notificationsEnabled = value;
                });
                context.read<GlobalBloc>().add(SettingChanged(
                    settings: {StorageKeys.SettingOffline: settingOffline}));
                loadSettings();
              },
              initialValue: settingOffline,
            ),
            SettingsTile.switchTile(
              title: Text('Use fingerprint'),
              leading: Icon(Icons.fingerprint),
              onToggle: (bool value) {
                setState(() => {settingBio = value});
                context.read<GlobalBloc>().add(SettingChanged(
                    settings: {StorageKeys.SettingAllowBiometric: settingBio}));
                loadSettings();
              },
              initialValue: settingBio,
            ),
          ],
        ),
        SettingsSection(
          title: Text('Misc'),
          tiles: [
            SettingsTile(
                title: Text('Terms of Service'),
                leading: Icon(Icons.description),
                onPressed: (context) {

                }),
            SettingsTile(
                title: Text('Open source licenses'),
                leading: Icon(Icons.collections_bookmark)),
          ],
        ),
        CustomSettingsSection(
          child: Column(
            children: [
              Text(
                'Version: ${_packageInfo.version}',
                style: TextStyle(color: Color(0xFF777777)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void loadSettings() {
    context.read<GlobalBloc>().session.tokens.getUsername().then((value) => {
      setState(() => settingRememberUsername = value)
    });
    context.read<GlobalBloc>().session.tokens.getPassword().then((value) => {
      setState(() => settingRememberPassword = value)
    });
    context.read<GlobalBloc>().state.settings.forEach((key, value) {
      if (key == StorageKeys.SettingEnv) {
        setState(() => settingEnv = value);
      }
      if (key == StorageKeys.SettingAllowBiometric) {
        setState(() => settingBio = value);
      }
      if (key == StorageKeys.SettingLang) {
        setState(() => settingLang = value);
      }
      if (key == StorageKeys.SettingRememberMe) {
        setState(() => settingRemember = value);
      }
      if (key == StorageKeys.SettingOffline) {
        setState(() => settingOffline = value);
      }
      if (key == StorageKeys.SettingNotifications) {
        setState(() => settingNotify = value);
      }
      if (key == StorageKeys.SettingCurrency) {
        setState(() => settingCurrency = value);
      }
      if (key == StorageKeys.SettingNotificationSound) {
        setState(() => settingNotificationSound = value);
      }
      if (key == StorageKeys.SettingDateFormat) {
        setState(() => settingDateFormat = value);
      }
      if (key == StorageKeys.SettingTimezone) {
        setState(() => settingTimezone = value);
      }
      if (key == StorageKeys.SettingFirstDay) {
        setState(() => settingFirstDay = value);
      }
      if (key == StorageKeys.SettingWaterUnitPrice) {
        setState(() => settingUnitWater = value);
      }
      if (key == StorageKeys.SettingElectricityUnitPrice) {
        setState(() => settingUnitElectricity = value);
      }
      if (key == StorageKeys.SettingGasUnitPrice) {
        setState(() => settingUnitGas = value);
      }
    });
  }
}
