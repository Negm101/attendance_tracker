
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

    factory Attendance.fromRawJson(String str) => Attendance.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        user: json["user"],
        phone: json["phone"],
        checkIn: DateTime.parse(json["check-in"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "phone": phone,
        "check-in": checkIn.toIso8601String(),
    };
}
