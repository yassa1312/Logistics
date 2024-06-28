import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logistics/EndTripPage.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'auth_service.dart'; // Make sure this import is correct

class Order {
  final String requestId;
  final String pickUpLocation;
  final String dropOffLocation;
  final String endTripTime;
  final String? comment;
  final String? canceled_By;
  final int rating;
  final bool finished;
  final int cost;
  Order({
    required this.requestId,
    required this.pickUpLocation,
    required this.dropOffLocation,
    required this.endTripTime,
    this.comment,
    this.canceled_By,
    required this.rating,
    required this.finished,
    required this.cost,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      requestId: json['request_Id'] ?? '',
      pickUpLocation: json['pick_Up_Location'],
      dropOffLocation: json['drop_Off_Location'],
      endTripTime: json['end_Trip_Time'] != null
          ? DateTime.parse(json['end_Trip_Time']).toString()
          : '',
      finished: json['finished'] ?? false,
      comment: json['comment'],
      canceled_By: json['canceled_By'],
      rating: json['rating'] ?? 0,
      cost: json['cost'] ?? 0,
    );
  }
}

class Activity extends StatefulWidget {
  const Activity({Key? key}) : super(key: key);

  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  late List<Order> _orders = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchOrders(); // Initially fetch orders
  }

  Future<void> fetchOrders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      String? token = await AuthService.getAccessToken();

      if (token != null) {
        var headers = {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        };
        String? baseUrl = await AuthService.getURL();
        final url = '$baseUrl/api/User/MyRequests/1';

        final response = await http.get(
          Uri.parse(url),
          headers: headers,
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final List<dynamic> responseData = json.decode(response.body);
          List<Order> apiOrders = responseData.map((data) =>
              Order.fromJson(data)).toList();

          setState(() {
            _orders = apiOrders;
            _isLoading = false;
          });
        } else {
          // Log error if API call fails
          print('Failed to fetch orders. Status code: ${response.statusCode}');
          // Fallback to dummy data if API call fails
          _loadDummyOrders();
        }
      } else {
        // Log error if token is null
        print('Token is null');
        // Fallback to dummy data if token is null
        _loadDummyOrders();
      }
    } catch (e) {
      // Log error if exception occurs
      print('Exception during API call: $e');
      // Fallback to dummy data if exception occurs
      _loadDummyOrders();
    }
  }

  void _loadDummyOrders() {
    // Simulate API call by creating a list of dummy data
    List<Order> dummyOrders = [
      Order(
        requestId: '1',
        pickUpLocation: 'Location A',
        dropOffLocation: 'Location B',
        endTripTime: '2022-04-10 10:00:00',
        finished: true,
        rating: 5,
        cost: 10,
        comment: 'it good work',
      ),
      Order(
        requestId: '2',
        pickUpLocation: 'Location C',
        dropOffLocation: 'Location D',
        endTripTime: '2022-04-10 10:00:00',
        rating: 3,
        finished: false,
        cost: 10,
      ),
      // Add more dummy orders as needed
    ];

    // Set the dummy data to the state variable
    setState(() {
      _orders = dummyOrders;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Activity',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
      ),
      body: RefreshIndicator(
        onRefresh: fetchOrders,
        child: _isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : _errorMessage.isNotEmpty
            ? Center(
          child: Text(_errorMessage),
        )
            : _orders.isNotEmpty
            ? ListView.builder(
          itemCount: _orders.length,
          itemBuilder: (context, index) {
            // Check if endTripTime is not empty before displaying the order
            if (_orders[index].endTripTime.isNotEmpty) {
              return OrderTile(
                order: _orders[index],
                refreshOrders: fetchOrders, // Pass the fetchOrders function
              );
            } else {
              // If endTripTime is empty, return an empty container
              return Container();
            }
          },
        )
            : Center(
          child: Text('No orders found'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchOrders,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

  class OrderTile extends StatelessWidget {
    final Order order;
    final Function refreshOrders; // Define this callback function

    const OrderTile({
      required this.order,
      required this.refreshOrders, // Pass this callback through constructor
      Key? key,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return InkWell(
        onTap: () => _showOrderDetails(context, order),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //_buildOrderInfo('Request ID:', order.requestId),
                // Display pickUpLocation if available
                MapLocationWidget(
                  locationLabel: 'Pick Up Location:',
                  location: order.pickUpLocation,
                ),
                MapLocationWidget(
                    locationLabel: 'Drop Off Location:',
                    location: order.dropOffLocation!
                ),
                _buildOrderInfo('Time Stamp On EndTrip', order.endTripTime),
                if (order.comment != null) // Display comment if available
                  _buildOrderInfo('Comment:', order.comment!),
                if (order.canceled_By != null) // Display comment if available
                  _buildOrderInfo('Canceled By:', order.canceled_By!),
                _buildOrderInfoWithRating('Rating:', order.rating),
                _buildOrderInfo3('Cost:', order.cost, "EPG"),
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildOrderInfoWithRating(String title, int rating) {
      if (rating != 0) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 4), // Add a SizedBox for spacing
            Row(
              children: List.generate(
                5, // Total number of stars
                    (index) {
                  if (index < rating) {
                    // If the index is less than the rating, display a filled star
                    return Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 20,
                    );
                  } else {
                    // If the index is greater than or equal to the rating, display an empty star
                    return Icon(
                      Icons.star_border,
                      color: Colors.orange,
                      size: 20,
                    );
                  }
                },
              ),
            ),
          ],
        );
      } else {
        // If rating is zero, return an empty container
        return Container();
      }
    }


    Widget _buildOrderInfo(String title, String value) {
      if (value.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 4), // Add a SizedBox for spacing
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        );
      } else {
        return Container(); // Return empty container if value is empty
      }
    }

    Widget _buildOrderInfo3(String title, int value, String unit) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 4), // Add a SizedBox for spacing
            Row(
              children: [
                Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 4), // Add a SizedBox for spacing
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    void _showOrderDetails(BuildContext context, Order order) async {
      // Check if the order has a comment, a rating, or is canceled
      if (order.comment != null || order.rating > 0) {
        // Do not proceed if any of the conditions are met
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('requestId', order.requestId);
      prefs.setString('endTripTime', order.endTripTime);
      prefs.setBool('finished', order.finished); // Store finished status

      // Navigate to the EndTripPage passing the requestId
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EndTripPage(requestId: order.requestId),
        ),
      );
    }
  }
class MapLocationWidget extends StatelessWidget {
  final String locationLabel;
  final String location;

  const MapLocationWidget({
    Key? key,
    required this.locationLabel,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchMapUrl(location);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$locationLabel',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 4), // Add a SizedBox for spacing
          Text(
            '$location',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  void _launchMapUrl(String location) async {
    String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$location';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }
}
