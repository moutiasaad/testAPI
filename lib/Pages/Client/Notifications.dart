import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SendNotificationPage extends StatefulWidget {
  @override
  _SendNotificationPageState createState() => _SendNotificationPageState();
}

class _SendNotificationPageState extends State<SendNotificationPage> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String? _errorMessage;

  Future<void> sendNotification(String userId, String message) async {
    String? token;
    try {
      // Retrieve the user's FCM token from Firestore
      var userDoc = await FirebaseFirestore.instance.collection('user').doc(userId).get();
      token = userDoc.data()?['fcmToken'];

      if (token == null) {
        setState(() {
          _errorMessage = "User ID not found or user has no FCM token.";
        });
        return;
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to fetch FCM token: $e";
      });
      return;
    }

    try {
      const String serverToken = 'AAAA92oYzqo:APA91bElIBtGpCUGjXYQ6MN6_H_MOPSX3uDPnBFrfka6_B053gqazyTSCI6YQzcfGnjCxlzBueFK1IytB2A0nrisrtfKpZ5U8cN1RsoUZGV0PJFREMtkUChEuX2mqoeEX_oTEyAQwjEv';  // Ensure this is your correct server key
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: json.encode({
          'notification': {
            'body': message,
            'title': 'Notification Title',
          },
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token,
        }),
      );

      if (response.statusCode != 200) {
        setState(() {
          _errorMessage = "Failed to send notification. Status code: ${response.statusCode}. Error: ${response.body}";
        });
      } else {
        _userIdController.clear();
        _messageController.clear();
        setState(() {
          _errorMessage = null; // Clear any previous error message
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Notification sent successfully!'))
        );
      }
    } catch (error) {
      setState(() {
        _errorMessage = "An error occurred: $error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Notification"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _userIdController,
              decoration: InputDecoration(
                labelText: 'User ID',
              ),
            ),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Message',
              ),
            ),
            if (_errorMessage != null) Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: () => sendNotification(_userIdController.text, _messageController.text),
              child: Text('Send Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
