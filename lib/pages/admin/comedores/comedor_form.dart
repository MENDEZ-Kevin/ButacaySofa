import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComedorForm extends StatefulWidget {
  final Map<String, dynamic>? comedor;

  const ComedorForm({super.key, this.comedor});

  @override
  State<ComedorForm> createState() => _ComedorFormState();
}

class _ComedorFormState extends State<ComedorForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _materialController = TextEditingController();
  final TextEditingController _tipoMesaController = TextEditingController();
  final TextEditingController _capacidadController = TextEditingController();
  final TextEditingController _imagenUrlController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();  // nuevo

  @override
  void initState() {
    super.initState();
    if (widget.comedor != null) {
      _materialController.text = widget.comedor!['material'] ?? '';
      _tipoMesaController.text = widget.comedor!['tipo_mesa'] ?? '';
      _capacidadController.text = widget.comedor!['capacidad_personas']?.toString() ?? '';
      _imagenUrlController.text = widget.comedor!['imagenUrl'] ?? '';
      _precioController.text = widget.comedor!['precio']?.toString() ?? '';  // nuevo
    }
  }

  @override
  void dispose() {
    _materialController.dispose();
    _tipoMesaController.dispose();
    _capacidadController.dispose();
    _imagenUrlController.dispose();
    _precioController.dispose();  // nuevo
    super.dispose();
  }

  Future<void> _guardar() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'material': _materialController.text,
        'tipo_mesa': _tipoMesaController.text,
        'capacidad_personas': int.parse(_capacidadController.text),
        'imagenUrl': _imagenUrlController.text,
        'precio': double.parse(_precioController.text),  // nuevo
      };

      final ref = FirebaseFirestore.instance.collection('productos_comedor');
      if (widget.comedor == null) {
        await ref.add(data);
      } else {
        await ref.doc(widget.comedor!['id']).update(data);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.comedor == null ? 'Agregar Comedor' : 'Editar Comedor'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _materialController,
                decoration: const InputDecoration(labelText: 'Material'),
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _tipoMesaController,
                decoration: const InputDecoration(labelText: 'Tipo de Mesa'),
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _capacidadController,
                decoration: const InputDecoration(labelText: 'Capacidad de personas'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || int.tryParse(value) == null || int.parse(value) <= 0
                        ? 'Ingrese un número válido'
                        : null,
              ),
              TextFormField(
                controller: _precioController,  // nuevo
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Requerido';
                  final n = double.tryParse(value);
                  if (n == null || n <= 0) return 'Ingrese un precio válido';
                  return null;
                },
              ),
              TextFormField(
                controller: _imagenUrlController,
                decoration: const InputDecoration(labelText: 'URL de imagen (Drive)'),
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        ElevatedButton(onPressed: _guardar, child: const Text('Guardar')),
      ],
    );
  }
}
