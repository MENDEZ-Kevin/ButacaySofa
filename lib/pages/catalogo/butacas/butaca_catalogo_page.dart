import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'butaca_model.dart';
import 'butaca_card.dart';

class ButacaCatalogoPage extends StatelessWidget {
  const ButacaCatalogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de Butacas')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('productos_butaca').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay butacas disponibles'));
          }

          final butacas = snapshot.data!.docs.map((doc) {
            return Butaca.fromMap(doc.data(),id : doc.id);
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: butacas.length,
            itemBuilder: (context, index) => ButacaCard(butaca: butacas[index]),
          );
        },
      ),
    );
  }
}
