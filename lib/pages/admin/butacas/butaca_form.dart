import 'package:flutter/material.dart';

class ButacaForm extends StatefulWidget {
  final Map<String, dynamic>? butaca;

  const ButacaForm({super.key, this.butaca});

  @override
  State<ButacaForm> createState() => _ButacaFormState();
}

class _ButacaFormState extends State<ButacaForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _materialController;
  late TextEditingController _disenoController;
  late TextEditingController _imagenUrlController;
  late TextEditingController _precioController;
  bool capacidadGirat = false;

  @override
  void initState() {
    super.initState();
    _materialController = TextEditingController(text: widget.butaca?['material'] ?? '');
    _disenoController = TextEditingController(text: widget.butaca?['diseno'] ?? '');
    _imagenUrlController = TextEditingController(text: widget.butaca?['imagenUrl'] ?? '');
    _precioController = TextEditingController(
      text: widget.butaca?['precio']?.toString() ?? '',
    );
    capacidadGirat = widget.butaca?['capacidad_giratoria'] ?? false;
  }

  @override
  void dispose() {
    _materialController.dispose();
    _disenoController.dispose();
    _imagenUrlController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.butaca == null ? 'Agregar Butaca' : 'Editar Butaca'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _materialController,
                decoration: const InputDecoration(labelText: 'Material'),
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _disenoController,
                decoration: const InputDecoration(labelText: 'Diseño'),
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              SwitchListTile(
                title: const Text('Capacidad giratoria'),
                value: capacidadGirat,
                onChanged: (val) => setState(() => capacidadGirat = val),
              ),
              TextFormField(
                controller: _imagenUrlController,
                decoration: const InputDecoration(labelText: 'URL Imagen (Google Drive)'),
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _precioController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Campo requerido';
                  final parsed = double.tryParse(value);
                  if (parsed == null || parsed <= 0) return 'Ingrese un precio válido';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text('Guardar'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop({
                'material': _materialController.text.trim(),
                'diseno': _disenoController.text.trim(),
                'capacidad_giratoria': capacidadGirat,
                'imagenUrl': _imagenUrlController.text.trim(),
                'precio': double.parse(_precioController.text.trim()),
              });
            }
          },
        ),
      ],
    );
  }
}
