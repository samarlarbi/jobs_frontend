import 'package:flutter/material.dart';
import 'package:jobs_app/auth/CustomButton.dart';
import 'package:jobs_app/auth/Custominput.dart';
import 'package:jobs_app/auth/SignUpPage.dart';
import 'package:jobs_app/main.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:jobs_app/utils/mybutton.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Colorone,
              ),
            ),
                  CInput(
                    myController: emailController,
                    name: "email",
                    hintText: "email",
                    obscureText: false,
                    validator: (email) =>
                        isValidEmail(email!) ? "email is not valid! " : null,
                  ),
                  CInput(
                    validator: (pass) =>
                        pass!.length < 8 ? "email is not valid! " : null,
                    myController: passController,
                    name: "password",
                    hintText: "password",
                    obscureText: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                            },
                        child: Text(
                          "forget the password? ",
                          style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  )
               ,
            auth.isLoading
                ? const CircularProgressIndicator()
                : 
                
                CustomButton(
                onPressed: () async {
               
                 try {
                        await auth.login(emailController.text, passController.text);
                        if (auth.isAuthenticated) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Main()));
                        }
                      } catch (e) {
                        print("e::$e");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: $e'),backgroundColor: const Color.fromARGB(255, 168, 67, 59) ,));
                      }
                   
                },
                title: "Login",
                bgcolor: Colorone,
                titlecolor: Colors.white),
               
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account ? ",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 162, 161, 161),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Text(
                      'sign Up ',
                      style: TextStyle(
                        color:Color2,
                        decoration: TextDecoration.underline,
                        decorationColor: Color2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            )
          
          
          
          ,  const SizedBox(height: 20),
           
          ],
        ),
      ),
    );
  }
   bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email!) || (email == null || email.isEmpty);
  }
}
