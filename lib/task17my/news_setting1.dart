import 'package:flutter/material.dart';

class NewsSettingScreen1 extends StatefulWidget {
  const NewsSettingScreen1({Key? key}) : super(key: key);

  @override
  State<NewsSettingScreen1> createState() => _NewsSettingScreen1State();
}

class _NewsSettingScreen1State extends State<NewsSettingScreen1> {
  String _selectedCountry = 'Select Country';
  List<String> _countries = [
    'Select Country',
    'Country 1',
    'Country 2',
    'Country 3',
    // Add other countries here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Country (Premium)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedCountry,
              onChanged: (newValue) {
                setState(() {
                  _selectedCountry = newValue!;
                });
              },
              items: _countries.map((country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement logic for handling premium country selection
                if (_selectedCountry != 'Select Country') {
                  // Implement your logic here
                  print('Premium user selected $_selectedCountry');
                } else {
                  print('Please select a country.');
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
