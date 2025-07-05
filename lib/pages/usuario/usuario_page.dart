import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../../pages/auth/auth_service.dart';

class UsuarioPage extends StatefulWidget {
  const UsuarioPage({super.key});

  @override
  State<UsuarioPage> createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  final _nombreCtrl = TextEditingController();
  final _apellidoCtrl = TextEditingController();
  final _edadCtrl = TextEditingController();

  final _picker = ImagePicker();
  File? _imagenSeleccionada;
  String? _imagenBase64;

  User? _user;
  bool _isEditing = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      _user = _auth.currentUser;
      if (_user != null) {
        final doc = await _db.collection('usuarios').doc(_user!.uid).get();
        if (doc.exists) {
          final data = doc.data()!;
          _nombreCtrl.text = data['nombre'] ?? '';
          _apellidoCtrl.text = data['apellido'] ?? '';
          _edadCtrl.text = (data['edad'] ?? '').toString();
          _imagenBase64 = data['fotoPerfilBase64'];
        }
      }
    } catch (e) {
      print('Error al cargar usuario: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _seleccionarImagen(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 50);
    if (picked == null) return;
    setState(() {
      _imagenSeleccionada = File(picked.path);
    });
  }

  Future<void> _subirImagen() async {
    if (_user == null || _imagenSeleccionada == null) return;

    final bytes = await _imagenSeleccionada!.readAsBytes();
    final base64Image = base64Encode(bytes);

    try {
      await _db.collection('usuarios').doc(_user!.uid).update({
        'fotoPerfilBase64': base64Image,
      });
      setState(() {
        _imagenBase64 = base64Image;
        _imagenSeleccionada = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imagen de perfil actualizada')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir imagen: $e')),
      );
    }
  }

  Future<void> _saveChanges() async {
    final nombre = _nombreCtrl.text.trim();
    final apellido = _apellidoCtrl.text.trim();
    final edadText = _edadCtrl.text.trim();

    if (nombre.isEmpty || apellido.isEmpty || edadText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    final edad = int.tryParse(edadText);
    if (edad == null || edad < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Edad inválida')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _db.collection('usuarios').doc(_user!.uid).update({
        'nombre': nombre,
        'apellido': apellido,
        'edad': edad,
      });
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos actualizados con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("No has iniciado sesión.", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/landing');
                },
                child: const Text("Iniciar sesión"),
              ),
            ],
          ),
        ),
      );
    }

    ImageProvider? imageProvider;
    if (_imagenSeleccionada != null) {
      imageProvider = FileImage(_imagenSeleccionada!);
    } else if (_imagenBase64 != null) {
      try {
        final bytes = base64Decode(_imagenBase64!);
        imageProvider = MemoryImage(bytes);
      } catch (_) {
        imageProvider = null;
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Mi perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: imageProvider,
                    child: imageProvider == null
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.image),
                        onPressed: () => _seleccionarImagen(ImageSource.gallery),
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () => _seleccionarImagen(ImageSource.camera),
                      ),
                    ],
                  ),
                  if (_imagenSeleccionada != null)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: _subirImagen,
                      icon: const Icon(Icons.check),
                      label: const Text("Guardar imagen"),
                    ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nombreCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _apellidoCtrl,
                    decoration: const InputDecoration(labelText: 'Apellido'),
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _edadCtrl,
                    decoration: const InputDecoration(labelText: 'Edad'),
                    keyboardType: TextInputType.number,
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _user!.email ?? '',
                    decoration: const InputDecoration(labelText: 'Correo electrónico'),
                    enabled: false,
                  ),
                  const SizedBox(height: 24),
                  _isEditing
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _saveChanges,
                              icon: const Icon(Icons.save),
                              label: const Text('Guardar'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => setState(() => _isEditing = false),
                              icon: const Icon(Icons.cancel),
                              label: const Text('Cancelar'),
                            ),
                          ],
                        )
                      : ElevatedButton.icon(
                          onPressed: () => setState(() => _isEditing = true),
                          icon: const Icon(Icons.edit),
                          label: const Text('Editar datos'),
                        ),
                ],
              ),
            ),
    );
  }
}
