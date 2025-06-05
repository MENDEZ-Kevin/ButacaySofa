import 'package:flutter/material.dart';
import 'auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nombreCtrl = TextEditingController();
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrarse')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre de usuario'),
            ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Crear cuenta'),
              onPressed: () async {
                final user = await _authService.register(
                  emailCtrl.text.trim(),
                  passCtrl.text.trim(),
                  nombreCtrl.text.trim(),
                );
                if (user != null) {
                  Navigator.pushReplacementNamed(context, '/catalogo');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error al crear cuenta')),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Entrar al catálogo sin iniciar sesión'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/catalogo');
              },
            ),
          ],
        ),
      ),
    );
  }
}
