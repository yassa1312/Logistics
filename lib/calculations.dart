import 'package:flutter/material.dart';
import 'checkout.dart';

class SelectedTruckController extends ChangeNotifier {
  String _selectedTruck = 'Average Classic Box Truck';

  String get selectedTruck => _selectedTruck;

  set selectedTruck(String value) {
    _selectedTruck = value;
    notifyListeners(); // Notify the listeners that the selected truck has changed
  }
}

class CostCalculator {
  static const Map<String, double> locationCosts = {
    'October-Asher': 50.0,
    'Haram-Ramses': 70.0,
  };

  static const Map<String, double> truckCosts = {
    'Average Classic Box Truck': 100.0,
    'Large Truck': 150.0,
    'Motor Tri-cycle': 50,
    'Pickup Truck': 70,
    'Platform Truck': 250,
    'Refrigerated Truck': 150.0,
    'Half-ton Classic Truck': 100.0
  };

  static const double serviceCostIncreasePercentage = 0.1; // 10%

  static double calculateTotalCost(
      String sourceLocation,
      String destinationLocation,
      String selectedTruck,
      bool isInsuredTransportation,
      bool isTakeCare,
      bool isExtraWrapping,
      ) {
    double totalCost =
        locationCosts['$sourceLocation-$destinationLocation'] ?? 0.0;
    totalCost += truckCosts[selectedTruck] ?? 0.0;

    if (isInsuredTransportation)
      totalCost *= (1 + serviceCostIncreasePercentage);
    if (isTakeCare) totalCost *= (1 + serviceCostIncreasePercentage);
    if (isExtraWrapping) totalCost *= (1 + serviceCostIncreasePercentage);

    return totalCost;
  }
}

class CalculationPage extends StatefulWidget {
  @override
  _CalculationPageState createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  String ShipmentType = 'Normal Truck';
  String SelectedCapacity = 'Average (4 ton)';
  String selectedTruck = 'Average Classic Box Truck';
  String selectedTruckKey = '';
  String SelectedLocation = 'Select source';
  String SelectedLocation2 = 'Select destination';
  bool isInsuredTransportation = false;
  bool isTakeCare = false;
  bool isExtraWrapping = false;

  final Map<String, double> locationCosts = {
    'October-Asher': 50.0,
    'Haram-Ramses': 70.0,
    // Define costs for other location pairs
  };

  String get totalCost {
    if (!isLocationsSelected) {
      return ''; // Return empty string if locations are not selected
    } else {
      double cost = CostCalculator.calculateTotalCost(
        SelectedLocation,
        SelectedLocation2,
        selectedTruck,
        isInsuredTransportation,
        isTakeCare,
        isExtraWrapping,
      );
      return '${cost.toStringAsFixed(2)}\ EGP'; // Return formatted cost string
    }
  }

  bool get isLocationsSelected =>
      SelectedLocation != 'Select source' &&
          SelectedLocation2 != 'Select destination';

  List<int> truckKeys = [1, 2, 3, 4];

  String getTruckKey(String shipmentType, String capacity) {
    return '\$shipmentType\$capacity';
  }

  void updateSelectedTruck() {
    String key = getTruckKey(ShipmentType, SelectedCapacity);
    setState(() {
      selectedTruck = truckMap[key]!;
    });
  }

