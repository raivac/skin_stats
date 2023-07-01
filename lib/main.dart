import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// ignore: depend_on_referenced_packages
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:skin_stats/items/item_list.dart';

void main() {
  runApp(const MyApp());
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
          return _splashScreen();
        } else if (snapshot.hasError) {
          return const Text('Error al obtener los datos');
        } else {
          final itemList = snapshot.data!;
          return _itemListWidget(itemList);
        }
      },
    );
  }

  Scaffold _itemListWidget(List<Map<String, String?>> itemList) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skin Stats')),
      body: ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          // print(itemList);
          final content = itemList[index];
          final title = content['title'] ?? '';
          final steamPrice =
              content['steamPrice'] ?? 'Error al cargar el precio';
          final realPrice = content['realPrice'] ?? 'Error al cargar el precio';
          final imageRoute = content['imageRoute'] ?? 'Error';

          return Padding(
            padding: const EdgeInsets.all(15),
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
                        imageRoute!,
                        width: 100,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Precio Steam: $steamPrice',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Precio Real: $realPrice',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
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
                                url: ItemList()
                                    .itemList
                                    .entries
                                    .toList()[index]
                                    .value
                                    .toString(),
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
              ],
            ),
          );
        },
      ),
      extendBody: true,
    );
  }

  Scaffold _splashScreen() {
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
  }

  Future<List<Map<String, String?>>> _fetchData() async {
    List<Map<String, String?>> itemList = [];

    for (var entry in ItemList().itemList.entries) {
      final responseSteam = await http.get(entry.value);
      final documentSteam = parser.parse(responseSteam.body);

      String? title = documentSteam.querySelector('title')?.text.trim();
      title = title?.replaceAll('Steam Community Market :: Listings for', '');

      String? steamPrice = documentSteam
          .querySelector('.market_listing_price.market_listing_price_with_fee')!
          .text
          .trim();
      steamPrice = steamPrice;
      String? realPrice = steamPrice;

      final imageElement =
          documentSteam.querySelector('.market_listing_largeimage img');
      final imageRoute = imageElement?.attributes['src'];

      Map<String, String?> content = {
        'title': title,
        'steamPrice': steamPrice,
        'imageRoute': imageRoute,
        'realPrice': realPrice
      };

      if (imageRoute != null && title != "Steam Community :: Error") {
        itemList.add(content);
      }
    }

    return itemList;
  }
}
