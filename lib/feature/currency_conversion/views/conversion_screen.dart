import 'package:currency_converter/feature/currency_conversion/viewmodels/convertion_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversionScreen extends StatefulWidget {
  const ConversionScreen({super.key});

  @override
  State<ConversionScreen> createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ConversionViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Advanced Exchanger'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const Text('INSERT AMOUNT :'),
            const SizedBox(height: 16),
            Container(
              height: 70,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 47, 47, 47),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButton<String>(
                      value: viewModel.baseCurrency,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          viewModel.setBaseCurrency(newValue);
                        }
                      },
                      items: viewModel.currencyList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      underline: Container(),
                    ),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                onChanged: (value) {
                  viewModel.setAmount(double.tryParse(value) ?? 0.0);
                },
              ),
            ),
            const SizedBox(height: 32),
            const Text('CONVERT TO :'),
            const SizedBox(height: 8),
            ...viewModel.targetCurrencies.asMap().entries.map((entry) {
              int index = entry.key;
              String targetCurrency = entry.value;
              double convertedValue = viewModel.convertCurrency(targetCurrency);
              bool isDeleteVisible = false;

              return StatefulBuilder(
                builder: (context, setState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onLongPress: () {
                              setState(() {
                                isDeleteVisible =
                                    !isDeleteVisible; 
                              });
                            },
                            child: Container(
                              height: 70,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 47, 47, 47),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    convertedValue.toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  (!isDeleteVisible)
                                      ? DropdownButton<String>(
                                          value: targetCurrency,
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              viewModel.updateTargetCurrency(
                                                  index, newValue);
                                            }
                                          },
                                          items: viewModel.currencyList
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          underline: Container(),
                                        )
                                      : IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            viewModel.removeConverter(index);
                                            setState(() {
                                              isDeleteVisible =
                                                  false; 
                                            });
                                          },
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                  style: const ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Color.fromARGB(255, 10, 60, 12)),
                    foregroundColor: WidgetStatePropertyAll(
                        Color.fromARGB(255, 164, 237, 166)),
                  ),
                  onPressed: viewModel.addNewConverter,
                  child: const Text('+ ADD CONVERTER'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
