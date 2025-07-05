import 'package:flutter/material.dart';

import 'butacas/butaca_catalogo_page.dart';
import 'sofas/sofa_catalogo_page.dart';
import 'mesas/mesa_catalogo_page.dart';
import 'comedores/comedor_catalogo_page.dart';
import 'cabeceras/cabecera_catalogo_page.dart';

class CatalogoPage extends StatelessWidget {
  const CatalogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nombreUsuario = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Oculta el botón de retroceso
        backgroundColor: Colors.brown[300],
        title: const Text(
          'Catálogo de Productos',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 6,
      ),
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/fondo_sala.webp',
              fit: BoxFit.cover,
              color: Colors.white.withOpacity(0.3),
              colorBlendMode: BlendMode.modulate,
            ),
          ),

          // Contenido principal
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  '"Empieza por lo que más te interesa"',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.brown,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                if (nombreUsuario != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Bienvenido, $nombreUsuario',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _botonModulo(context, 'Sofás', Icons.weekend, const SofaCatalogoPage()),
                      _botonModulo(context, 'Butacas', Icons.event_seat, const ButacaCatalogoPage()),
                      _botonModulo(context, 'Mesas', Icons.table_bar, const MesaCatalogoPage()),
                      _botonModulo(context, 'Comedores', Icons.chair, const ComedorCatalogoPage()),
                      _botonModulo(context, 'Cabeceras', Icons.bed, const CabecerasCatalogoPage()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonModulo(BuildContext context, String titulo, IconData icono, Widget destino) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => destino));
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.brown.shade700;
            }
            return Colors.brown.shade500;
          },
        ),
        padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevation: MaterialStateProperty.all(10),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shadowColor: MaterialStateProperty.all(Colors.black54),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icono, size: 40, color: Colors.white),
          const SizedBox(height: 10),
          Text(titulo, style: const TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }
}
