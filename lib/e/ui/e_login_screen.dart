import 'package:flutter/material.dart';
import 'package:login_screen/e/core/app_dio.dart';
import 'package:login_screen/e/core/app_endpoints.dart';
import 'package:login_screen/note1/shared.dart';


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
      print('apiToken => $apiToken');
      PreferenceUtils.setString(PrefKeys.apiToken, apiToken);

      Future.delayed(const Duration(seconds: 1)).then((value) {
        getProfile();
      });
    });
  }

  void getProfile() {
    AppDio.get(endpoint: EndPoints.profile, category: '', currentCountry: '').then(
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
