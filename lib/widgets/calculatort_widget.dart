import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CalculatorWidget extends StatefulWidget {
  CalculatorWidget({super.key});

  @override
  State<CalculatorWidget> createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  String monedaOrigen = 'EUR';

  String monedaDestino = 'CNY';

  TextEditingController valorController = TextEditingController();

  String resultado = '0';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    const Text('Moneda de origen'),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: monedaOrigen,
                      onChanged: (String? newValue) {
                        setState(() {
                          monedaOrigen = newValue!;
                        });
                      },
                      items: getDropdownItems(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Convertir a'),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: monedaDestino,
                      onChanged: (String? newValue) {
                        setState(() {
                          monedaDestino = newValue!;
                        });
                      },
                      items: getDropdownItems(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: valorController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: '0.00',
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    readOnly: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: double.parse(resultado).toStringAsFixed(2),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: procesarFetch,
                  child: const Text('Convertir'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 5),
        const SizedBox(
          width: double.infinity,
          child: Divider(
            color: Color.fromARGB(255, 219, 219, 219),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  List<DropdownMenuItem<String>> getDropdownItems() {
    return <String>[
      'AUD',
      'BGN',
      'BRL',
      'CAD',
      'CHF',
      'CNY',
      'CZK',
      'DKK',
      'EUR',
      'GBP',
      'HKD',
      'HRK',
      'HUF',
      'IDR',
      'INR',
      'ILS',
      'ISK',
      'KRW',
      'MXN',
      'JPY',
      'NOK',
      'NZD',
      'PHP',
      'PLN',
      'RON',
      'RUB',
      'SEK',
      'SGD',
      'THB',
      'TRY',
      'USD',
      'ZAR',
    ].map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  void procesarFetch() async {
    var apikey = "wkniLduZlbVkoeG9VaFe2wtF8QQ1B7Ll";
    String valor = valorController.text;

    if (valor.isEmpty) {
      valor = '0';
    }

    try {
      var response = await http.get(
          Uri.parse(
              'https://api.apilayer.com/exchangerates_data/convert?to=$monedaDestino&from=$monedaOrigen&amount=$valor'),
          headers: {'apikey': apikey});

      var data = jsonDecode(response.body);
      setState(() {
        resultado = data['result'].toString();
      });
    } catch (error) {
      print(error);
    }
  }
}