  final List<String> pickUpList = [
    'October',
    'Haram',
    'Ramses',
    'Salam',
    'Maadi'
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
    'Very Low (1 ton)',
    'Low (2 ton)',
    'Average (4 ton)',
    'High (8 ton)',
    'Heavy (10 ton)',
    'No idea'
  ];
  Map<String, String> truckMap = {
    'Normal shipmentAverage (4 ton)': 'Average Classic Box Truck',
    'Normal shipmentLow (1 ton)': 'Motor Tri-cycle',
    'Normal shipmentHigh (8 ton)': 'Pickup Truck',
    'Normal shipmentHeavy (10 ton)': 'Platform Truck',
    'IndusterialAverage (4 ton)': 'Average Classic Box Truck',
    'IndusterialLow (1 ton)': 'Average Classic Box Truck',
    'IndusterialHigh (8 ton)': 'Pickup Truck',
    'IndusterialHeavy (10 ton)': 'Platform Truck',
    'FurnitureAverage (4 ton)': 'Half-ton Classic Truck',
    'FurnitureLow (1 ton)': 'Motor Tri-cycle',
    'FurnitureHigh (8 ton)': 'Pickup Truck',
    'FurnitureHeavy (10 ton)': 'Platform Truck',
    'Frozen food Average(4 ton)': 'Refrigerated Truck',
    'Frozen foodVery low(1 ton)': 'Refrigerated Truck',
    'Frozen foodLow (2 ton)': 'Refrigerated Truck',
    'Frozen foodBelow (1 ton)': 'Refrigerated Truck',
    'Frozen foodHigh (8 tonn)': 'Refrigerated Truck',
    'Frozen foodHeavy (10 ton)': 'Refrigerated Truck',
    'Packages': 'Average Classic Box Truck',
    'ElectronicsVery low(1 ton)': 'Average Classic Box Truck',
    'ElectronicsLow (2 ton)': 'Average Classic Box Truck',
    'ElectronicsAverage(4 ton)': 'Average Classic Box Truck',
    'ElectronicsBelow average(2 ton)': 'Average Classic Box Truck',
    'ElectronicsHigh (8 ton)': 'Large Truck',
    'ElectronicsHeavy (10 ton)': 'Large Truck',
  };

  Map<String, String> truckImageMap = {
    'Average Classic Box Truck': 'assets/truck3.jpg',
    'Large Truck': 'assets/truck6.jpg',
    'Half-ton Classic Truck': 'assets/truck4.jpg',
    'Motor Tri-cycle': 'assets/truck5.jpg',
    'Pickup Truck': 'assets/truck7.jpg',
    'Platform Truck': 'assets/truck1.jpg',
    'Refrigerated Truck': 'assets/truck2.jpg',
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
                                  String customLocation = '';
                                  return AlertDialog(
                                    title: Text('Select your pick-up location'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: [
                                          // Text field for entering a custom location
                                          TextField(
                                            decoration: InputDecoration(
                                              hintText: 'Enter custom location',
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                customLocation = value; // Update the custom location
                                              });
                                            },
                                            onSubmitted: (value) {
                                              setState(() {
                                                SelectedLocation = customLocation; // Set the selected location to the custom location
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          ...pickUpList.map((location) {
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  String customLocation = '';
                                  return AlertDialog(
                                    title: Text('Select your destination location'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: [
                                          // Text field for entering a custom location
                                          TextField(
                                            decoration: const InputDecoration(
                                              hintText: 'Enter custom location',
                                            ),
                                            onChanged: (value) {
                                              customLocation = value; // Update the custom location
                                            },
                                            textInputAction: TextInputAction.done, // Only trigger on "Done" button
                                            onSubmitted: (value) {
                                              setState(() {
                                                SelectedLocation2 = value; // Set the selected location to the custom location
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          ...pickUpList.map((location) {
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          backgroundColor: Colors.orange,
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
                          backgroundColor: Colors.orange,
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
                ),
                CheckboxListTile(
                  title: Text('Insured transportation'),
                  activeColor: Colors.orange,
                  value: isInsuredTransportation,
                  onChanged: (bool? newValue) {
                    setState(() {
                      isInsuredTransportation = newValue!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('TakeCare'),
                  activeColor: Colors.orange,
                  value: isTakeCare,
                  onChanged: (bool? newValue) {
                    setState(() {
                      isTakeCare = newValue!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Extra wrapping'),
                  activeColor: Colors.orange,
                  value: isExtraWrapping,
                  onChanged: (bool? newValue) {
                    setState(() {
                      isExtraWrapping = newValue!;
                    });
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey)),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total cost = $totalCost',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: isLocationsSelected
                            ? () {
                                // Navigate to checkout page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutPage(
                                      sourceLocation: SelectedLocation,
                                      destinationLocation: SelectedLocation2,
                                      selectedTruck: selectedTruck,
                                      totalCost: totalCost,
                                      selectedServices: [
                                        if (isInsuredTransportation)
                                          'Insured transportation',
                                        if (isTakeCare) 'TakeCare',
                                        if (isExtraWrapping) 'Extra wrapping',
                                      ],
                                    ),
                                  ),
                                );
                              }
                            : null,
                        child: Text('Checkout',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
