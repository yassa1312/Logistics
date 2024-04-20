import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:logistics/EndTripPage.dart';
import 'package:logistics/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';
import 'theOrder.dart';
 // Import OrdersPage to access its methods

class OrderDetailsPage extends StatelessWidget {
  final Order order;

  const OrderDetailsPage({required this.order, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details',
          // Assuming 'requestId' is the unique identifier for the order
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem('Order Id', order.requestId),
                    _buildDetailItem('Pick Up Location', order.pickUpLocation),
                    _buildDetailItem('Drop Off Location', order.dropOffLocation),
                    _buildDetailItem('Time Stamp On Creation', order.timeStampOnCreation),
                    _buildDetailItem('Ride Type', order.rideType),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (order.endTripTime == null || order.endTripTime.isEmpty) {
                        // Show a Flutter toast message indicating that the trip has not ended yet
                        Fluttertoast.showToast(
                          msg: 'Trip has not ended yet.',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      } else {
                        // Navigate to the EndTripPage if the trip has ended
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EndTripPage(requestId: order.requestId),
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(
                        'Comment',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showDeleteConfirmationDialog(context, order),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                      elevation: MaterialStateProperty.all<double>(10),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(
                        'Delete Order',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
  Widget _buildOrderInfo1(String label, bool value) {
    return Row(
      children: [
        Text(
          label, // Changed title to label
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.blue,
          ),
        ),
        SizedBox(width: 5),
        Icon(
          value ? Icons.check_circle : Icons.cancel,
          color: value ? Colors.green : Colors.red,
        ),
      ],
    );
  }
  Widget _buildDetailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context,
      Order order) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion', style: TextStyle(color: Colors.red)),
          content: Text(
            'Are you sure you want to delete order ${order.requestId}?',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () async {
                await _deleteOrder(context, order);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteOrder(BuildContext context, Order order) async {
    if (order.finished) {
      Fluttertoast.showToast(
        msg: 'Order is already completed and cannot be deleted.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (order.startTripTime.isNotEmpty) {
      Fluttertoast.showToast(
        msg: 'Order has already started and cannot be deleted.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }


    String? token = await AuthService.getAccessToken();

    if (token == null) {
      // Handle the case where the access token is not available
      Fluttertoast.showToast(
        msg: 'Authentication error. Please log in again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    String url =
        'http://www.logistics-api.somee.com/api/User/DeleteMyRequests/${order.requestId}';

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'accept': '*/*',
    };

    try {
      var response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Order deleted successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to delete order. Status code: ${response.statusCode}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      // Handle any exceptions that occur during the HTTP request
      print('Exception occurred: $e');
      Fluttertoast.showToast(
        msg: 'Failed to delete order. Please try again later.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
