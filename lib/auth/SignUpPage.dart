import 'package:flutter/material.dart';
import 'package:jobs_app/home/homeScreen.dart';
import 'package:jobs_app/main.dart';
import 'package:jobs_app/providers/auth_provider.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'Custominput.dart';
import 'CustomButton.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKeys = List.generate(3, (_) => GlobalKey<FormState>());
  final _pageController = PageController();

  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController cpass = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController services = TextEditingController();

  bool _isSubmitting = false;
  int _currentPage = 0;
  bool _publishAsWorker = false;

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    email.dispose();
    pass.dispose();
    cpass.dispose();
    location.dispose();
    services.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _handleSignUp(AuthProvider auth) async {
    if (_formKeys[2].currentState!.validate()) {
      setState(() => _isSubmitting = true);
      try {
        await auth.signUp({
          "name": name.text.trim(),
          "email": email.text.trim(),
          "password": pass.text,
          "location": location.text.trim(),
          "phone": phone.text.trim(),
          "role":_publishAsWorker?'WORKER': "CLIENT"
        });

        await auth.login(email.text.trim(), pass.text);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Main()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup failed: $e")),
        );
      } finally {
        setState(() => _isSubmitting = false);
      }
    } else {
      print("Final form validation failed.");
    }
  }

  void _nextPage() {
    if (_formKeys[_currentPage].currentState!.validate()) {
      if (_currentPage < 2) {
        setState(() => _currentPage++);
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final horizontalPadding = width * 0.08;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _currentPage > 0
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colorone),
                onPressed: _prevPage,
              )
            : null,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.07),
              child: Text(
                "Sign Up.",
                style: TextStyle(
                  fontSize: width * 0.09,
                  fontWeight: FontWeight.bold,
                  color: Colorone,
                ),
              ),
            ),
            SizedBox(height: height * 0.015),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  // Page 1
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Form(
                      key: _formKeys[0],
                      child: Column(
                        children: [
                          CInput(
                            name: "Name",
                            hintText: "Enter your full name",
                            myController: name,
                            obscureText: false,
                            validator: (value) =>
                                value == null || value.length < 3 ? "Name must be at least 3 characters" : null,
                          ),
                          CInput(
                            name: "Phone",
                            hintText: "Enter your phone number",
                            myController: phone,
                            obscureText: false,
                            validator: (value) =>
                                value == null || value.length < 6 ? "Enter a valid phone number" : null,
                          ),
                          CInput(
                            name: "Email",
                            hintText: "Enter your email",
                            myController: email,
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Please enter an email';
                              final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                              return emailRegex.hasMatch(value) ? null : "Invalid email format";
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Page 2
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Form(
                      key: _formKeys[1],
                      child: Column(
                        children: [
                          CInput(
                            name: "Password",
                            hintText: "Enter your password",
                            myController: pass,
                            obscureText: true,
                            validator: isValidPassword,
                          ),
                          CInput(
                            name: "Confirm Password",
                            hintText: "Re-enter your password",
                            myController: cpass,
                            obscureText: true,
                            validator: (value) =>
                                value != pass.text ? "Passwords do not match" : null,
                          ),
                          CInput(
                            name: "Location",
                            hintText: "Enter your location",
                            myController: location,
                            obscureText: false,
                            validator: (value) =>
                                value == null || value.length < 3 ? "Location must be at least 3 characters" : null,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Page 3
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Form(
                      key: _formKeys[2],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SwitchListTile(
                            title: const Text("Do you want to publish services as a worker?"),
                            activeColor: Colorone,
                            value: _publishAsWorker,
                            onChanged: (val) {
                              setState(() => _publishAsWorker = val);
                            },
                          ),
                          if (_publishAsWorker)
                            CInput(
                              name: "Services",
                              hintText: "What kind of services do you offer?",
                              myController: services,
                              obscureText: false,
                              validator: (value) {
                                if (_publishAsWorker && (value == null || value.isEmpty)) {
                                  return "Please describe your services";
                                }
                                return null;
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Smooth Page Indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: WormEffect(
                    activeDotColor: Colorone,
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 8,
                  ),
                ),
              ),
            ),

            /// Next / SignUp Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: _currentPage == 2
                  ? CustomButton(
                      onPressed: () => _handleSignUp(auth),
                      title: _isSubmitting ? "Signing up..." : "Sign Up",
                      bgcolor: Colorone,
                      titlecolor: Colors.white,
                    )
                  : CustomButton(
                      onPressed: _nextPage,
                      title: "Next",
                      bgcolor: Colorone,
                      titlecolor: Colors.white,
                    ),
            ),

            SizedBox(height: height * 0.015),

            /// Login Redirection
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?", style: TextStyle(color: Colors.grey[600])),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => Main()),
                    );
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colorone,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: height * 0.015),
          ],
        ),
      ),
    );
  }

  String? isValidPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Include at least one number';
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Include at least one special character';
    }
    return null;
  }
}
