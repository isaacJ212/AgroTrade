import 'package:flutter_test/flutter_test.dart';
import 'package:agrotrade_frontend/services/productor_api_service.dart';

void main() {
  test('normalizarCategorias no devuelve valores hardcodeados cuando la API viene vacía', () {
    final categorias = ProductorApiService.normalizarCategorias(const []);

    expect(categorias, isEmpty);
    expect(categorias, isNot(contains('Frutas')));
    expect(categorias, isNot(contains('Verduras')));
  });

  test('resolverCategoriaId devuelve el id real para una categoría existente', () {
    final id = ProductorApiService.resolverCategoriaId(
      [
        {'idCategoria': 1, 'nombre': 'Frutas'},
        {'idCategoria': 2, 'nombre': 'Verduras'},
        {'idCategoria': 3, 'nombre': 'Granos'},
      ],
      'Verduras',
    );

    expect(id, 2);
  });
}
