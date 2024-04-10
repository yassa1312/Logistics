import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'OrderDetailsPage.dart';
import 'auth_service.dart';

class Order {
  final String requestId;
  final String pickUpLocation;
  final String dropOffLocation;
  final String timeStampOnCreation;
  final String rideType;

  Order({
    required this.requestId,
    required this.pickUpLocation,
    required this.dropOffLocation,
    required this.timeStampOnCreation,
    required this.rideType,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      requestId: json['request_Id'] ?? '',
      pickUpLocation: json['pick_Up_Location'] ?? '',
      dropOffLocation: json['drop_Off_Location'] ?? '',
      timeStampOnCreation: json['time_Stamp_On_Creation'] != null
          ? DateTime.parse(json['time_Stamp_On_Creation']).toString()
          : '',
      rideType: json['ride_Type'] ?? '',
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
    _checkAndFetchOrders();
  }

  Future<void> _checkAndFetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool fetchedOnce = prefs.getBool('fetchedOnce') ?? false;

    if (!fetchedOnce) {
      await _fetchOrders();
      prefs.setBool('fetchedOnce', true);
    }
  }

  Future<void> _fetchOrders() async {
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
        rideType: 'Normal',
      ),
      Order(
        requestId: '2',
        pickUpLocation: 'Location C',
        dropOffLocation: 'Location D',
        timeStampOnCreation: '2022-04-11 12:00:00',
        rideType: 'Premium',
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
        onRefresh: _fetchOrders,
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
            return OrderTile(order: _orders[index]);
          },
        )
            : Center(
          child: Text('No orders found'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchOrders,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  final Order order;

  const OrderTile({
    required this.order,
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
              _buildOrderInfo('Pick Up Location:', order.pickUpLocation),
              _buildOrderInfo('Drop Off Location:', order.dropOffLocation),
              _buildOrderInfo('Time Stamp On Creation:', order.timeStampOnCreation),
              _buildOrderInfo('Ride Type:', order.rideType),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
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
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Order order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('requestId', order.requestId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsPage(order: order,),
      ),
    );
  }
}
