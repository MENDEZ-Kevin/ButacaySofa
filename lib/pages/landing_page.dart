import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bienvenido',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown,
        centerTitle: true,
        elevation: 4,
      ),
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/fondo_sala.webp',
              fit: BoxFit.cover,
            ),
          ),

          // Capa blanca semitransparente
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.70),
            ),
          ),

          // Contenido principal
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/butacasofa_logo.png',
                        height: 260,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Frase destacada
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '"Comodidad y estilo para cada rincón de tu hogar"',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: Colors.brown,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Botones
                  _styledButton(context, 'Iniciar Sesión', '/login'),
                  const SizedBox(height: 14),
                  _styledButton(context, 'Registrarse', '/register'),
                  const SizedBox(height: 14),
                  _styledButton(context, 'Catálogo', '/catalogo'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _styledButton(BuildContext context, String text, String route) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, route),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.hovered)) {
            return Colors.brown.shade900;
          }
          return Colors.brown.shade700;
        }),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        elevation: MaterialStateProperty.all(6),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      child: Text(text),
    );
  }
}
