class Producto {
  final String id;
  final String nombre;
  final num precio;
  final int existencia;
  final String fechaRegistro;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.existencia,
    required this.fechaRegistro,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      precio: json['precio'],
      existencia: json['existencia'],
      fechaRegistro: json['fechaRegistro'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'existencia': existencia,
      'fechaRegistro': fechaRegistro,
    };
  }
}