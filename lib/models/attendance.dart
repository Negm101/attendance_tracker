import 'dart:convert';

class Attendance {
  Attendance({
    required this.user,
    required this.phone,
    required this.checkIn,
  });

  final String user;
  final String phone;
  final DateTime checkIn;

  factory Attendance.fromRawJson(String str) =>
      Attendance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        user: json["user"],
        phone: json["phone"],
        checkIn: DateTime.parse(json["check-in"]),
      );

  Map<String, String> toJson() => {
        "user": user,
        "phone": phone,
        "check-in": checkIn.toIso8601String(),
      };

  String checkinInTimesAgo() {
    final difference = DateTime.now().difference(checkIn); // get difference
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

  // toString method
  @override
  String toString() {
    return 'Name: $user\nPhone: $phone\nCheck-in: $checkIn';
  }
}
