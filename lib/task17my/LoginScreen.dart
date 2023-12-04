import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_screen/task17my/ForgetPassword.dart';
import 'package:login_screen/task17my/OtpScreen.dart';
import 'package:login_screen/task17my/ResetScreen.dart';
import 'package:login_screen/task17my/RegisterScreen.dart';
import 'HomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
 );
runApp(const SignUpApp());}
class SignUpApp extends StatelessWidget {
  const SignUpApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:const LoginScreen(),
    );
  }
}
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}
class LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final emailController = TextEditingController();
  TextEditingController passwordController =TextEditingController();
  final confirmPasswordController = TextEditingController();
  // Form Validation
  //Define form key
  //Wrap Column with Form
  //Bind form key with Form
  //Write your validators in TextFormFie1d
  //call form key for validate
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void login() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    String email = emailController.text;
    String password = passwordController.text;
    FirebaseAuth. instance. signInWithEmailAndPassword (
      email: email,
      password: password,
    ).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }).catchError((error){
      print("Error =>$error");

      if(error is FirebaseAuthException){
        print("Error =>${error.code}");
        if (error.code == 'user-not-found') {
          displayToast('No user found for that email.');
        } else if (error.code == 'wrong-password') {
          displayToast('Wrong password provided for that user.');
        }else if (error.code == 'too-many-requests') {
          displayToast('Wrong password');
        }
      }
      displayToast(error.toString());
    });
    //   if (email == "yassa@gmail.com" && password == "123123") {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => const NoteScreen()),
    //     );
    //   } else {
    //     print('Email or password wrong!');
    //     displayToast("Email or password wrong!");
    //   }
  }
  void displayToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child:Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Icon(Icons.login,
                size: 55,
                color: Colors.white,
              ),
            ),
           Expanded(
             child: Container(
               padding:EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight:Radius.circular(50.0), // Adjust the radius value as needed
                    ),
                   ),
                    child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        TextFormField(
                          controller: emailController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email required";
                            }
                            if (!value.contains("@")||!value.contains(".")) {
                              return "Invalid email!";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: passwordController,
                          textInputAction: TextInputAction.done,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: GestureDetector(
                              onTap: togglePasswordVisibility,
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => navToForgetPassword(context),
                            child: const Text(
                              "Forget password",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: login,
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      backgroundColor: Colors.blue,
                                    ),
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Add navigation logic for SignUp button
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const RegisterScreen(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    child: const Text(
                                      "SignUp",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
           ),
          ],
        ),
      ),
    );
  }
}
void navToForgetPassword(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ForgetPassword()),
  );}

void navToOtpScreen(BuildContext context, String verificationCode) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const OtpScreen()),
  );}
void navToResetScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ResetScreen()),
  );}
void navToLoginScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );}
void navToSignUpScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const RegisterScreen()),
  );}
double calculatePasswordStrength(String password) {
  int minLength =8 ;
  int requiredCharacterTypes = 4; // You can adjust this based on your requirements

  int score = 0;

  // Check length
  if (password.length >= minLength) {
    score++;
  }

  // Check for uppercase letters
  if (password.contains(RegExp(r'[A-Z]'))) {
    score++;
  }

  // Check for lowercase letters
  if (password.contains(RegExp(r'[a-z]'))) {
    score++;
  }

  // Check for digits
  if (password.contains(RegExp(r'[0-9]'))) {
    score++;
  }

  // Check for special characters
  if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    score++;
  }

  // Calculate strength value based on requiredCharacterTypes
  double strength = score / requiredCharacterTypes;
  return strength.clamp(0.0, 1.0); // Clamp the value between 0.0 and 1.0
}
Color getPasswordStrengthColor(double strength) {
  if (strength < 0.3) { // Adjusted value
    return Colors.red;
  } else if (strength < 0.6) { // Adjusted value
    return Colors.orange;
  } else if (strength < 0.9) {
    return Colors.yellow;
  } else {
    return Colors.green;
  }
}


