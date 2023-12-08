import 'package:flutter/material.dart';
import 'package:login_screen/e/core/app_dio.dart';
import 'package:login_screen/e/core/app_endpoints.dart';
import 'package:login_screen/e/ui/shared.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PreferenceUtils.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ELoginScreen(), // Set your ELoginScreen as the home
    );
  }
}
class ELoginScreen extends StatefulWidget {
  const ELoginScreen({super.key});

  @override
  State<ELoginScreen> createState() => _ELoginScreenState();
}

class _ELoginScreenState extends State<ELoginScreen> {
  @override
  void initState() {
    super.initState();
    print('Language => ${PreferenceUtils.getString(PrefKeys.language)}');
    AppDio.post(endpoint: EndPoints.login, body: {
      'email': 'amir@ultras.com',
      'password': '123456',
    }).then((value) {
      print(value);
      String apiToken = value.data['data']['token'];
      PreferenceUtils.setString(PrefKeys.apiToken, apiToken);
      print('apiToken => $apiToken');
      Future.delayed(const Duration(seconds:1)).then((value) {
        getProfile();
      });
    });
  }

  void getProfile() {
    AppDio.get(endpoint: EndPoints.profile).then(
      (value) {
        print(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
