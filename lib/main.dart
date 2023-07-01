import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> initialDelay() {
    return Future.delayed(const Duration(seconds: 5));
  }

  Future<Map<String, String?>> fetchData() async {
    final responseSteam = await http.get(
      Uri.parse(
          'https://steamcommunity.com/market/listings/730/%E2%98%85%20Butterfly%20Knife%20%7C%20Stained%20%28Field-Tested%29'),
    );

    final documentSteam = parser.parse(responseSteam.body);

    String? title = documentSteam.querySelector('title')?.text;
    String? steamPrice = documentSteam
        .querySelector('.market_listing_price.market_listing_price_with_fee')
        ?.text
        .trim();

    final imageElement =
        documentSteam.querySelector('.market_listing_largeimage img');
    final imageRoute = imageElement?.attributes['src'];

    Map<String, String?> content = {
      'title': title,
      'steamPrice': steamPrice,
      'imageRoute': imageRoute,
    };

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([fetchData(), initialDelay()]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 75),
                    child: Text(
                      'Skin Stats',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 130,
                  ),
                  SizedBox(
                    width: 200,
                    child: Image.asset('assets/r.png'),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  const SpinKitThreeBounce(
                    color: Colors.white,
                    size: 50.0,
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 25),
                    child: Text(
                      'by raivac',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text('Error al obtener los datos');
        } else {
          final content = snapshot.data![0] as Map<String, String?>;

          final title = content['title'] ?? '';
          final steamPrice =
              content['steamPrice'] ?? 'Error al cargar el precio';
          final realPrice = content['realPrice'] ?? 'Error al cargar el precio';
          final imageRoute = content['imageRoute'] ?? 'Error';

          return Scaffold(
            appBar: title.isNotEmpty
                ? AppBar(title: const Text('Skin Stats'))
                : null,
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.network(
                            width: 100,
                            imageRoute,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text('Precio Steam: $steamPrice'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('Precio Real: $realPrice'),
                            ],
                          ),
                        ),
                        IconButton(
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
                                    url:
                                        'https://buff.163.com/goods/42584#page_num=1',
                                    appBar: AppBar(
                                      title: const Text('Skin Stats'),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_right),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Divider(
                        color: Color.fromARGB(255, 219, 219, 219),
                      ),
                    ),
                    const Spacer(),
                    const Center(
                      child: Text(
                        'by raivac',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
