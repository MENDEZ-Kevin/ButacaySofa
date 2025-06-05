import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'comedor_model.dart';
import 'comedor_card.dart';

class ComedorCatalogoPage extends StatelessWidget {
  const ComedorCatalogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de Comedores')),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('productos_comedor').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          final comedores = docs.map((doc) {
            final data = doc.data();
            return Comedor.fromMap(data, doc.id);
          }).toList();

          return ListView.builder(
            itemCount: comedores.length,
            itemBuilder: (context, index) => ComedorCard(comedor: comedores[index]),
          );
        },
      ),
    );
  }
}
