import 'dart:convert';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Live Currency Rates',
      home: CurrencyRatesPage(),
    ));

class CurrencyRatesPage extends StatefulWidget {
  const CurrencyRatesPage({super.key});

  @override
  _CurrencyRatesPageState createState() => _CurrencyRatesPageState();
}

class _CurrencyRatesPageState extends State<CurrencyRatesPage> {
  List<String> currencies = [];
  Map<String, double> rates = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCurrencyRates();
  }

  final Map<String, String> currencyIcons = {
    'USD': 'usa.png', // US Dollar
    'EUR': 'euro.png', // Euro
    'LBP': 'lebanon.png', // Lebanese Pound
    'SYP': 'syria.png', // Syrian Pound
    'EGP': 'circle.png', // Egyptian Pound
    'AED': 'united-arab-emirates.png', // UAE Dirham
    'KWD': 'kuwait.png', // Kuwaiti Dinar
    'SAR': 'ksa.png', // Saudi Riyal
    'CAD': 'world.png', // Canadian Dollar
    'AUD': 'australia.png', // Australian Dollar
  };

  final List<String> currenciesToFetch = [
    'USD',
    'EUR',
    'LBP',
    'SYP',
    'EGP',
    'AED',
    'KWD',
    'SAR',
    'CAD',
    'AUD'
  ];

  Future<void> fetchCurrencyRates() async {
    final String apiUrl =
        'https://v6.exchangerate-api.com/v6/a5ea8dfed17513a63c8872dc/latest/USD';
    //'https://apilayer.net/api/live?access_key=a09b8b685eb55ed645002b14b4ee81a6&currencies=EUR,GBP,CAD,PLN&source=USD&format=1';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          // Extract the conversion rates from the API response
          Map<String, dynamic> conversionRates = data['conversion_rates'];

          // Initialize the currencies and rates
          currencies = [];
          rates = {};

          // Loop through the currencies you want to fetch
          for (String currency in currenciesToFetch) {
            // Check if the currency exists in the conversion rates
            if (conversionRates.containsKey(currency)) {
              // Add the currency to the currencies list
              currencies.add(currency);

              // Add the rate for that currency to the rates map
              rates[currency] = conversionRates[currency].toDouble();
            }
          }

          isLoading = false;
        });

        // Debugging: Print the response structure and extracted data
        print(data);
        print("////");
        print("Currencies: $currencies");
        print("Rates: $rates");
      } else {
        // Handle non-200 responses
        throw Exception(
            'Failed to load currency rates: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching currency rates: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double rate = 0.0;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.tertiary
          ], transform: GradientRotation(pi)),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        FadeInLeft(
                          duration: Duration(milliseconds: 1400),
                          child: Text(
                            "Live Exchange Rates",
                            style: TextStyle(color: Colors.white, fontSize: 40),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FadeInLeft(
                          duration: Duration(milliseconds: 1400),
                          child: Text(
                            "Keep your wallet up-to-date!",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60))),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: ListView.builder(
                          itemCount: currencies.length,
                          itemBuilder: (context, index) {
                            String currency = currencies[index];
                            String icon = currencyIcons[currency] ?? '🏳';
                            if (rates.containsKey(currency)) {
                              rate = rates[currency]!;
                            } else {
                              print('Currency $currency not found in rates.');
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: FadeInUp(
                                duration: Duration(milliseconds: 1000),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Image.asset(
                                                  icon,
                                                  width: 50,
                                                  height: 50,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              currency,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Rate: ${rate.toStringAsFixed(4)}',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
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
                              ),
                            );
                          },
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
