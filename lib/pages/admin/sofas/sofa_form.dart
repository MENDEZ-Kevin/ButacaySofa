import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SofaForm extends StatefulWidget {
  final Map<String, dynamic>? sofa;

  const SofaForm({super.key, this.sofa});

  @override
  State<SofaForm> createState() => _SofaFormState();
}

class _SofaFormState extends State<SofaForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _materialController = TextEditingController();
  final TextEditingController _numeroPiezasController = TextEditingController();
  final TextEditingController _disenoController = TextEditingController();
  final TextEditingController _imagenController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();  // nuevo controlador

  @override
  void initState() {
    super.initState();
    if (widget.sofa != null) {
      _materialController.text = widget.sofa!['material'] ?? '';
      _numeroPiezasController.text = '${widget.sofa!['numero_piezas'] ?? ''}';
      _disenoController.text = widget.sofa!['diseno'] ?? '';
      _imagenController.text = widget.sofa!['imagen'] ?? '';
      _precioController.text = widget.sofa!['precio'] != null ? widget.sofa!['precio'].toString() : '';
    }
  }

  Future<void> _guardarSofa() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'material': _materialController.text.trim(),
        'numero_piezas': int.tryParse(_numeroPiezasController.text.trim()) ?? 0,
        'diseno': _disenoController.text.trim(),
        'imagen': _imagenController.text.trim(),
        'precio': double.tryParse(_precioController.text.trim()) ?? 0.0,  // guardamos precio como double
      };

      final coleccion = FirebaseFirestore.instance.collection('productos_sofa');

      if (widget.sofa == null) {
        await coleccion.add(data);
      } else {
        await coleccion.doc(widget.sofa!['id']).update(data);
      }

      Navigator.of(context).pop(); // Cerrar formulario
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.sofa == null ? 'Agregar Sofá' : 'Editar Sofá'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _materialController,
                decoration: const InputDecoration(labelText: 'Material'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese el material' : null,
              ),
              TextFormField(
                controller: _numeroPiezasController,
                decoration: const InputDecoration(labelText: 'Número de piezas'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final num = int.tryParse(value ?? '');
                  if (num == null || num <= 0) return 'Ingrese un número válido';
                  return null;
                },
              ),
              TextFormField(
                controller: _disenoController,
                decoration: const InputDecoration(labelText: 'Diseño'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese el diseño' : null,
              ),
              TextFormField(
                controller: _imagenController,
                decoration: const InputDecoration(labelText: 'Enlace de imagen (Drive)'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese un enlace de imagen' : null,
              ),
              TextFormField(
                controller: _precioController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  final precio = double.tryParse(value ?? '');
                  if (precio == null || precio <= 0) {
                    return 'Ingrese un precio válido mayor a 0';
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
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _guardarSofa,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
