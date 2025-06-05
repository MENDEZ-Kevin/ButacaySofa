import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mesa_model.dart';
import 'mesa_card.dart';

class MesaCatalogoPage extends StatelessWidget {
  const MesaCatalogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de Mesas')),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('productos_mesa').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          final mesas = docs.map((doc) {
            final data = doc.data();
            return Mesa.fromMap(data, doc.id);
          }).toList();

          return ListView.builder(
            itemCount: mesas.length,
            itemBuilder: (context, index) => MesaCard(mesa: mesas[index]),
          );
        },
      ),
    );
  }
}
