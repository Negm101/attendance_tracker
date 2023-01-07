import 'package:about/about.dart';
import 'package:attendance_tracker/screens/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isTimesAgoFormat = true;
  Future<void> _loadSharedPrefs() async {
    // load shared preferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isTimesAgoFormat = prefs.getBool('isTimesAgoFormat') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('isTimesAgoFormat', isTimesAgoFormat);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            title: const Text('Times ago'),
            subtitle: const Text('Date/Time format. eg. 2 hours ago'),
            trailing: Switch(
              value: isTimesAgoFormat,
              onChanged: (bool value) {
                isTimesAgoFormat = value;
                _saveSettings();
              },
            ),
          ),
          ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OnBoardingPage()));
              },
              title: const Text('Onboarding Screen'),
              subtitle: const Text('Wana see the onboarding screen again?'),
              trailing: const Icon(Icons.arrow_forward)),
          const Divider(endIndent: 16, indent: 16, thickness: 1),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 16, top: 10),
            child: Text(
              "About me",
              style: TextStyle(
                  color: Theme.of(context).toggleableActiveColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          // avatar of image
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/personal-pic.jpeg'),
              radius: 50,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Hi, I'm Abdelrahman Negm! you can call me Najm, I am a computer science student with two years of experience in mobile development using the Flutter framework. I am a fast learner and confident in my ability to contribute to a team. Thanks for considering me!",
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // row of social media icon buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    // https://github.com/Negm101
                    _launchUrl("https://github.com/Negm101");
                  },
                  icon: SvgPicture.asset(
                    'assets/github.svg',
                  )),
              IconButton(
                  onPressed: () {
                    // https://www.instagram.com/abdonegem/
                    _launchUrl("https://www.instagram.com/abdonegem/");
                  },
                  icon: SvgPicture.asset(
                    'assets/instagram.svg',
                  )),
              IconButton(
                  onPressed: () {
                    // https://wa.me/601140497219
                    _launchUrl("https://wa.me/601140497219");
                  },
                  icon: SvgPicture.asset(
                    'assets/whatsapp.svg',
                  )),
              IconButton(
                  onPressed: () {
                    // https://www.linkedin.com/in/abdelrahman-negm-374b20201/
                    _launchUrl(
                        "https://www.linkedin.com/in/abdelrahman-negm-374b20201/");
                  },
                  icon: SvgPicture.asset(
                    'assets/linkedin.svg',
                  )),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(endIndent: 16, indent: 16, thickness: 1),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 16, top: 10),
            child: Text(
              "Info",
              style: TextStyle(
                  color: Theme.of(context).toggleableActiveColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          const LicensesPageListTile(
            title: Text('Open source licenses'),
            icon: Icon(Icons.info_outline),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Made with "),
                  Icon(Icons.favorite, color: Colors.red),
                  Text(" from Egypt"),
                ],
              )),
        ],
      )),
    );
  }

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $_url';
    }
  }
}
