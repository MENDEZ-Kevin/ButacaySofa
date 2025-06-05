import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cabecera_model.dart';
import 'cabecera_card.dart';

class CabecerasCatalogoPage extends StatelessWidget {
  const CabecerasCatalogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de Cabeceras')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('productos_cabeceras').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar datos: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay cabeceras disponibles'));
          }

          final cabeceras = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Cabecera.fromMap(data, doc.id);
          }).toList();

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: cabeceras.length,
            itemBuilder: (context, index) => CabeceraCard(cabecera: cabeceras[index]),
          );
        },
      ),
    );
  }
}
