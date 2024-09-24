import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ConversionViewModel extends ChangeNotifier {
   List<String> currencyList = [
    'USD',
    'EUR',
    'JPY',
    'GBP',
    'AUD',
    'CAD',
    'CHF',
    'CNY',
    'SEK',
    'NZD',
    'INR',
    'RUB',
    'ZAR',
    'BRL',
    'SGD',
    'MXN',
    'HKD',
    'NOK',
    'KRW',
    'TRY',
    'THB',
    'LKR',
  ];

  String baseCurrency = 'LKR';
  double amount = 0.0;
  List<String> targetCurrencies = ['USD'];
  Map<String, double> conversionRates = {};

  ConversionViewModel() {
    loadPreferredCurrencies();
  }

  Future<void> loadPreferredCurrencies() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? storedCurrencies = sharedPreferences.getStringList('targetCurrencies');
    if (storedCurrencies != null) {
      targetCurrencies = storedCurrencies;
    }
    fetchConversionRates(); 
    notifyListeners();
  }

  Future<void> savePreferredCurrencies() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setStringList('targetCurrencies', targetCurrencies);
  }

  void setBaseCurrency(String newBaseCurrency) {
    baseCurrency = newBaseCurrency;
    fetchConversionRates(); 
    notifyListeners();
  }

  void setAmount(double newAmount) {
    amount = newAmount;
    notifyListeners();
  }

  double convertCurrency(String targetCurrency) {
    if (conversionRates.containsKey(targetCurrency)) {
      return amount * conversionRates[targetCurrency]!;
    }
    return amount;
  }

  void addNewConverter() {
    targetCurrencies.add(currencyList[0]);
    savePreferredCurrencies();
    notifyListeners();
  }

  void removeConverter(int index) {
    targetCurrencies.removeAt(index);
    savePreferredCurrencies();
    notifyListeners();
  }

  void updateTargetCurrency(int index, String newTargetCurrency) {
    targetCurrencies[index] = newTargetCurrency;
    savePreferredCurrencies();
    notifyListeners();
  } 

  String getCurrentDate() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  String constructApiUrl(String baseCurrency) {
    String currentDate = getCurrentDate();
    return 'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@$currentDate/v1/currencies/${baseCurrency.toLowerCase()}.json';
  }

  Future<void> fetchConversionRates() async {
    final apiUrl = constructApiUrl(baseCurrency);
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        for (String currencyList in currencyList) {
          if (data[baseCurrency.toLowerCase()].containsKey(currencyList.toLowerCase())) {
            conversionRates[currencyList] =
                data[baseCurrency.toLowerCase()][currencyList.toLowerCase()].toDouble();
          } else {
            conversionRates[currencyList] =
                1.0; 
          }
        }
        notifyListeners();
      } else {
        throw Exception('Failed to load conversion rates');
      }
    } catch (e) {
      print('Error fetching conversion rates: $e');
    }
  }
}
