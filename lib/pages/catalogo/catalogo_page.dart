import 'package:flutter/material.dart';

import 'butacas/butaca_catalogo_page.dart';
import 'sofas/sofa_catalogo_page.dart';
import 'mesas/mesa_catalogo_page.dart';
import 'comedores/comedor_catalogo_page.dart';
import 'cabeceras/cabecera_catalogo_page.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  State<CatalogoPage> createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  int _selectedIndex = 0;

  // Páginas para cada sección del BottomNavigationBar
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildCatalogoGrid(),                   // Catálogo principal
      const ButacaCatalogoPage(),            // Tienda (ejemplo con butacas)
      const Center(child: Text('Perfil')),   // Perfil (puedes reemplazar por tu vista real)
    ];
  }

  @override
  Widget build(BuildContext context) {
    final nombreUsuario = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Productos'),
      ),
      body: _selectedIndex == 0
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (nombreUsuario != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Bienvenido, $nombreUsuario',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  Expanded(child: _buildCatalogoGrid()),
                ],
              ),
            )
          : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Catálogo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Tienda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  // Construye el grid con botones para navegar a cada tipo de producto
  Widget _buildCatalogoGrid() {
    return GridView.count(
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
    );
  }

  Widget _botonModulo(BuildContext context, String titulo, IconData icono, Widget destino) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.teal,
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
