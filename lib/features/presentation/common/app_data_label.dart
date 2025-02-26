import 'package:flutter/material.dart';

class AppDataLabel extends StatelessWidget {
  final String title;
  final String data;

  AppDataLabel({required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(
            width: 50,
          ),
          Expanded(
            child: Text(
              data,
              textAlign: TextAlign.end,
              maxLines: 10,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
