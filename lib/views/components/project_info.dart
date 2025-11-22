import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/project.dart';

class ProjectInfo extends StatelessWidget {
  final Project project;
  const ProjectInfo({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ---- Title ----
          Text(
            project.title ?? '',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // ---- Description ----
          Text(project.description ?? '',
              style: TextStyle(color: Colors.grey[700])),
          const SizedBox(height: 16),

          // ---- Dates ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Start: ${project.startAt != null ? dateFormat.format(project.startAt!) : '-'}",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "Due: ${project.endAt != null ? dateFormat.format(project.endAt!) : '-'}",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ---- Status ----
          Row(
            children: [
              const Text("Status: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(project.status ?? "Unknown"),
            ],
          ),

          const SizedBox(height: 12),

          // ---- Progress ----
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Progress: ${project.progress?.toStringAsFixed(0) ?? '0'}%",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: (project.progress ?? 0) / 100,
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ---- Teams ----
          const Text("Team Members",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          if (project.users == null || project.users!.isEmpty)
            const Text("No users assigned")
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: project.users!.map((userName) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.person, size: 20),
                      const SizedBox(width: 8),
                      Text(userName, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
