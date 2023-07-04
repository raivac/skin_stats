import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
// <PORT>: 465 (SSL) o 587 (TLS)

class PasswordRecoveryPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  PasswordRecoveryPage({super.key});

  void sendPasswordRecoveryEmail() async {
    final smtpServer = SmtpServer(
      'smtp.gmail.com',
      username: 'xxxxxxxxxxxx@gmail.com',
      password: 'xxxxxxxxxxxx',
      port: 587,
    );

    final message = Message()
      ..from = 'xxxxxxxxxxxx@gmail.com'
      ..recipients.add(emailController.text)
      ..subject = 'Recuperación de contraseña'
      ..text = 'Recuperación de contraseña';

    try {
      final sendReport = await send(message, smtpServer);
      print('Enviado: ${sendReport.messageSendingEnd}');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: sendPasswordRecoveryEmail,
              child: const Text('Recuperar contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}
