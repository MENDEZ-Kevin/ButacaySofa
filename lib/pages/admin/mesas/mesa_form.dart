import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MesaForm extends StatefulWidget {
  final Map<String, dynamic>? mesa;
  const MesaForm({super.key, this.mesa});

  @override
  State<MesaForm> createState() => _MesaFormState();
}

class _MesaFormState extends State<MesaForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController materialCtrl;
  late TextEditingController formaCtrl;
  late TextEditingController funcionalidadCtrl;
  late TextEditingController imagenCtrl;
  late TextEditingController precioCtrl;

  @override
  void initState() {
    super.initState();
    materialCtrl = TextEditingController(text: widget.mesa?['material'] ?? '');
    formaCtrl = TextEditingController(text: widget.mesa?['forma'] ?? '');
    funcionalidadCtrl = TextEditingController(text: widget.mesa?['funcionalidad'] ?? '');
    imagenCtrl = TextEditingController(text: widget.mesa?['imagenUrl'] ?? '');
    precioCtrl = TextEditingController(text: widget.mesa?['precio']?.toString() ?? '');
  }

  @override
  void dispose() {
    materialCtrl.dispose();
    formaCtrl.dispose();
    funcionalidadCtrl.dispose();
    imagenCtrl.dispose();
    precioCtrl.dispose();
    super.dispose();
  }

  void _guardar() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'material': materialCtrl.text.trim(),
        'forma': formaCtrl.text.trim(),
        'funcionalidad': funcionalidadCtrl.text.trim(),
        'imagenUrl': imagenCtrl.text.trim(),
        'precio': double.parse(precioCtrl.text.trim()),
      };

      final ref = FirebaseFirestore.instance.collection('productos_mesa');

      if (widget.mesa == null) {
        await ref.add(data);
      } else {
        await ref.doc(widget.mesa!['id']).update(data);
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.mesa == null ? 'Agregar Mesa' : 'Editar Mesa'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: materialCtrl,
                decoration: const InputDecoration(labelText: 'Material'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: formaCtrl,
                decoration: const InputDecoration(labelText: 'Forma'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: funcionalidadCtrl,
                decoration: const InputDecoration(labelText: 'Funcionalidad'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: imagenCtrl,
                decoration: const InputDecoration(labelText: 'URL Imagen (Drive)'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: precioCtrl,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requerido';
                  final precio = double.tryParse(v);
                  if (precio == null || precio <= 0) return 'Ingrese un precio válido mayor que 0';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(onPressed: _guardar, child: const Text('Guardar')),
      ],
    );
  }
}
