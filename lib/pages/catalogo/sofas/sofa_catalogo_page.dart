import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sofa_model.dart';
import 'sofa_card.dart';

class SofaCatalogoPage extends StatelessWidget {
  const SofaCatalogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de Sofás')),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('productos_sofa').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          final sofas = docs.map((doc) {
            final data = doc.data();
            return Sofa.fromMap(data, doc.id);
          }).toList();

          return ListView.builder(
            itemCount: sofas.length,
            itemBuilder: (context, index) => SofaCard(sofa: sofas[index]),
          );
        },
      ),
    );
  }
}
