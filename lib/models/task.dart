import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String? taskId;
  String? title;
  String? description;
  DateTime? startAt;
  DateTime? endAt;
  String? status;
  double? progress;

  Task({
    this.taskId,
    this.title,
    this.description,
    this.startAt,
    this.endAt,
    this.status,
    this.progress,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['task_id'],
      title: json['title'],
      description: json['description'],

      startAt: json['startAt'] is Timestamp
          ? (json['startAt'] as Timestamp).toDate()
          : json['startAt'] != null
          ? DateTime.tryParse(json['startAt'])
          : null,

      endAt: json['endAt'] is Timestamp
          ? (json['endAt'] as Timestamp).toDate()
          : json['endAt'] != null
          ? DateTime.tryParse(json['endAt'])
          : null,

      status: json['status'] ?? "pending",
      progress: json['progress'] != null ? (json['progress'] as num).toDouble() : 0.0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'task_id': taskId,
      'title': title ?? '',
      'description': description ?? '',
      'startAt': startAt != null ? Timestamp.fromDate(startAt!) : null,
      'endAt': endAt != null ? Timestamp.fromDate(endAt!) : null,
      'status': status ?? 'pending',
      'progress': progress ?? 0.0,
    };
  }

}


