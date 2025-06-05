import '../../models/producto_model.dart';

class CarritoService {
  static final CarritoService _instance = CarritoService._internal();
  factory CarritoService() => _instance;
  CarritoService._internal();

  final List<Producto> _productosEnCarrito = [];

  List<Producto> get productos => _productosEnCarrito;

  void agregarProducto(Producto producto) {
    _productosEnCarrito.add(producto);
  }

  void eliminarProducto(String id) {
    _productosEnCarrito.removeWhere((producto) => producto.id == id);
  }

  void vaciarCarrito() {
    _productosEnCarrito.clear();
  }
}