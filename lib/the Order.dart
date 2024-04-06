import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Logistics App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const OrdersPage(),
    );
  }
}

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late List<Order> _orders = []; // Initialize _orders with an empty list
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response =
      await http.get(Uri.parse('https://api.example.com/orders'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          _orders =
              data.map((orderJson) => Order.fromJson(orderJson)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching orders: $e');
      // You can show a snackbar or dialog to inform the user about the error
    }
  }

  Future<void> _refreshOrders() async {
    await _fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshOrders,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : RefreshIndicator(
        onRefresh: _refreshOrders,
        child: _orders != null && _orders.isNotEmpty
            ? ListView.builder(
          itemCount: _orders.length,
          itemBuilder: (context, index) {
            return OrderTile(order: _orders[index]);
          },
        )
            : const Center(
          child: Text('No orders found'),
        ),
      ),
    );
  }
}

class Order {
  final String id;
  final String productName;
  final String customerName;
  final String deliveryLocation;
  final String status;
  final String specialInstructions;

  Order({
    required this.id,
    required this.productName,
    required this.customerName,
    required this.deliveryLocation,
    required this.status,
    required this.specialInstructions,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      productName: json['productName'],
      customerName: json['customerName'],
      deliveryLocation: json['deliveryLocation'],
      status: json['status'],
      specialInstructions: json['specialInstructions'],
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
              Text(
                'Order ID: ${order.id}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Product: ${order.productName}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Status: ${order.status}',
                    style: TextStyle(
                      fontSize: 16,
                      color: _getStatusColor(order.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Customer: ${order.customerName}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Order Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Product Name: ${order.productName}'),
              Text('Customer Name: ${order.customerName}'),
              Text('Delivery Location: ${order.deliveryLocation}'),
              Text('Status: ${order.status}'),
              Text('Special Instructions: ${order.specialInstructions}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
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
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
