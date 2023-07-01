import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// ignore: depend_on_referenced_packages
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:skin_stats/item_routes/item_list.dart';

import 'item_routes/item_buff_list.dart';

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
          return Scaffold(
            body: const Center(child: Text('Error al obtener los datos')),
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
                              builder: (BuildContext context) => super.widget));
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
                        builder: (BuildContext context) => super.widget));
              },
              icon: const Icon(
                Icons.refresh,
                size: 35,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          final content = itemList[index];
          final title = content['title'] ?? '';
          final steamPrice =
              content['steamPrice'] ?? 'Error al cargar el precio';
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
                    Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Precio Steam: $steamPrice',
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            OutlinedButton(
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
                                        FlutterWebviewPlugin
                                            flutterWebViewPlugin =
                                            FlutterWebviewPlugin();
                                        flutterWebViewPlugin.close();
                                        return true;
                                      },
                                      child: WebviewScaffold(
                                        url: ItemBuffList()
                                            .itemBuffList
                                            .entries
                                            .toList()[index]
                                            .value
                                            .toString(),
                                        appBar: AppBar(
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Skin Stats'),
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              super.widget));
                                                },
                                                icon: const Icon(
                                                  Icons.refresh,
                                                  size: 35,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Ir a Buff'),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            OutlinedButton(
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
                                        FlutterWebviewPlugin
                                            flutterWebViewPlugin =
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
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Skin Stats'),
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              super.widget));
                                                },
                                                icon: const Icon(
                                                  Icons.refresh,
                                                  size: 35,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Ir a Steam'),
                            ),
                          ],
                        ),
                      ],
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

      final imageElement =
          documentSteam.querySelector('.market_listing_largeimage img');
      final imageRoute = imageElement?.attributes['src'];

      Map<String, String?> content = {
        'title': title,
        'steamPrice': steamPrice,
        'imageRoute': imageRoute,
      };

      if (imageRoute != null && title != "Steam Community :: Error") {
        itemList.add(content);
      }
    }

    return itemList;
  }
}
