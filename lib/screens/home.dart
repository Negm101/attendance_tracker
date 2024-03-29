import 'dart:math';

import 'package:attendance_tracker/models/attendance.dart';
import 'package:attendance_tracker/screens/attendance_details.dart';
import 'package:attendance_tracker/services/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Attendance> attendances = [];

  bool isAscending = true; // for sorting
  TextEditingController searchValue = TextEditingController();
  bool isTimesAgoFormat = true; // for time format

  Future<void> _loadSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isAscending = prefs.getBool('isAscending') ?? true;
      isTimesAgoFormat = prefs.getBool('isTimesAgoFormat') ?? true;
    });
  }

  Future<void> _saveIsAscedning() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('isAscending', isAscending);
    });
  }

  @override
  void initState() {
    super.initState();

    attendances = List<Attendance>.from(Global.attendanceRaw
        .map((e) => Attendance.fromJson(e))); // convert to Attendance object
    _loadSharedPrefs().then((value) => setState(() {
          attendances.sort((a, b) {
            if (isAscending) {
              return b.checkIn.compareTo(a.checkIn);
            } else {
              return a.checkIn.compareTo(b.checkIn);
            }
          });
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          controller: searchValue,
          decoration: InputDecoration(
            hintText: "Search by name ",
            hintStyle: const TextStyle(color: Colors.white),
            alignLabelWithHint: true,
            contentPadding: const EdgeInsets.all(16),
            border: InputBorder.none,
            prefixIcon: searchValue.text.isEmpty
                ? const Icon(Icons.search, color: Colors.white)
                : IconButton(
                    onPressed: () {
                      setState(() {
                        searchValue.clear();
                        attendances = List<Attendance>.from(Global.attendanceRaw
                            .map((e) => Attendance.fromJson(
                                e))); // convert to Attendance object
                        FocusManager.instance.primaryFocus
                            ?.unfocus(); // close keyboard
                      });
                    },
                    icon: const Icon(Icons.clear)),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: ((value) {
            setState(() {
              attendances = List<Attendance>.from(Global.attendanceRaw
                  .where((element) => element["user"]!.contains(value))
                  .map((e) => Attendance.fromJson(e)));
            });
          }),
        ),
        actions: [
          IconButton(
            tooltip: "Sort by check-in time",
            icon: isAscending
                ? const Icon(Icons.arrow_upward_rounded)
                : const Icon(Icons.arrow_downward_rounded),
            onPressed: () {
              sortAttendances();
            },
          ),
        ],
      ),
      body: attendances.isEmpty
          ? const Center(
              child: Text("No data"),
            )
          : NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollEndNotification &&
                    scrollNotification.metrics.extentAfter == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.grey[800],
                      content: const Text(
                          "You have reached the end of the list",
                          style: TextStyle(color: Colors.white)),
                    ),
                  );
                }
                return false;
              },
              child: ListView.builder(
                itemCount: attendances.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    key: const ValueKey(0),
                    // The end action pane is the one at the right or the bottom side.
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          spacing: 2,
                          onPressed: (slideContext) {
                            // share attendance details to other apps
                            Share.share(
                                "Name: ${attendances[index].user}\nPhone: ${attendances[index].phone}\nCheck-in: ${attendances[index].checkIn}");
                          },
                          backgroundColor: const Color(0xFF0392CF),
                          foregroundColor: Colors.white,
                          icon: Icons.share,
                          label: 'Share',
                        ),
                      ],
                    ),
                    child: ListTile(
                      // random avatar image from https://picsum.photos/
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://picsum.photos/seed/${attendances[index].user}/200"),
                      ),
                      title: Text(attendances[index].user),
                      subtitle: Text(attendances[index].phone),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // container with rounded corners for time
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(isTimesAgoFormat
                                ? toTimesAgo(attendances[index].checkIn)
                                : attendances[index]
                                    .checkIn
                                    .toString()
                                    .split(".")[0]),
                          ),
                        ],
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttendanceDetails(
                            attendance: attendances[index],
                            isTimesAgoFormat: isTimesAgoFormat,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColorDark,
        onPressed: () {
          addAttendance().then((value) => value != null
              ? setState(() {
                  attendances.add(value); // add new attendance record
                  Global.attendanceRaw.add(value.toJson());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.grey[800],
                      content: const Text("New attendance record added",
                          style: TextStyle(color: Colors.white)),
                      action: SnackBarAction(
                        label: 'OK',
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  );
                })
              : print("No new attendance record added"));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void sortAttendances() {
    setState(() {
      attendances.sort((a, b) => isAscending
          ? a.checkIn.compareTo(b.checkIn)
          : b.checkIn.compareTo(a.checkIn));
      if (isAscending) {
        isAscending = false;
      } else {
        isAscending = true;
      }
    });
    print(isAscending);
    _saveIsAscedning();
  }

  String toTimesAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime); // get difference
    if (difference.inHours < 1) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inDays < 1) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else {
      return "${difference.inDays ~/ 7} weeks ago";
    }
  }

  Future<Attendance?> addAttendance() async {
    Attendance? newAttendance;
    TextEditingController name = TextEditingController();
    TextEditingController phone = TextEditingController();
    TextEditingController checkInController = TextEditingController();
    DateTime checkIn = DateTime.now();

    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text("Add new attendance record"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: name,
                    decoration: const InputDecoration(
                      hintText: "Name",
                    ),
                  ),
                  TextField(
                    controller: phone,
                    decoration: const InputDecoration(
                      hintText: "Phone",
                    ),
                  ),
                  // text field to shoe date picker
                  TextField(
                    controller: checkInController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: "Check-in time",
                    ),
                    onTap: () {
                      // show date picker when user tap on the text field
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2021),
                        lastDate: DateTime.now(),
                      ).then((date) {
                        // show time picker when user select a date
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((time) {
                          checkIn = DateTime(
                            date!.year,
                            date.month,
                            date.day,
                            time!.hour,
                            time.minute,
                          );
                          setState(() {
                            checkInController.text = checkIn
                                    .toString()
                                    .split(".")[
                                0]; // remove milliseconds when formating to string
                          });
                        });
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    newAttendance = Attendance(
                      user: name.text,
                      phone: phone.text,
                      checkIn: checkIn,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          });
        });

    return newAttendance;
  }
}
