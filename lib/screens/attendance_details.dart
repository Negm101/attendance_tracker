import 'package:attendance_tracker/models/attendance.dart';
import 'package:attendance_tracker/screens/components/Info_tile.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class AttendanceDetails extends StatelessWidget {
  final Attendance attendance;
  final bool isTimesAgoFormat;
  // ignore: use_key_in_widget_constructors
  const AttendanceDetails({required this.attendance, required this.isTimesAgoFormat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(attendance.user),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: CircleAvatar(
                    radius: 75,
                    backgroundImage: NetworkImage(
                        "https://picsum.photos/seed/${attendance.user}/200"),
                  ),
                ),
                InfoTile(title: "Phone", value: attendance.phone),
                InfoTile(
                    title: "Check-in", value: isTimesAgoFormat
                                ? attendance.checkinInTimesAgo()
                                : attendance
                                    .checkIn
                                    .toString()
                                    .split(".")[0]),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).focusColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: QrImage(
                    data: attendance.toString(),
                    version: QrVersions.auto,
                    foregroundColor: Colors.white,
                    size: 250.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: 
            Container(
          height: 60,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).buttonTheme.colorScheme!.primary,
          ),
          child: TextButton(
            onPressed: () {
              Share.share(
                  "Name: ${attendance.user}\nPhone: ${attendance.phone}\nCheck-in: ${attendance.checkIn}");
            },
            child: const Text(
              "Share",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ));
  }
}
