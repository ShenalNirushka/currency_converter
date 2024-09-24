import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConversionScreen extends StatefulWidget {
  const ConversionScreen({super.key});

  @override
  State<ConversionScreen> createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  List<String> currencyList = [
    'USD', 'EUR', 'JPY', 'GBP', 'AUD', 'CAD', 'CHF', 'CNY', 'SEK', 'NZD',
    'INR', 'RUB', 'ZAR', 'BRL', 'SGD', 'MXN', 'HKD', 'NOK', 'KRW', 'TRY', 'THB', 'LKR',
  ];

  String baseCurrency = 'LKR';
  double amount = 0.0;
  List<String> targetCurrencies = [];

  @override
  void initState() {
    super.initState();
    _loadPreferredCurrencies();
  }

  // Load preferred currencies from Shared Preferences
  Future<void> _loadPreferredCurrencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedCurrencies = prefs.getStringList('targetCurrencies');
    if (storedCurrencies != null) {
      setState(() {
        targetCurrencies = storedCurrencies;
      });
    } else {
      // If no stored currencies, add a default one
      setState(() {
        targetCurrencies = ['USD'];
      });
    }
  }

  // Save preferred currencies to Shared Preferences
  Future<void> _savePreferredCurrencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('targetCurrencies', targetCurrencies);
  }

  // Mock function to convert the amount
  double _convertCurrency(double amount, String base, String target) {
    double conversionRate = 0.85; // Mock conversion rate
    return amount * conversionRate;
  }

  void _addNewConverter() {
    setState(() {
      targetCurrencies.add(currencyList[0]);
      _savePreferredCurrencies(); // Save after adding
    });
  }

  // Function to remove a target currency
  void _removeConverter(int index) {
    setState(() {
      targetCurrencies.removeAt(index);
      _savePreferredCurrencies(); // Save after removing
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Converter removed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Insert Amount:'),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButton<String>(
                    value: baseCurrency,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          baseCurrency = newValue;
                        });
                      }
                    },
                    items: currencyList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    underline: Container(),
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  amount = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            const SizedBox(height: 32),
            const Text('Converted To:'),
            const SizedBox(height: 8),
            ...targetCurrencies.asMap().entries.map((entry) {
              int index = entry.key;
              String targetCurrency = entry.value;
              double convertedValue = _convertCurrency(amount, baseCurrency, targetCurrency);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: DropdownButton<String>(
                              value: targetCurrency,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    targetCurrencies[index] = newValue;
                                    _savePreferredCurrencies(); // Save after changing
                                  });
                                }
                              },
                              items: currencyList.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              underline: Container(),
                            ),
                          ),
                          hintText: convertedValue.toStringAsFixed(2),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _removeConverter(index),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                  onPressed: _addNewConverter,
                  child: const Text('Add Converter'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
