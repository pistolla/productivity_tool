import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/config/size_config.dart';

const String DB_NAME = "remotesurveyadmin.db";
const String INIT_QUERIES = "";

const int HOME_VIEW_ID = 1;
const int WATER_VIEW_ID = 2;
const int WATER_REPORT_VIEW_ID = 3;
const int ELECTRICITY_VIEW_ID = 4;
const int ELECTRICITY_REPORT_VIEW_ID = 5;
const int GAS_VIEW_ID = 6;
const int GAS_REPORT_VIEW_ID = 7;



const kPrimaryColor = Color(0xFF2C4A88);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF047BAA), Color(0xFF2C4A88)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);
const kPlainColor = Color(0xFFD8D8D8);

const kAnimationDuration = Duration(milliseconds: 200);

const double customBottomNavigationBarHeight = 68;

const double h20UnitPrice = 200;
const double powerUnitPrice = 7.70;
const double gasUnitPrice = 200;

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

const pieChartSweep = Duration(
  seconds: 1,
);

// Form Error
final RegExp emailValidatorRegExp =
RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short. min 5 characters";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your postal address";
const String kMeterNoNullError = "Please Enter Meter No.";
const String kTxCodeNullError = "Please Enter Transaction Code";

final otpInputDecoration = InputDecoration(
  contentPadding:
  EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: kTextColor),
  );
}
