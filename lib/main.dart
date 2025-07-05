import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

// ✅ Importar el controlador del carrito
import 'modules/carrito/carrito_controller.dart';
import 'modules/carrito/carrito_page.dart';


// Páginas de autenticación y bienvenida
import 'pages/landing_page.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';

// Página de administración
import 'pages/admin/admin_page.dart';

// Página con BottomNavigationBar
import 'pages/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CarritoController()), // ✅ Provider del carrito
      ],
      child: MaterialApp(
        title: 'Tienda Virtual',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LandingPage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/catalogo': (context) => const HomePage(startIndex: 0),  // ✅ Ir al Catálogo
          '/admin': (context) => AdminPage(),
          '/ubicacion': (context) => const HomePage(startIndex: 1), // ✅ Ir a Ubicación
          '/usuario': (context) => const HomePage(startIndex: 2),  // ✅ Ir a Usuario
          '/carrito': (context) => const CarritoPage(),  // ✅ Ir al Carrito
          '/landing': (context) => const LandingPage(),
        },
      ),
    );
  }
}
