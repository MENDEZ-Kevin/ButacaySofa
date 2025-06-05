import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Registro con email, pass y nombre
  Future<User?> register(String email, String password, String nombre) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = cred.user;

      if (user != null) {
        // Guardar el nombre en Firestore, colección 'usuarios' con doc = uid
        await _db.collection('usuarios').doc(user.uid).set({
          'nombre': nombre,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return user;
    } catch (e) {
      print('Error en registro: $e');
      return null;
    }
  }

  // Login con email y pass
  Future<User?> login(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return cred.user;
    } catch (e) {
      print('Error en login: $e');
      return null;
    }
  }

  // Cerrar sesión
  Future<void> logout() async {
    await _auth.signOut();
  }
}
