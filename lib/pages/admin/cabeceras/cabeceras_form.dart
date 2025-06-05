import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cabeceras_model.dart';

class CabecerasForm extends StatefulWidget {
  final Cabecera? cabecera;
  const CabecerasForm({super.key, this.cabecera});

  @override
  State<CabecerasForm> createState() => _CabecerasFormState();
}

class _CabecerasFormState extends State<CabecerasForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _alturaController;
  late TextEditingController _materialController;
  late TextEditingController _disenoController;
  late TextEditingController _imagenController;
  late TextEditingController _precioController;

  @override
  void initState() {
    super.initState();
    _alturaController = TextEditingController(text: widget.cabecera?.altura ?? '');
    _materialController = TextEditingController(text: widget.cabecera?.material ?? '');
    _disenoController = TextEditingController(text: widget.cabecera?.disenoDecorativo ?? '');
    _imagenController = TextEditingController(text: widget.cabecera?.imagenUrl ?? '');
    _precioController = TextEditingController(
        text: widget.cabecera?.precio.toString() ?? '');
  }

  @override
  void dispose() {
    _alturaController.dispose();
    _materialController.dispose();
    _disenoController.dispose();
    _imagenController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (_formKey.currentState!.validate()) {
      final cabecera = Cabecera(
        altura: _alturaController.text,
        material: _materialController.text,
        disenoDecorativo: _disenoController.text,
        imagenUrl: _imagenController.text,
        precio: double.parse(_precioController.text),
      );

      final collection =
          FirebaseFirestore.instance.collection('productos_cabeceras');

      if (widget.cabecera == null) {
        await collection.add(cabecera.toMap());
      } else {
        await collection.doc(widget.cabecera!.id).update(cabecera.toMap());
      }

      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(widget.cabecera == null ? 'Agregar Cabecera' : 'Editar Cabecera'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _alturaController,
                decoration: const InputDecoration(labelText: 'Altura'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese la altura' : null,
              ),
              TextFormField(
                controller: _materialController,
                decoration: const InputDecoration(labelText: 'Material'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese el material' : null,
              ),
              TextFormField(
                controller: _disenoController,
                decoration:
                    const InputDecoration(labelText: 'Diseño decorativo'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingrese el diseño decorativo'
                    : null,
              ),
              TextFormField(
                controller: _imagenController,
                decoration: const InputDecoration(
                    labelText: 'URL Imagen Google Drive'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingrese URL de imagen'
                    : null,
              ),
              TextFormField(
                controller: _precioController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Precio (S/.)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el precio';
                  }
                  final parsed = double.tryParse(value);
                  if (parsed == null || parsed <= 0) {
                    return 'Ingrese un precio válido';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar')),
        ElevatedButton(onPressed: _guardar, child: const Text('Guardar')),
      ],
    );
  }
}
