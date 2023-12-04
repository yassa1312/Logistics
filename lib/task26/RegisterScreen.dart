import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_screen/task26/LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
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
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.orange,
        child: Column(
          children: [
            SizedBox(
              height: 300, // Adjust the height of the image container
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  'assets/amazon-logo-s3f.png', // Replace this with your image asset path
                  width: 200, // Adjust the width as needed
                  height: 200, // Adjust the height as needed
                  fit: BoxFit.fitHeight, // Adjust the fit of the image within the container
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.email,color: Colors.orange,),
                        labelStyle: TextStyle(
                          color: Colors.orange, // Change label color to orange
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
                          color: Colors.orange, // Change label color to orange
                        ),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone,color: Colors.orange,),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',labelStyle: TextStyle(
                        color: Colors.orange, // Change label color to orange
                      ),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email,color: Colors.orange,),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextFormField(
                            controller: passwordController,
                            textInputAction: TextInputAction.done,
                            obscureText: obscureText1,
                            onChanged: (password) {
                              setState(() {
                                strength = calculatePasswordStrength(password);
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                color: Colors.orange, // Change label color to orange
                              ),
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.lock,color: Colors.orange,),
                              suffixIcon: GestureDetector(
                                onTap: togglePasswordVisibility1,
                                child: Icon(
                                  obscureText1
                                      ? Icons.visibility
                                      : Icons.visibility_off,color: Colors.orange,
                                ),
                              ),
                            ),
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
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(
                                color: Colors.orange, // Change label color to orange
                              ),
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.lock,color: Colors.orange,),
                              suffixIcon: GestureDetector(
                                onTap: togglePasswordVisibility1,
                                child: Icon(
                                  obscureText1
                                      ? Icons.visibility
                                      : Icons.visibility_off,color: Colors.orange,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Add the image selection widget here

                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          primary: Colors.orange, // Set the background color to orange
                        ),
                        onPressed: () {
                          String email = emailController.text;
                          String password = passwordController.text;
                          String confirmPassword = confirmPasswordController.text;
                          String phoneNumber = phoneNumberController.text;
                          String name = nameController.text;

                          if (password == confirmPassword) {
                            // Perform actions after successful registration
                            onRegisterSuccess(context);
                          } else {
                            Fluttertoast.showToast(msg: "Passwords do not match.");
                          }
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
                              color: Colors.
                              orange,
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

  void onRegisterSuccess(BuildContext context) {
    // Perform actions after successful registration
    Fluttertoast.showToast(msg: "Account Created!");
    Navigator.pop(context); // Pop the RegisterScreen
    // Push the LoginScreen onto the navigation stack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }


  double calculatePasswordStrength(String password) {
    // Your password strength calculation logic here
    // Return the password strength value as a double
    // You can implement a password strength checker or use a package for this.
    return 0.0;
  }
}
