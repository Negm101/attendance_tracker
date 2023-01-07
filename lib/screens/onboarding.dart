import 'package:attendance_tracker/screens/home.dart';
import 'package:attendance_tracker/screens/navigation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const NavigationPage()),
    );
  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/fullscreen.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  Widget _buildSVG(String assetName, [double width = 350]) {
    return SvgPicture.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.zero,
    );

    return SafeArea(
      child: IntroductionScreen(
        key: introKey,
        allowImplicitScrolling: false,
        globalFooter: Container(
          margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            child: const Text(
              'Skip forward!',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            onPressed: () => introKey.currentState?.animateScroll(5),
          ),
        ),
        pages: [
          PageViewModel(
            title: "Welcome to the Attendance Tracker App!",
            body:
                "This app is designed to help you track and manage your attendance records",
            image: _buildSVG('welcome.svg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            titleWidget: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.blueGrey,
              child: const Icon(Icons.add),
            ),
            body: "Add new attendance records using this button",
            decoration: pageDecoration,
            image: _buildSVG('add.svg'),
          ),
          PageViewModel(
            title: "Search & Sort",
            body:
                "Search and sort through your attendance records using the search bar at the top of the screen",
            decoration: pageDecoration,
            image: _buildSVG('search.svg'),
          ),
          PageViewModel(
            title: "Share attendance records",
            body:
                "Swipe Right on a attendance record to share it with other apps, or tap on it to view more details and get share via qr code",
            decoration: pageDecoration,
            image: _buildSVG('share.svg'),
          ),
          PageViewModel(
            title: "Time format",
            body:
                "Toggle between showing the time as \"time ago\" (e.g. \"1 hour ago\") or in the format \"dd MMM yyyy, h:mm a\" in the settings page",
            decoration: pageDecoration,
            image: _buildSVG('settings.svg'),
          ),
          PageViewModel(
              title: "You're all set!",
              body:
                  "You're ready to start tracking and managing your attendance records",
              image: _buildSVG('done.svg'),
              decoration: pageDecoration,
              footer: ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: const Text(
                    'Done',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () => _onIntroEnd(context),
              )),
        ],
        showDoneButton: false,
        onDone: () => _onIntroEnd(context),
        //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
        showSkipButton: false,
        skipOrBackFlex: 0,
        nextFlex: 0,
        showBackButton: false,
        showNextButton: false,
        //rtl: true, // Display as right-to-left
        back: const Icon(Icons.arrow_back),
        skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
        next: const Icon(Icons.arrow_forward),
        done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.all(16),
        controlsPadding: kIsWeb
            ? const EdgeInsets.all(12.0)
            : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        dotsDecorator: DotsDecorator(
          activeColor: Theme.of(context).primaryColorDark,
          size: const Size(10.0, 10.0),
          activeSize: const Size(22.0, 10.0),
          activeShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }
}
