import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mesa_form.dart';

class MesaPage extends StatefulWidget {
  const MesaPage({super.key});

  @override
  State<MesaPage> createState() => _MesaPageState();
}

class _MesaPageState extends State<MesaPage> {
  List<Map<String, dynamic>> mesas = [];

  @override
  void initState() {
    super.initState();
    obtenerMesas();
  }

  String convertirEnlaceDriveADirecto(String enlaceDrive) {
    final regExp = RegExp(r'/d/([a-zA-Z0-9_-]+)');
    final match = regExp.firstMatch(enlaceDrive);
    if (match != null && match.groupCount >= 1) {
      final id = match.group(1);
      return 'https://drive.google.com/uc?export=view&id=$id';
    } else {
      return enlaceDrive;
    }
  }

  Future<void> obtenerMesas() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('productos_mesa').get();

      setState(() {
        mesas = snapshot.docs.map((doc) {
          return {'id': doc.id, ...doc.data()};
        }).toList();
      });
    } catch (e) {
      print('Error al obtener mesas: $e');
    }
  }

  void _mostrarFormulario([Map<String, dynamic>? mesa]) async {
    await showDialog(
      context: context,
      builder: (_) => MesaForm(mesa: mesa),
    );
    obtenerMesas();
  }

  void _eliminarMesa(String id) async {
    await FirebaseFirestore.instance.collection('productos_mesa').doc(id).delete();
    obtenerMesas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Mesas')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(),
        child: const Icon(Icons.add),
      ),
      body: mesas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: mesas.length,
              itemBuilder: (context, index) {
                final mesa = mesas[index];
                final urlImagen = convertirEnlaceDriveADirecto(mesa['imagenUrl'] ?? '');

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (mesa['imagenUrl'] != null)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          child: Image.network(
                            urlImagen,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 100),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Material: ${mesa['material']}', style: const TextStyle(fontSize: 16)),
                            Text('Forma: ${mesa['forma']}'),
                            Text('Funcionalidad: ${mesa['funcionalidad']}'),
                            Text('Precio: S/ ${mesa['precio']?.toStringAsFixed(2) ?? '0.00'}'),
                          ],
                        ),
                      ),
                      ButtonBar(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _mostrarFormulario(mesa),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _eliminarMesa(mesa['id']),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
