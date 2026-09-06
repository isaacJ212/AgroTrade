import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../ui/widgets/productor_widgets.dart';

class AyudaProductor extends StatefulWidget {
  const AyudaProductor({super.key});
  @override
  State<AyudaProductor> createState() => _AyudaProductorState();
}

class _AyudaProductorState extends State<AyudaProductor> {
  String _busqueda = '';
  static const _preguntas = {
    '¿Cómo agrego un producto?':
        'En Inventario toca Agregar producto, completa sus datos y continúa al registro de cosecha. Guarda para actualizar la lista.',
    '¿Cómo preparo un pedido?':
        'Abre Pedidos, elige el pedido y confírmalo. Marca cada producto preparado y luego toca Marcar como listo.',
    '¿Cómo edito mi finca?':
        'En Perfil entra a Información de la finca. Los cambios se muestran también en tu perfil público.',
    '¿Cómo publico una oferta?':
        'Abre un producto con existencias y toca Crear oferta. La cantidad no puede superar el inventario disponible.',
  };
  Future<void> _copiar(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) mensajeProductor(context, 'Contacto copiado.');
  }

  @override
  Widget build(BuildContext context) {
    final items = _preguntas.entries.where(
      (e) => ('${e.key} ${e.value}').toLowerCase().contains(
        _busqueda.toLowerCase(),
      ),
    );
    return ProductorPage(
      title: 'Centro de ayuda',
      children: [
        const ProductorSection('¿Cómo podemos ayudarte hoy?'),
        TextField(
          onChanged: (v) => setState(() => _busqueda = v),
          decoration: const InputDecoration(
            hintText: 'Buscar ayuda, problemas, etc.',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 20),
        const ProductorSection('Preguntas frecuentes'),
        if (items.isEmpty)
          const ProductorEmpty('No encontramos preguntas con ese texto.'),
        for (final item in items)
          ProductorCard(
            padding: EdgeInsets.zero,
            child: ExpansionTile(
              key: ValueKey(item.key),
              title: Text(item.key),
              childrenPadding: const EdgeInsets.all(16),
              children: [Text(item.value)],
            ),
          ),
        const ProductorSection('Contacto'),
        ProductorCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              ProductorMenuItem(
                label: 'Soporte por correo',
                subtitle: 'contacto@agrotrade.com · Copiar',
                icon: Icons.mail_outline,
                onTap: () => _copiar('contacto@agrotrade.com'),
              ),
              const Divider(height: 1),
              ProductorMenuItem(
                label: 'Llamada telefónica',
                subtitle: '+505 2234-5678 · Copiar',
                icon: Icons.phone_outlined,
                onTap: () => _copiar('+505 2234-5678'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
