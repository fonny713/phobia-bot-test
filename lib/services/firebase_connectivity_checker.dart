import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseConnectivityChecker {
  static Future<bool> checkFirebaseConnection() async {
    try {
      print('Checking Firebase connection...');
      
      // Check internet connectivity first
      final hasInternet = await _checkInternetConnection();
      if (!hasInternet) {
        print('No internet connection detected');
        return false;
      }
      
      // Check authentication status
      if (FirebaseAuth.instance.currentUser == null) {
        print('User not authenticated, attempting anonymous sign-in...');
        try {
          await FirebaseAuth.instance.signInAnonymously();
          print('Anonymous sign-in successful');
        } catch (e) {
          print('Anonymous sign-in failed: $e');
          // Continue anyway, as some operations might work without auth
        }
      } else {
        print('User is authenticated: ${FirebaseAuth.instance.currentUser!.uid}');
      }
      
      // Try to access Firebase Storage
      try {
        final ref = FirebaseStorage.instance.ref();
        await ref.list(const ListOptions(maxResults: 1));
        print('Firebase Storage connection successful');
        return true;
      } catch (e) {
        print('Firebase Storage connection failed: $e');
        return false;
      }
    } catch (e) {
      print('Error checking Firebase connection: $e');
      return false;
    }
  }
  
  static Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
  
  static Future<void> showConnectionErrorDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Connection Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Unable to connect to Firebase.'),
                const SizedBox(height: 10),
                const Text('Please check:'),
                const SizedBox(height: 5),
                const Text('• Your internet connection'),
                const Text('• Firebase configuration'),
                const Text('• Firebase project status'),
                const Text('• Firebase Storage rules'),
                const SizedBox(height: 10),
                const Text('Would you like to retry the connection?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Retry'),
              onPressed: () async {
                Navigator.of(context).pop();
                
                // Try anonymous sign-in again
                try {
                  if (FirebaseAuth.instance.currentUser == null) {
                    await FirebaseAuth.instance.signInAnonymously();
                    print('Anonymous sign-in successful during retry');
                  }
                } catch (e) {
                  print('Anonymous sign-in failed during retry: $e');
                }
                
                final isConnected = await checkFirebaseConnection();
                if (!isConnected) {
                  // Show error again if still not connected
                  await showConnectionErrorDialog(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
  
  static Future<bool> checkFirebaseProjectStatus() async {
    try {
      // Check if the Firebase project is accessible
      final projectId = 'phobia-apka';
      final url = 'https://$projectId.firebaseio.com/.json';
      
      final response = await http.get(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      print('Error checking Firebase project status: $e');
      return false;
    }
  }
} 