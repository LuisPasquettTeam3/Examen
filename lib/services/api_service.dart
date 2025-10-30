import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';

class ApiService {
  static const String baseUrl = 'http://miapiunach.somee.com';

  // Método para probar conectividad básica
  Future<bool> testConnection() async {
    try {
      final response = await http.get(Uri.parse(baseUrl)).timeout(const Duration(seconds: 10));
      print('Test connection - Status: ${response.statusCode}');
      return response.statusCode < 400;
    } catch (e) {
      print('Test connection failed: $e');
      return false;
    }
  }

  // GET /api/Productos - Obtener lista de todos los productos
  Future<List<Producto>> getProductos() async {
    print('Llamando a: $baseUrl/api/Productos');
    final response = await http.get(
      Uri.parse('$baseUrl/api/Productos'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Producto.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos: ${response.statusCode} - ${response.body}');
    }
  }

  // GET /api/Productos/buscar/{nombre} - Buscar productos por nombre
  Future<List<Producto>> buscarProductos(String nombre) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Productos/buscar/$nombre'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Producto.fromJson(json)).toList();
    } else {
      throw Exception('Error al buscar productos');
    }
  }

  // GET /api/Productos/{id} - Buscar producto por ID (usando el endpoint existente)
  Future<List<Producto>> buscarProductosPorId(String id) async {
    try {
      final producto = await getProducto(id);
      return [producto]; // Retornar como lista con un elemento
    } catch (e) {
      throw Exception('Error al buscar producto por ID: $e');
    }
  }

  // GET /api/Productos/{id} - Obtener detalles de un producto por ID
  Future<Producto> getProducto(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Productos/$id'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Producto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al cargar producto');
    }
  }

  // DELETE /api/Productos/{id} - Eliminar un producto por ID
  Future<void> deleteProducto(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/Productos/$id'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar producto');
    }
  }

  // POST /api/Productos - Crear un nuevo producto
  Future<Producto> crearProducto(Producto producto) async {
    // Crear un mapa sin el ID ya que el servidor lo genera
    final productoData = {
      'nombre': producto.nombre,
      'precio': producto.precio,
      'existencia': producto.existencia,
      'fechaRegistro': producto.fechaRegistro,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/Productos'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(productoData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Producto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear producto: ${response.statusCode} - ${response.body}');
    }
  }

  // PUT /api/Productos/{id} - Actualizar un producto existente
  Future<Producto> actualizarProducto(String id, Producto producto) async {
    final productoData = {
      'id': id,
      'nombre': producto.nombre,
      'precio': producto.precio,
      'existencia': producto.existencia,
      'fechaRegistro': producto.fechaRegistro,
    };

    final response = await http.put(
      Uri.parse('$baseUrl/api/Productos/$id'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(productoData),
    );

    if (response.statusCode == 200) {
      return Producto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar producto: ${response.statusCode} - ${response.body}');
    }
  }
}