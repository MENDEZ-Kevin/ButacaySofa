import 'package:flutter/material.dart';

// Importaciones de páginas
import '../catalogo/catalogo_page.dart';
import '../ubicacion/ubicacion_page.dart';
import '../usuario/usuario_page.dart';

class HomePage extends StatefulWidget {
  final int startIndex;

  const HomePage({super.key, this.startIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex;

  final List<Widget> _pages = const [
    CatalogoPage(),
    TiendaScreen(),
    UsuarioPage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.startIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<BottomNavigationBarItem> _bottomNavItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.store),
      label: 'Catálogo',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.location_on),
      label: 'Ubicación',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Usuario',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo con imagen
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/fondo_sala.webp',
              fit: BoxFit.cover,
              color: Colors.white.withOpacity(0.50), // Ajusta opacidad aquí
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: const Color.fromARGB(255, 116, 62, 50),
                title: const Text(
                  'Butaca y Sofá',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                centerTitle: true,
                elevation: 6,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined, size: 28, color: Colors.white),
                      tooltip: 'Ver carrito',
                      onPressed: () {
                        Navigator.pushNamed(context, "/carrito");
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: _pages[_selectedIndex],
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: _bottomNavItems,
        selectedItemColor: Colors.brown[800],
        unselectedItemColor: Colors.brown[300],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white.withOpacity(0.80),
        elevation: 8,
      ),
    );
  }
}
