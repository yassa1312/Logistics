import 'package:flutter/material.dart';

class CalculationPage extends StatefulWidget {
  @override
  _CalculationPageState createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  String ShipmentType = 'Normal Shipment';
  String SelectedCapacity = 'Average (4x3 meter)';
  String selectedTruck = 'Average Classic Box Truck';
  String selectedTruckKey = '';
  String SelectedLocation = 'Select source';
  String SelectedLocation2 = 'Select destination';

  List<int> truckKeys = [1, 2, 3, 4];

  String getTruckKey(String shipmentType, String capacity) {
    return '\$shipmentType\$capacity';
  }

  void updateSelectedTruck() {
    String key = getTruckKey(ShipmentType, SelectedCapacity);
    setState(() {
      selectedTruck = truckMap[key] ?? 'Average Classic Box Truck';
    });
  }

  final List<String> pickUpList = [
    'October',
    'Haram',
    'Ramses',
    'Salam',
    'Maadi',
    'Asher'
  ];
  final List<String> shipmentList = [
    'Normal shipment',
    'Industerial',
    'Furniture',
    'Frozen food',
    'Packages',
    'Electronics'
  ];
  final List<String> capacityList = [
    'Average (4x3 meter)',
    'Low (1x1 meter)',
    'Very low',
    'High (3x3 meter)',
    'Heavy (5x5 meter)',
    'No idea'
  ];
  Map<String, String> truckMap = {
    'Normal shipmentAverage (4x3 meter)': 'Average Classic Box Truck',
    'Normal shipmentLow (1x1 meter)': 'Motor Tri-cycle',
    'Normal shipmentHigh (3x3 meter)': 'Pickup Truck',
    'Normal shipmentHeavy (5x5 meter)': 'Platform Truck',
    'IndustrialVery low': 'High Classic Box Truck',
    'IndustrialLow': 'High Classic Box Truck',
    'IndustrialAverage': 'High Classic Box Truck',
    'IndustrialBelow average': 'High Classic Box Truck',
    'IndustrialHigh': 'Platform Truck',
    'IndustrialHeavy': 'Platform Truck',
    'FurnitureAverage (4x3 meter)': 'Half-ton Classic Truck',
    'FurnitureLow (1x1 meter)': 'Motor Tri-cycle',
    'FurnitureHigh (3x3 meter)': 'Pickup Truck',
    'FurnitureHeavy (5x5 meter)': 'Platform Truck',
    'Frozen food': 'Refrigerator Truck',
    'Packages': 'Average Classic Box Truck',
    'ElectronicsVery low': 'Average Classic Box Truck',
    'ElectronicsLow': 'Average Classic Box Truck',
    'ElectronicsAverage': 'Average Classic Box Truck',
    'ElectronicsBelow average': 'Average Classic Box Truck',
    'ElectronicsHigh': 'High Classic Box Truck',
    'ElectronicsHeavy': 'High Classic Box Truck',
  };

  Map<String, String> truckImageMap = {
    'Average Classic Box Truck': 'assets/truck3.jpg',
    'High Classic Box Truck': 'assets/truck6.jpg',
    'Half-ton Classic Truck': 'assets/truck4.jpg',
    'Motor Tri-cycle': 'assets/truck5.jpg',
    'Pickup Truck': 'assets/truck7.jpg',
    'Platform Truck': 'assets/truck1.jpg',
    'Refrigerator Truck': 'assets/truck2.jpg',
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
                                        children: pickUpList.map((location) {
                                          return ListTile(
                                            title: Text(location),
                                            onTap: () {
                                              setState(() {
                                                SelectedLocation = location;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        }).toList(),
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      SelectedLocation,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Icon(Icons.keyboard_arrow_down),
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
                                    title: Text(
                                        'Select your destination location'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: pickUpList.map((location) {
                                          return ListTile(
                                            title: Text(location),
                                            onTap: () {
                                              setState(() {
                                                SelectedLocation2 = location;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        }).toList(),
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      SelectedLocation2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Icon(Icons.keyboard_arrow_down),
                                ],
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
                                    children: shipmentList.map((shipmentType) {
                                      return ListTile(
                                        title: Text(shipmentType),
                                        onTap: () {
                                          setState(() {
                                            ShipmentType = shipmentType;
                                            selectedTruck = truckMap[
                                                    '$ShipmentType$SelectedCapacity'] ??
                                                'Average Classic Box Truck';
                                            updateSelectedTruck;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    }).toList(),
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
                                      children:
                                          capacityList.map((selectedCapacity) {
                                        return ListTile(
                                          title: Text(selectedCapacity),
                                          onTap: () {
                                            setState(() {
                                              SelectedCapacity =
                                                  selectedCapacity;
                                              selectedTruck = truckMap[
                                                      '$ShipmentType$SelectedCapacity'] ??
                                                  'Average Classic Box Truck';
                                              updateSelectedTruck;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      }).toList(),
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
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            'Select Truck',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: truckMap.values
                                                  .toSet()
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                String truckName = truckMap
                                                    .values
                                                    .toSet()
                                                    .elementAt(index);

                                                String truckImage =
                                                    truckImageMap[truckName]!;
                                                return ListTile(
                                                  leading: Image.asset(
                                                    truckImage,
                                                    width: 50,
                                                    height: 50,
                                                  ),
                                                  title: Text(truckName),
                                                  onTap: () {
                                                    setState(() {
                                                      selectedTruck = truckName;
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
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
                                  child: Column(children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          truckImageMap[selectedTruck]!,
                                          width: 50,
                                          height: 50,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            selectedTruck,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Icon(Icons.keyboard_arrow_down),
                                      ],
                                    ),
                                    Text('Tap to change'),
                                  ])),
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
}
