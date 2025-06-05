import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final _authService = AuthService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String?> _getNombreUsuario(String uid) async {
    try {
      final doc = await _db.collection('usuarios').doc(uid).get();
      if (doc.exists) {
        return doc.data()?['nombre'] as String?;
      }
    } catch (e) {
      print('Error al obtener nombre: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
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
              child: const Text('Iniciar Sesión'),
              onPressed: () async {
                final user = await _authService.login(
                  emailCtrl.text.trim(),
                  passCtrl.text.trim(),
                );
                if (user != null) {
                  final nombreUsuario = await _getNombreUsuario(user.uid);
                  print('Nombre usuario: $nombreUsuario');

                  if (user.email == 'butacaysofa@admin.com') {
                    Navigator.pushReplacementNamed(context, '/admin', arguments: nombreUsuario);
                  } else {
                    Navigator.pushReplacementNamed(context, '/catalogo', arguments: nombreUsuario);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Credenciales incorrectas')),
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
