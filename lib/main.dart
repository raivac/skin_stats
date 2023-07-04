import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// ignore: depend_on_referenced_packages
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:skin_stats/item_routes/item_steam_list.dart';
import 'package:skin_stats/widgets/calculatort_widget.dart';
import 'package:skin_stats/widgets/recovery_password.dart';
import 'package:skin_stats/widgets/splash_screen_widget.dart';

import 'item_routes/item_buff_list.dart';
import 'item_routes/item_dmarket_list copy.dart';
import 'item_routes/item_titles.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  runApp(const MyApp());
  Timer(
    const Duration(seconds: 3),
    () {
      FlutterNativeSplash.remove();
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Center(
        child: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String?>>>(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreenWidget();
        } else if (snapshot.hasError) {
          return Scaffold(
            body: const Center(
              child: Text('Error al obtener los datos'),
            ),
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Skin Stats'),
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => super.widget),
                      );
                    },
                    icon: const Icon(
                      Icons.refresh,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          final itemList = snapshot.data!;
          return _itemListWidget(itemList);
        }
      },
    );
  }

  Scaffold _itemListWidget(List<Map<String, String?>> itemList) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 207, 204, 204),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PasswordRecoveryPage()),
          );
        },
        child: const Icon(Icons.lock_reset),
      ),
      appBar: appbar(),
      body: Column(
        children: [
          CalculatorWidget(),
          Expanded(
            child: ListView.builder(
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                final content = itemList[index];
                final title = content['title'] ?? '';
                final steamPrice =
                    content['steamPrice'] ?? 'Error al cargar el precio';
                final realPrice =
                    content['realPrice'] ?? 'Error al cargar el precio';
                final imageRoute = content['imageRoute'] ?? 'Error';
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (title.isNotEmpty)
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Image.network(
                                  imageRoute,
                                  width: 110,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Precio Steam: $steamPrice',
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Precio Real: $realPrice',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _redirectButton(
                                index,
                                'Steam',
                                ItemSteamList(),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              _redirectButton(
                                index,
                                'Buff',
                                ItemBuffList(),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              _redirectButton(
                                index,
                                'DMarket',
                                ItemDMarketList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 219, 219, 219),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _redirectButton(int index, String text, dynamic items) {
    return SizedBox(
      width: 90,
      height: 30,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.blue,
          side: const BorderSide(
            color: Colors.blue,
          ),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WillPopScope(
                onWillPop: () async {
                  FlutterWebviewPlugin flutterWebViewPlugin =
                      FlutterWebviewPlugin();
                  flutterWebViewPlugin.close();
                  return true;
                },
                child: WebviewScaffold(
                  url: items.itemList.entries.toList()[index].value.toString(),
                  appBar: appbar(),
                ),
              ),
            ),
          );
        },
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  AppBar appbar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // const Text('Skin Stats'),
          Image.asset(
            'assets/r.png',
            width: 150,
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => super.widget),
              );
            },
            icon: const Icon(
              Icons.refresh,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, String?>>> _fetchData() async {
    List<Map<String, String?>> itemList = [];
    for (var entry in ItemBuffList().itemList.entries) {
      final responseSteam = await http.get(
        Uri.parse(entry.value),
      );
      final documentSteam = parser.parse(responseSteam.body);

      String? title = documentSteam.querySelector('h1')?.text.trim();

      String? steamPriceInDollars = documentSteam
          .querySelector('strong.f_Strong')!
          .text
          .trim()
          .replaceAll("(", "")
          .replaceAll(")", "")
          .replaceAll("\$", "");
      var realPriceInDollars = double.parse(steamPriceInDollars) -
          (double.parse(steamPriceInDollars) * 30 / 100);

      final imageElement = documentSteam.querySelector('.t_Center img');
      final imageRoute = imageElement?.attributes['src'];

      final numberFormat = NumberFormat.currency(locale: 'es_ES', symbol: '€');

      String? steamPriceInEuros = numberFormat.format(
        double.parse(steamPriceInDollars),
      );
      String? realPriceInEuros = numberFormat.format(
        realPriceInDollars,
      );
      title = titles[title!];

      Map<String, String?> content = {
        'title': title,
        'steamPrice': steamPriceInEuros,
        'realPrice': realPriceInEuros,
        'imageRoute': imageRoute,
      };
      itemList.add(content);
    }
    return itemList;
  }
}
