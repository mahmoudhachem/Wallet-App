import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String firstname = '';
  String lastname = '';
  double balance = 0.00;
  double initialBalance = 0.00; // To store the fetched balance
  List<Map<String, dynamic>> transactionsData = [];

  // Function to fetch user data from the API
  Future<void> _fetchUser() async {
    const String url1 = 'http://localhost/wallet/get_user.php';
    try {
      final response1 = await http.get(Uri.parse(url1));
      if (response1.statusCode == 200) {
        final data = json.decode(response1.body);

        setState(() {
          firstname = data['firstname'];
          lastname = data['lastname'];
          balance = double.tryParse(data['balance']) ?? 0.00;
          initialBalance = balance; // Store the fetched balance
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Function to fetch expenses from the API
  Future<void> _fetchExpenses() async {
    const String url = 'http://localhost/wallet/get_expenses.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          List<Map<String, dynamic>> fetchedExpenses = [];

          for (var expense in responseData['data'] ?? []) {
            fetchedExpenses.add({
              'icon': _getCategoryIcon(expense['category'] ?? ''),
              'color': _getCategoryColor(expense['category'] ?? ''),
              'name': expense['category'] ?? 'Unknown',
              'totalAmount': '-\$${expense['amount'] ?? 0}',
              'date': expense['date'] ?? 'Unknown',
            });
            balance -= double.parse(expense['amount']?.toString() ?? '0');
          }

          setState(() {
            transactionsData = fetchedExpenses;
          });
        }
      }
    } catch (e) {
      print('Error fetching expenses: $e');
    }
  }

  // Function to get category icon based on category name
  Widget _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return const FaIcon(FontAwesomeIcons.burger, color: Colors.white);
      case 'shopping':
        return const FaIcon(FontAwesomeIcons.bagShopping, color: Colors.white);
      case 'health':
        return const FaIcon(FontAwesomeIcons.heartCircleCheck,
            color: Colors.white);
      case 'travel':
        return const FaIcon(FontAwesomeIcons.plane, color: Colors.white);
      case 'entertainment':
        return const FaIcon(FontAwesomeIcons.gamepad, color: Colors.white);
      case 'governmental fees':
        return const FaIcon(FontAwesomeIcons.buildingCircleCheck,
            color: Colors.white);
      case 'others':
        return const FaIcon(FontAwesomeIcons.paperclip, color: Colors.white);
      default:
        return const FaIcon(FontAwesomeIcons.circle, color: Colors.white);
    }
  }

  // Function to get category color based on category name
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.yellow[700]!;
      case 'shopping':
        return Colors.purple;
      case 'health':
        return Colors.red;
      case 'travel':
        return Colors.blue;
      case 'entertainment':
        return Colors.green;
      case 'governmental fees':
        return Colors.brown;
      case 'others':
        return Colors.blueAccent;
      default:
        return Colors.blueAccent;
    }
  }

  String _formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('MMMM dd, yyyy').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  // Function to clear all expenses and reset balance
  Future<void> _clearExpenses() async {
    const String url = 'http://localhost/wallet/clear_expenses.php';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          setState(() {
            transactionsData = [];
            balance = initialBalance; // Reset balance to the fetched balance
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('All expenses have been cleared.'),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Failed to clear expenses.'),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to connect to the server.'),
        ));
      }
    } catch (e) {
      print('Error clearing expenses: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error clearing expenses.'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _fetchExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.yellow[700],
                          ),
                        ),
                        Icon(
                          CupertinoIcons.person_fill,
                          color: Colors.yellow[900],
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome!',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        Text(firstname,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            )),
                      ],
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {}, icon: const Icon(CupertinoIcons.settings))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.tertiary
                    ],
                    transform: const GradientRotation(pi / 4),
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.grey.shade400,
                      offset: const Offset(5, 5),
                    )
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "Total Balance",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    " \$ ${balance.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 25,
                                  height: 25,
                                  decoration: const BoxDecoration(
                                    color: Colors.white30,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      CupertinoIcons.arrow_down,
                                      size: 12,
                                      color: Colors.greenAccent,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Income",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      " \$ 2500",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 25,
                              height: 25,
                              decoration: const BoxDecoration(
                                color: Colors.white30,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  CupertinoIcons.arrow_down,
                                  size: 12,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Expenses",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  " \$ 800 ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transactions',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: _clearExpenses, // Call the clear expenses function
                  child: Text(
                    'Clear all',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.outline,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            // Use Expanded to display the list of expenses dynamically
            Expanded(
              child: ListView.builder(
                itemCount: transactionsData.length,
                itemBuilder: (context, int i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: transactionsData[i]['color'],
                                          shape: BoxShape.circle),
                                    ),
                                    transactionsData[i]['icon'],
                                  ],
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  transactionsData[i]['name'],
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  transactionsData[i]['totalAmount'],
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  _formatDate(transactionsData[i]['date']),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
