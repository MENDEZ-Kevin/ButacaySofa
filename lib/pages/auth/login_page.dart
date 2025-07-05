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
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        backgroundColor: Colors.brown[300],
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Butaca y Sofá',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 160, 116, 100),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 28),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final user = await _authService.login(
                  emailCtrl.text.trim(),
                  passCtrl.text.trim(),
                );
                if (user != null) {
                  final nombreUsuario = await _getNombreUsuario(user.uid);
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
              style: _estiloBoton(),
              child: const Text('Iniciar Sesión'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/catalogo');
              },
              style: _estiloBoton(colorClaro: true),
              child: const Text('Entrar al catálogo sin iniciar sesión'),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _estiloBoton({bool colorClaro = false}) {
    final baseColor = colorClaro ? Colors.brown.shade400 : Colors.brown.shade700;
    final hoverColor = colorClaro ? Colors.brown.shade600 : Colors.brown.shade900;

    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (states) => states.contains(MaterialState.hovered) ? hoverColor : baseColor,
      ),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      elevation: MaterialStateProperty.all(5),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      textStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
