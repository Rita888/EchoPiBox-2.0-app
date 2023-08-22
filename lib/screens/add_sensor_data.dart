import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSensorData extends StatelessWidget {
  final int humidity;
  final int lux;
  final int temperature;
  final DateTime timestamp;

  AddSensorData(this.humidity, this.lux, this.temperature, this.timestamp);

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference sensorData =
        FirebaseFirestore.instance.collection('SensorData');

    Future<void> addSensorData() {
      return sensorData
          .add({
            'Humidity': humidity,
            'Lux': lux,
            'Temperature': temperature,
            'Timestamp': DateTime.now()
          })
          .then((value) => print("Sensor Data Added $value"))
          .catchError((error) => print("$error"));
    }

    Future<void> addSensorDataWithRetry() async {
      const maxRetries = 5;
      const initialDelay = Duration(seconds: 2);

      for (int retryCount = 0; retryCount < maxRetries; retryCount++) {
        try {
          await addSensorData();
          print("Sensor Data Added");
          return; // Successful, exit the loop
        } catch (error) {
          print("Failed to add Sensor Data: $error");
          await Future.delayed(initialDelay * (2 << retryCount));
        }
      }

      print("Max retries reached, giving up.");
    }

    return Container(
      padding: EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: addSensorDataWithRetry,
        child: Text('Add SensorData'),
      ),
    );
  }
}
