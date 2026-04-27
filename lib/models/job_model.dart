import 'dart:convert';

class Job {
  String company;
  String role;
  String location;
  String status;

  Job({
    required this.company,
    required this.role,
    required this.location,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'company': company,
      'role': role,
      'location': location,
      'status': status,
    };
  }

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      company: map['company'],
      role: map['role'],
      location: map['location'],
      status: map['status'],
    );
  }
}