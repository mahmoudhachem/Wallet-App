import 'dart:convert';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallet/screens/home/views/home_screen.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  void main() => runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SignupPage(),
      ));

  Future<void> clearAccounts() async {
    final url1 = 'http://localhost/wallet/clear_accounts.php';
    final response1 = await http.post(
      Uri.parse(url1),
    );
  }

  Future<void> clearExpenses() async {
    final url2 = 'http://localhost/wallet/clear_expenses.php';
    final response2 = await http.post(
      Uri.parse(url2),
    );
  }

  Future<void> signUp(String firstname, String lastname, double balance) async {
    final url = 'http://localhost/wallet/sign-up.php';

    try {
      final response2 = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'firstname': firstname,
          'lastname': lastname,
          'balance': balance,
        }),
      );

      if (response2.statusCode == 200) {
        final responseBody2 = json.decode(response2.body);
      } else {
        print('Error calling API 2: ${response2.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController balanceController = TextEditingController();

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.tertiary
          ], transform: GradientRotation(pi / 35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  FadeInUp(
                      duration: Duration(milliseconds: 1300),
                      child: Text(
                        "Welcome to your E-Wallet",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                      ),
                      FadeInUp(
                          duration: Duration(milliseconds: 1400),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade400,
                                      blurRadius: 5,
                                      offset: Offset(5, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                // First Name Field
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200))),
                                  child: TextField(
                                    controller: firstNameController,
                                    // Assign controller here
                                    decoration: InputDecoration(
                                        hintText: "Your First Name",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // Last Name Field
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200))),
                                  child: TextField(
                                    controller: lastNameController,
                                    // Assign controller here
                                    decoration: InputDecoration(
                                        hintText: "Your Last Name",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // Balance Field
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200))),
                                  child: TextField(
                                    controller: balanceController,
                                    // Assign controller here
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        hintText: "Your Wallet Balance",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 40,
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1600),
                        child: MaterialButton(
                          onPressed: () {
                            final firstname = firstNameController.text;
                            final lastname = lastNameController.text;
                            final balance =
                                double.tryParse(balanceController.text) ?? 0.00;

                            // Call signUp function to insert data into the database
                            clearAccounts();
                            clearExpenses();
                            signUp(firstname, lastname, balance);

                            // Navigate to the home screen after successful signup
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const HomeScreen(),
                              ),
                            );
                          },
                          height: 50,
                          color: Theme.of(context).colorScheme.tertiary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      FadeInUp(
                          duration: Duration(milliseconds: 1700),
                          child: Text(
                            "Continue with: ",
                            style: TextStyle(color: Colors.grey),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: FadeInUp(
                                duration: Duration(milliseconds: 1800),
                                child: MaterialButton(
                                  onPressed: () {},
                                  height: 50,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'omt.png',
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                )),
                          ),
                          Expanded(
                            child: FadeInUp(
                                duration: Duration(milliseconds: 1900),
                                child: MaterialButton(
                                  onPressed: () {},
                                  height: 50,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'iconwhish.png',
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                )),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
