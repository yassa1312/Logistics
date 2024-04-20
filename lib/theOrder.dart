import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'OrderDetailsPage.dart'; // Make sure this import is correct
import 'auth_service.dart'; // Make sure this import is correct

class Order {
  final String requestId;
  final String pickUpLocation;
  final String dropOffLocation;
  final String timeStampOnCreation;
  final String startTripTime;
  final String endTripTime;
  final String rideType;
  final bool finished; // Add finished property

  Order({
    required this.requestId,
    required this.pickUpLocation,
    required this.dropOffLocation,
    required this.timeStampOnCreation,
    required this.startTripTime,
    required this.endTripTime,
    required this.rideType,
    required this.finished, // Initialize finished property
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      requestId: json['request_Id'] ?? '',
      pickUpLocation: json['pick_Up_Location'] ?? '',
      dropOffLocation: json['drop_Off_Location'] ?? '',
      timeStampOnCreation: json['time_Stamp_On_Creation'] != null
          ? DateTime.parse(json['time_Stamp_On_Creation']).toString()
          : '',
      startTripTime: json['start_Trip_Time'] != null
          ? DateTime.parse(json['start_Trip_Time']).toString()
          : '',
      endTripTime: json['end_Trip_Time'] != null
          ? DateTime.parse(json['end_Trip_Time']).toString()
          : '',
      rideType: json['ride_Type'] ?? '',
      finished: json['finished'] ?? '', // Initialize finished property
    );
  }
}

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();


}

class _OrdersPageState extends State<OrdersPage> {
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

        final url = 'http://www.logistics-api.somee.com/api/User/MyRequests/1';

        final response = await http.get(
          Uri.parse(url),
          headers: headers,
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final List<dynamic> responseData = json.decode(response.body);
          List<Order> apiOrders = responseData.map((data) => Order.fromJson(data)).toList();

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
        timeStampOnCreation: '2022-04-10 10:00:00',
        startTripTime: '2022-04-10 10:00:00',
        endTripTime: '2022-04-10 10:00:00',
        rideType: 'Normal', finished: true,

      ),
      Order(
        requestId: '2',
        pickUpLocation: 'Location C',
        dropOffLocation: 'Location D',
        timeStampOnCreation: '2022-04-11 12:00:00',
        startTripTime: '2022-04-10 10:00:00',
        endTripTime: '2022-04-10 10:00:00',
        rideType: 'Premium', finished: false,
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
          'My Orders',
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
            return OrderTile(
              order: _orders[index],
              refreshOrders: fetchOrders, // Pass the fetchOrders function
            );
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
              _buildOrderInfo('Request ID:', order.requestId),
              MapLocationWidget(
                locationLabel: 'Pick Up Location:',
                location: order.pickUpLocation,
              ),
              MapLocationWidget(
                locationLabel: 'Drop Off Location:',
                location: order.dropOffLocation,
              ),
              _buildOrderInfo('Time Stamp On Creation:', order.timeStampOnCreation),
              _buildOrderInfo('Ride Type:', order.rideType),
              _buildStatusInfo2(order),
            ],
          ),
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

  Widget _buildStatusInfo2(Order order) {
    String status = '';

    if (order.timeStampOnCreation.isNotEmpty &&
        order.startTripTime.isNotEmpty &&
        order.endTripTime.isNotEmpty) {
      status = 'Completed';
    } else if (order.timeStampOnCreation.isNotEmpty &&
        order.startTripTime.isNotEmpty) {
      status = 'In Progress';
    } else if (order.timeStampOnCreation.isNotEmpty) {
      status = 'Pending';
    }

    Color statusColor = _getStatusColor(status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 4), // Add a SizedBox for spacing
        Text(
          status,
          style: TextStyle(
            fontSize: 16,
            color: statusColor, // Change the color here
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'In Progress':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.black;
    }
  }
  Widget _buildOrderInfo(String title, String value) {
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
  }

  void _showOrderDetails(BuildContext context, Order order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('requestId', order.requestId);
    prefs.setString('endTripTime', order.endTripTime);
    prefs.setString('startTripTime', order.startTripTime);
    prefs.setBool('finished', order.finished); // Store finished status
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetailsPage(order: order)),
    ).then((result) {
      if (result == true) {
        refreshOrders();
      }
    });
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
