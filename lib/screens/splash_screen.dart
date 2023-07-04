import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(
              height: 130,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Image.asset('assets/r.png'),
            ),
            const SizedBox(
              height: 130,
            ),
            const Text(
              'Cargando datos',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            const SpinKitFadingCircle(
              color: Colors.white,
              size: 60.0,
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
