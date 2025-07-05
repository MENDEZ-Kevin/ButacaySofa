import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Registro de usuario con email, contraseña, nombre, apellido y edad.
  Future<User?> register(String email, String password, String nombre, String apellido, int edad) async {
    try {
      // Crear usuario en Firebase Auth
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = cred.user;

      // Si el usuario se ha creado correctamente
      if (user != null) {
        // Guardar datos adicionales en Firestore
        await _db.collection('usuarios').doc(user.uid).set({
          'nombre': nombre,
          'apellido': apellido,
          'edad': edad,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(), // Tiempos del servidor
        });

        return user;
      } else {
        print('❌ El usuario es null después del registro');
        return null;
      }
    } catch (e) {
      print('❌ Error en registro: $e');
      return null;
    }
  }

  /// Login con email y contraseña.
  Future<User?> login(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      print('❌ Error en login: $e');
      return null;
    }
  }

  /// Cierra la sesión del usuario actual.
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Obtiene el usuario actual (si está logueado)
  User? get currentUser => _auth.currentUser;

  /// Escucha los cambios en el estado de autenticación.
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
