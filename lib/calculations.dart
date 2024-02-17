import 'package:flutter/material.dart';

class CalculationPage extends StatefulWidget {
  @override
  _CalculationPageState createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  String ShipmentType = 'Normal Shipment';
  String SelectedCapacity = 'Average (5x2 meter)';
  String selectedTruck = '';
  String SelectedLocation = 'Select location';

  Map<String, String> truckMap = {
    'Normal ShipmentAverage (5x2 meter)': 'Average Classic Truck',
    'Normal ShipmentLow (1x1 meter)': 'Motor Tri-cycle',
    'Normal ShipmentHigh (7x5 meter)': 'Heavy Classic Truck',
    'FurnitureAverage (5x2 meter)': 'Half-ton Classic Truck',
    'FurnitureLow (1x1 meter)': 'Motor Tri-cycle',
    'FurnitureHigh (7x5 meter)': 'Heavy Classic Truck',
    'Frozen food': 'Frozen Truck',
    'Packages': 'Average Classic Truck',
  };

  Map<String, String> truckImageMap = {
    'Average Classic Truck': 'assets/truck3.jpg',
    'Motor Tri-cycle': 'assets/truck5.jpg',
    'Heavy Classic Truck': 'assets/truck1.jpg',
    'Frozen Truck': 'assets/truck2.jpg',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.orange,
        elevation: 0,
        title: const Text(
          'Plan your shipment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Currently not available'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.orange.withOpacity(0.7),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 4.0), // Add padding here
                              child: Icon(
                                Icons.schedule,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Pick-up now',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Currently not available'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.orange.withOpacity(0.7),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 4.0), // Add padding here
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'One way',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Select from our list of available pick-up locations:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.delivery_dining,
                      color: Colors.orange,
                      size: 24,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Select your pick-up location'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: [
                                          ListTile(
                                            title: Text('Haram'),
                                            onTap: () {
                                              setState(() {
                                                SelectedLocation = 'Haram';
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          ListTile(
                                            title: Text('October'),
                                            onTap: () {
                                              setState(() {
                                                SelectedLocation = 'October';
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          ListTile(
                                            title: Text('EL Asher'),
                                            onTap: () {
                                              setState(() {
                                                SelectedLocation = 'El Asher';
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          ListTile(
                                            title: Text('Obour'),
                                            onTap: () {
                                              setState(() {
                                                SelectedLocation = 'Obour';
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(SelectedLocation),
                                    Icon(Icons.keyboard_arrow_down),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Select your pick-up location'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: [
                                          ListTile(
                                            title: Text('Haram'),
                                            onTap: () {
                                              setState(() {
                                                SelectedLocation = 'Haram';
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          ListTile(
                                            title: Text('October'),
                                            onTap: () {
                                              setState(() {
                                                SelectedLocation = 'October';
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          ListTile(
                                            title: Text('EL Asher'),
                                            onTap: () {
                                              setState(() {
                                                SelectedLocation = 'El Asher';
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          ListTile(
                                            title: Text('Obour'),
                                            onTap: () {
                                              setState(() {
                                                SelectedLocation = 'Obour';
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(SelectedLocation),
                                    Icon(Icons.keyboard_arrow_down),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.add_circle,
                        size: 50,
                        color: Colors.orange,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Type of Shipment:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('What type is your shipment?'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: [
                                      ListTile(
                                        title: Text('Normal Shipment'),
                                        onTap: () {
                                          setState(() {
                                            ShipmentType = 'Normal Shipment';
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ListTile(
                                        title: Text('Furniture'),
                                        onTap: () {
                                          setState(() {
                                            ShipmentType = 'Furniture';
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ListTile(
                                        title: Text('Frozen food'),
                                        onTap: () {
                                          setState(() {
                                            ShipmentType = 'Frozen food';
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ListTile(
                                        title: Text('Packages'),
                                        onTap: () {
                                          setState(() {
                                            ShipmentType = 'Packages';
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(ShipmentType),
                              Icon(Icons.keyboard_arrow_down),
                            ]),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Estimated capacity:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                      'What is the estimated capacity of your shipment?'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: [
                                        ListTile(
                                          title: Text('Average (5x2 meter)'),
                                          onTap: () {
                                            setState(() {
                                              SelectedCapacity =
                                                  'Average (5x2 meter)';
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          title: Text('Low (1x1 meter)'),
                                          onTap: () {
                                            setState(() {
                                              SelectedCapacity =
                                                  'Low (1x1 meter)';
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          title: Text('High (7x5 meter)'),
                                          onTap: () {
                                            setState(() {
                                              SelectedCapacity =
                                                  'High (7x5 meter)';
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          title: Text('No idea'),
                                          onTap: () {
                                            setState(() {
                                              SelectedCapacity = 'No idea';
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(SelectedCapacity),
                              Icon(Icons.keyboard_arrow_down),
                            ]),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Suggested Truck:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext) {
                                      return AlertDialog(
                                          title: Text('Select Truck'),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: _buildTruckList(),
                                            ),
                                          ));
                                    });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      truckImageMap[selectedTruck] ??
                                          'assets/truck_placeholder.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          selectedTruck.isNotEmpty
                                              ? truckMap[selectedTruck] ??
                                                  'Unknown Truck'
                                              : 'Select Truck',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          selectedTruck.isNotEmpty
                                              ? selectedTruck
                                              : 'Tap to select a truck',
                                        ),
                                      ],
                                    )),
                                    Icon(Icons.keyboard_arrow_down),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  List<Widget> _buildTruckList() {
    return truckMap.keys.map((key) {
      return ListTile(
        title: Row(
          children: [
            Image.asset(
              truckImageMap[key] ?? 'assets/truck_placeholder.png',
              width: 50,
              height: 50,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(truckMap[key] ?? 'Unknown Truck'),
                Text(key),
              ],
            ),
          ],
        ),
        onTap: () {
          setState(() {
            selectedTruck = key;
          });
          Navigator.of(context).pop();
        },
      );
    }).toList();
  }
}
