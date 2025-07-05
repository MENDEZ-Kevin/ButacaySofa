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
  final apellidoCtrl = TextEditingController();
  final edadCtrl = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: Colors.brown[300],
        centerTitle: true,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Butaca y Sofá',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
                letterSpacing: 1.3,
              ),
            ),
            const SizedBox(height: 28),
            _buildInputField(nombreCtrl, 'Nombre', Icons.person),
            const SizedBox(height: 12),
            _buildInputField(apellidoCtrl, 'Apellido', Icons.person_outline),
            const SizedBox(height: 12),
            _buildInputField(edadCtrl, 'Edad', Icons.cake, tipo: TextInputType.number),
            const SizedBox(height: 12),
            _buildInputField(emailCtrl, 'Correo electrónico', Icons.email, tipo: TextInputType.emailAddress),
            const SizedBox(height: 12),
            TextField(
              controller: passCtrl,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _registrar,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.brown.shade900;
                        }
                        return Colors.brown.shade700;
                      }),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      )),
                      elevation: MaterialStateProperty.all(5),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    child: const Text('Crear cuenta'),
                  ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/catalogo');
              },
              child: const Text(
                'Entrar al catálogo sin iniciar sesión',
                style: TextStyle(color: Colors.brown),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, IconData icon,
      {TextInputType tipo = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: tipo,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Future<void> _registrar() async {
    final nombre = nombreCtrl.text.trim();
    final apellido = apellidoCtrl.text.trim();
    final edadStr = edadCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    if ([nombre, apellido, edadStr, email, pass].any((e) => e.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    final edad = int.tryParse(edadStr);
    if (edad == null || edad < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Edad inválida')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = await _authService.register(email, pass, nombre, apellido, edad);
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/catalogo');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo crear la cuenta')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
