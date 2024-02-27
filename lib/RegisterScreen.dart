// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logistics/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logistics/LoginScreen.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const RegisterScreen());
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool obscureText1 = true;
  double strength = 0.0;

  void togglePasswordVisibility1() {
    setState(() {
      obscureText1 = !obscureText1;
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.orange,
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Image.asset(
                  'assets/Picture2.png', // Replace 'assets/Picture1.png' with your actual PNG file path
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: ListView(
                  children: [
                    TextFormField(
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(
                          Icons.account_box,
                          color: Colors.orange,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.orange,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: phoneNumberController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(
                          color: Colors.orange,
                        ),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Colors.orange,
                        ),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.orange,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email required";
                        }
                        if (!value.contains("@") || !value.contains(".")) {
                          return "Invalid email!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextFormField(
                            controller: passwordController,
                            textInputAction: TextInputAction.next,
                            obscureText: obscureText1,
                            onChanged: (password) {
                              setState(() {
                                strength = calculatePasswordStrength(password);
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(
                                color: Colors.orange,
                              ),
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.orange,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: togglePasswordVisibility1,
                                child: Icon(
                                  obscureText1
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password required";
                              }
                              if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: confirmPasswordController,
                            textInputAction: TextInputAction.done,
                            obscureText: obscureText1,
                            onChanged: (password) {
                              setState(() {
                                strength = calculatePasswordStrength(password);
                              });
                            },
                            onFieldSubmitted: (_) {
                              String enteredPassword =
                                  confirmPasswordController.text;
                              String originalPassword = passwordController.text;

                              if (enteredPassword == originalPassword) {
                                onRegisterSuccessFirebase(context);
                                //onRegisterSuccessAPI();//withAPI//TODO
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Passwords do not match.");
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: const TextStyle(
                                color: Colors
                                    .orange, // Change label color to orange
                              ),
                              border: const OutlineInputBorder(),
                              prefixIcon:
                                  const Icon(Icons.lock, color: Colors.orange),
                              suffixIcon: GestureDetector(
                                onTap: togglePasswordVisibility1,
                                child: Icon(
                                  obscureText1
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Colors.orange,
                        ),
                        onPressed: () {
                          // If passwords match, call the registration function
                          onRegisterSuccessFirebase(context);
                          // Alternatively, you might want to call an API registration function here
                          // onRegisterSuccessAPI();//TODO
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have account?",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void onRegisterSuccessFirebase(BuildContext context) async {
    try {
      // Check if the name is at least 3 characters
      if (nameController.text.length < 4) {
        displayToast("Name must be at least 3 characters.");
        return;
      }

      // Check if the phone number is empty
      if (phoneNumberController.text.isEmpty) {
        displayToast("Phone Number is mandatory.");
        return;
      }

      String password = passwordController.text;
      String confirmPassword = confirmPasswordController.text;

      // Check if the passwords match
      if (password == confirmPassword) {
        // If passwords match, continue with Firebase registration
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: password.trim(),
        );

        User? firebaseUser = userCredential.user;

        if (firebaseUser != null) {
          // Save additional user data to Firebase database
          Map<String, dynamic> userDataMap = {
            "name": nameController.text.trim(),
            "email": emailController.text.trim(),
            "phone": phoneNumberController.text.trim(),
          };

          // Display success message
          displayToast("Account created successfully!");

          // Navigate to login screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
          // Save user data to Firebase database
          await usersRef.child(firebaseUser.uid).set(userDataMap);
        } else {
          // Handle the case when firebaseUser is null
          print('Error: firebaseUser is null');
          displayToast("Registration failed. Please try again.");
        }
      } else {
        // If passwords don't match, display a toast message
        displayToast("Passwords do not match.");
      }
    } catch (e) {
      // Handle errors during registration
      print('Error registering user: $e');
      displayToast("Registration failed. Please try again.");
    }
  }

  void displayToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }

  void onRegisterSuccessAPI() async {
    String email = emailController.text;
    String name = nameController.text;
    String phone = phoneNumberController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (password == confirmPassword) {
      bool registrationSuccess =
          await RegistrationAPI.registerUser(email, name, phone, password);

      if (registrationSuccess) {
        displayToast("Account Created!");

        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        displayToast("Registration failed. Please try again.");
      }
    } else {
      displayToast("Passwords do not match.");
    }
  }
}

class RegistrationAPI {
  static Future<bool> registerUser(String email, String password, String name, String phone) async {
    var headers = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
      'Cookie':
          'ARRAffinity=908058b9e2be1479dd6b543a1483598c49313680b79a6118cf8ebe4a5a376c07; ARRAffinitySameSite=908058b9e2be1479dd6b543a1483598c49313680b79a6118cf8ebe4a5a376c07'
    };
    var url = Uri.parse(
        'https://logisticsapinet820231222162219.azurewebsites.net/register');

    var body = json.encode({
      "email": email,
      "password": password,
      "phone": phone,
      "name": name,
    }

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print(response.body);
        return true; // Successful registration
      } else {
        print(response.reasonPhrase);
        return false; // Unsuccessful registration
      }
    } catch (error) {
      print('Error during registration: $error');
      return false; // Error during registration
    }
  }
}

Future<void> saveUserData(String userData) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userData', userData);
}

double calculatePasswordStrength(String password) {
  return 0.0;
}
