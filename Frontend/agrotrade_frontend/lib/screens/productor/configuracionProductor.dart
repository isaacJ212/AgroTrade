import 'package:flutter/material.dart';
import '../../services/productor_store.dart';
import '../../ui/widgets/productor_widgets.dart';

class ConfiguracionProductor extends StatelessWidget {
  const ConfiguracionProductor({super.key});
  @override
  Widget build(BuildContext context) {
    final store = ProductorStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => ProductorPage(
        title: 'Configuración',
        children: [
          ProductorCard(
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Notificaciones'),
                  subtitle: const Text(
                    'Mostrar avisos de pedidos dentro de la aplicación.',
                  ),
                  value: store.notificaciones,
                  onChanged: store.configurarNotificaciones,
                ),
                const Divider(),
                const SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Modo oscuro'),
                  subtitle: Text('El diseño actual utiliza el tema claro.'),
                  value: false,
                  onChanged: null,
                ),
                const Divider(),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.language),
                  title: Text('Idioma'),
                  trailing: Text('Español'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
