import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sofa_form.dart';

class SofaPage extends StatefulWidget {
  const SofaPage({super.key});

  @override
  State<SofaPage> createState() => _SofaPageState();
}

class _SofaPageState extends State<SofaPage> {
  List<Map<String, dynamic>> sofas = [];

  @override
  void initState() {
    super.initState();
    obtenerSofas();
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

  Future<void> obtenerSofas() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('productos_sofa').get();

      setState(() {
        sofas = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            ...doc.data(),
          };
        }).toList();
      });
    } catch (e) {
      print('Error al obtener sofás: $e');
    }
  }

  void _mostrarFormulario([Map<String, dynamic>? sofa]) async {
    await showDialog(
      context: context,
      builder: (_) => SofaForm(sofa: sofa),
    );
    obtenerSofas();
  }

  void _eliminarSofa(String id) async {
    await FirebaseFirestore.instance.collection('productos_sofa').doc(id).delete();
    obtenerSofas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Sofás')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(),
        child: const Icon(Icons.add),
      ),
      body: sofas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: sofas.length,
              itemBuilder: (context, index) {
                final sofa = sofas[index];
                final urlImagenOriginal = sofa['imagen'] as String? ?? '';
                final urlImagenDirecta = convertirEnlaceDriveADirecto(urlImagenOriginal);
                final precio = sofa['precio'] != null
                    ? (sofa['precio'] is int
                        ? (sofa['precio'] as int).toDouble()
                        : sofa['precio'] as double)
                    : 0.0;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: urlImagenOriginal.isNotEmpty
                            ? Image.network(
                                urlImagenDirecta,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const SizedBox(
                                      height: 200,
                                      child: Center(child: Icon(Icons.broken_image, size: 60)),
                                    ),
                              )
                            : const SizedBox(
                                height: 200,
                                child: Center(child: Icon(Icons.image_not_supported, size: 60)),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Material: ${sofa['material'] ?? 'N/A'}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Plazas: ${sofa['numero_piezas'] ?? '0'}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Diseño: ${sofa['diseno'] ?? ''}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Precio: S/ ${precio.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _mostrarFormulario(sofa),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _eliminarSofa(sofa['id']),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
