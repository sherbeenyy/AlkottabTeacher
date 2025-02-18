import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String message, bool success) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            success ? Icons.check_circle : Icons.error,
            color: success ? Colors.green : Colors.red,
          ),
          SizedBox(width: 8),
          Text(message),
        ],
      ),
    ),
  );
}
