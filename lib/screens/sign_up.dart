import 'package:flutter/material.dart';
import 'package:pizza/services/auth_service.dart';
import 'package:pizza/widgets/app_bar.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> sendSignUpFormAndRedirect(String email, String password) async {
    try {
      bool signUpSuccessful = await authService.signUp(email, password);
      if (signUpSuccessful) {
        Navigator.pushReplacementNamed(context, '/signin');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vous pouvez vous connecter.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inscription échouée. Veuillez réessayer.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'inscription: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Inscription",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                sendSignUpFormAndRedirect(
                    emailController.text, passwordController.text);
              },
              child: const Text('S\'inscrire'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signin');
              },
              child: const Text(
                'Vous avez déjà un compte?',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
