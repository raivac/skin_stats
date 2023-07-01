import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// ignore: depend_on_referenced_packages
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

void main() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
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
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<String> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://steamcommunity.com/market/listings/730/%E2%98%85%20Butterfly%20Knife%20%7C%20Stained%20%28Field-Tested%29'));
    final document = parser.parse(response.body);
    final String? title = document.querySelector('title')?.text;

    return title ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skin Stats'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SizedBox(
          child: FutureBuilder<String>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Cargando datos',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SpinKitFadingCircle(
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return const Text('Error al obtener los datos');
              } else {
                final title = snapshot.data ?? '';
                return Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4)).then(
      (value) => {
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (ctx) => const HomeScreen(),
          ),
        ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 55),
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
}
