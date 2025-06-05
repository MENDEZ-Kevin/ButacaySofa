import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

import 'butacas/butaca_page.dart';
import 'sofas/sofa_page.dart';
import 'mesas/mesa_page.dart';
import 'comedores/comedor_page.dart';
import 'cabeceras/cabeceras_page.dart';

class AdminPage extends StatelessWidget {
  AdminPage({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _botonModulo(context, 'Sofás', Icons.weekend, const SofaPage()),
            _botonModulo(context, 'Butacas', Icons.event_seat, const ButacasPage()),
            _botonModulo(context, 'Mesas', Icons.table_bar, const MesaPage()),
            _botonModulo(context, 'Comedores', Icons.chair, const ComedoresPage()),
            _botonModulo(context, 'Cabeceras', Icons.bed, const CabecerasPage()),
          ],
        ),
      ),
    );
  }

  Widget _botonModulo(BuildContext context, String titulo, IconData icono, Widget destino) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.blueGrey,
      ),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => destino),
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
