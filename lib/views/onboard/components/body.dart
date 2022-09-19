import 'package:remotesurveyadmin/config/constants.dart';
import 'package:remotesurveyadmin/views/register/register_view.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

class Intro extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IntroState();
  }
}

class IntroState extends State<Intro> {
  List<Slide> listSlides = [];

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: listSlides,
      onDonePress: onPressedDone(context),
    );
  }

  @override
  void initState() {
    super.initState();

    listSlides.add(Slide(
        title: "Remote Survey",
        description: "Welcome to Survey Admin app.",
        pathImage: "assets/images/onboard/slide1.png",
        backgroundColor: kPrimaryColor,
        colorBegin: kPrimaryLightColor,
        colorEnd: kPrimaryColor));

    listSlides.add(Slide(
        title: "Survey",
        description:
            "Generate question and answer quizes and save them in firebase",
        pathImage: "assets/images/onboard/slide2.png",
        backgroundColor: kPrimaryColor,
        colorBegin: kPrimaryLightColor,
        colorEnd: kPrimaryColor));

    listSlides.add(Slide(
        title: "Firebase Authentication",
        description:
            "Register and Login User, Reset password and update Profile",
        pathImage: "assets/images/onboard/slide3.png",
        backgroundColor: kPrimaryColor,
        colorBegin: kPrimaryLightColor,
        colorEnd: kPrimaryColor));

    listSlides.add(Slide(
        title: "Firebase Cloud Store",
        description: "Store, monitor and analyze on firebase cloud.",
        pathImage: "assets/images/onboard/slide4.png",
        backgroundColor: kPrimaryColor,
        colorBegin: kPrimaryLightColor,
        colorEnd: kPrimaryColor));
  }

  onPressedDone(BuildContext context) {
    fun() => {
          Future.delayed(Duration.zero, () {
            Navigator.of(context).pushNamed(RegisterView.routeName);
          })
        };
    return fun;
  }
}
