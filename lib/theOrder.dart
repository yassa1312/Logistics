import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'TheOrderDetailsPage.dart'; // Make sure this import is correct
import 'auth_service.dart'; // Make sure this import is correct

class Order {
  final String requestId;
  final String pickUpLocation;
  final String dropOffLocation;
  final String timeStampOnCreation;
  final String timeStampOnAcceptance;
  final String startTripTime;
  final String endTripTime;
  final String rideType;
  final bool finished;
  final bool cancel;
  final String? driverName;
  final String? driverPhone;
  final String? Image;
  final int cost;
  final String? comment;
  final int rating;
  Order({
    required this.requestId,
    required this.pickUpLocation,
    required this.dropOffLocation,
    required this.timeStampOnCreation,
    required this.timeStampOnAcceptance,
    required this.startTripTime,
    required this.endTripTime,
    required this.rideType,
    required this.finished,
    required this.cancel,
    this.driverName,
    this.driverPhone,
    this.Image,
    this.comment,
    required this.rating,
    required this.cost,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      requestId: json['request_Id'] ?? '',
      pickUpLocation: json['pick_Up_Location'] ?? '',
      dropOffLocation: json['drop_Off_Location'] ?? '',
      cost: json['cost'] ?? '',
      comment: json['comment'],
      rating: json['rating'] ?? 0,
      timeStampOnCreation: json['time_Stamp_On_Creation'] != null
          ? DateTime.parse(json['time_Stamp_On_Creation']).toString()
          : '',
      startTripTime: json['start_Trip_Time'] != null
          ? DateTime.parse(json['start_Trip_Time']).toString()
          : '',
      endTripTime: json['end_Trip_Time'] != null
          ? DateTime.parse(json['end_Trip_Time']).toString()
          : '',
      timeStampOnAcceptance: json['time_Stamp_On_Acceptance'] != null
          ? DateTime.parse(json['time_Stamp_On_Acceptance']).toString()
          : '',
      rideType: json['ride_Type'] ?? '',
      finished: json['finished'] ?? false,
      cancel: json['cancel'] ?? false,
      driverName: json['driverName'] != null && json['time_Stamp_On_Acceptance'] != null
          ? json['driverName']
          : null,
      driverPhone: json['driverPhone'] != null && json['time_Stamp_On_Acceptance'] != null
          ? json['driverPhone']
          : null,
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
        timeStampOnAcceptance:'',
        timeStampOnCreation: '2022-04-10 10:00:00',
        startTripTime: '',
        endTripTime: '',
        rideType: 'Normal', finished: true,
        cancel: false,
        cost: 10, rating: 0,

      ),
      Order(
        requestId: '2',
        pickUpLocation: 'Location C',
        dropOffLocation: 'Location D',
        timeStampOnAcceptance:'2022-04-11 12:00:00',
        timeStampOnCreation: '2022-04-11 12:00:00',
        startTripTime: '',
        endTripTime: '',
        rideType: 'Premium', finished: false,cost: 10,rating: 0,cancel: false,
      ),
      Order(
        requestId: '3',
        pickUpLocation: 'Location C',
        dropOffLocation: 'Location D',
        timeStampOnAcceptance:'2022-04-11 12:00:00',
        timeStampOnCreation: '2022-04-11 12:00:00',
        startTripTime: '2022-04-10 10:00:00',
        endTripTime: '',
        rideType: 'Premium', finished: false,cost: 10,rating: 0,cancel: false,
      ),
      Order(
        requestId: '4',
        pickUpLocation: 'Location C',
        dropOffLocation: 'Location D',
        timeStampOnAcceptance:'2022-04-11 12:00:00',
        timeStampOnCreation: '2022-04-11 12:00:00',
        startTripTime: '2022-04-10 10:00:00',
        endTripTime: '2022-04-10 10:00:00',
        rideType: 'Premium', finished: false,cost: 10,rating: 0,cancel: false,
      ),
      Order(
        requestId: '5',
        pickUpLocation: 'Location C',
        dropOffLocation: 'Location D',
        timeStampOnAcceptance:'2022-04-11 12:00:00',
        timeStampOnCreation: '2022-04-11 12:00:00',
        startTripTime: '2022-04-10 10:00:00',
        endTripTime: '2022-04-10 10:00:00',
        rideType: 'Premium',
        finished: false,
        cost: 10,
        rating: 0,cancel: false,
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
    // Check if there is a comment or rating
    if (order.comment != null || order.rating > 0||order.cancel==true) {
      // If either comment or rating is present, return an empty container
      return Container();
    }

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
              if (order.driverName != null) _buildOrderInfo('Driver Name:', order.driverName!),
              if (order.driverPhone != null) _buildOrderInfo('Driver Phone:', order.driverPhone!),
              MapLocationWidget(
                locationLabel: 'Pick Up Location:',
                location: order.pickUpLocation,
              ),
              MapLocationWidget(
                locationLabel: 'Drop Off Location:',
                location: order.dropOffLocation,
              ),
              _buildOrderInfo('Time Stamp On Creation', order.timeStampOnCreation),
              if (order.timeStampOnCreation.isNotEmpty &&
                  order.startTripTime.isNotEmpty &&
                  order.endTripTime.isNotEmpty)
                _buildOrderInfo('Time Stamp On EndTrip', order.endTripTime),
              _buildOrderInfo('Ride Type:', order.rideType),
              _buildStatusInfo2(order),
              _buildOrderInfo3('cost', order.cost,"EPG"),
            ],
          ),
        ),
      ),
    );
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

  Widget _buildStatusInfo2(Order order) {
    String status = '';

    if (order.timeStampOnCreation.isNotEmpty &&
        order.startTripTime.isNotEmpty &&
        order.endTripTime.isNotEmpty) {
      status = 'Completed';
    } else if (order.timeStampOnCreation.isNotEmpty &&
        order.startTripTime.isNotEmpty) {
      status = 'In Progress';
    } else if (order.timeStampOnAcceptance.isNotEmpty) {
      status = 'On the way to you';
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
      case 'On the way to you':
        return Colors.grey;
      case 'In Progress':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      case 'Cancel':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  void _showOrderDetails(BuildContext context, Order order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('requestId', order.requestId);
    prefs.setString('endTripTime', order.endTripTime);
    prefs.setString('timeStampOnAcceptance', order.timeStampOnAcceptance);
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
