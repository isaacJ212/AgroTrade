import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/widgets/repartidor_widgets.dart';

class CentroAyudaRepartidor extends StatefulWidget {
  const CentroAyudaRepartidor({super.key});

  @override
  State<CentroAyudaRepartidor> createState() => _CentroAyudaRepartidorState();
}

class _CentroAyudaRepartidorState extends State<CentroAyudaRepartidor> {
  String _busqueda = '';

  static const _preguntas = [
    {
      'titulo': '¿Cómo acepto una entrega?',
      'respuesta': 'Abre una entrega pendiente desde Inicio o Entregas. '
          'Revisa la recogida, el destino y los productos; después pulsa '
          'Aceptar entrega. Debes estar disponible para aceptar entregas.',
    },
    {
      'titulo': '¿Cómo confirmo la recogida?',
      'respuesta': 'Revisa los productos del pedido y marca cada uno cuando '
          'lo hayas verificado. Después pulsa Confirmar recogida para '
          'continuar hacia el destino.',
    },
    {
      'titulo': '¿Cómo finalizo una entrega?',
      'respuesta': 'Abre tu entrega en curso, pulsa Llegué al destino y '
          'confirma la entrega. Puedes añadir una nota antes de confirmar.',
    },
  ];

  String _normalizar(String texto) => texto.toLowerCase()
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u')
      .trim();

  @override
  Widget build(BuildContext context) {
    final consulta = _normalizar(_busqueda);
    final preguntas = _preguntas.where((pregunta) =>
      _normalizar('${pregunta['titulo']} ${pregunta['respuesta']}')
          .contains(consulta)).toList();

    return RepartidorScaffold(
      titulo: 'Centro de Ayuda',
      volver: true,
      fondo: AppColors.screenBg,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '¿Cómo podemos ayudarte hoy?',
            style: RepartidorTextStyles.sectionTitle.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 20),
          TextField(
            style: RepartidorTextStyles.menu,
            onChanged: (valor) => setState(() => _busqueda = valor),
            decoration: InputDecoration(
              hintText: 'Buscar ayuda, problemas, etc.',
              prefixIcon: const Icon(Icons.search, color: AppColors.TextSoft),
              filled: true,
              fillColor: AppColors.White,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Preguntas Frecuentes',
            style: RepartidorTextStyles.sectionTitle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (preguntas.isEmpty)
            const RepartidorCard(
              child: Text(
                'No encontramos resultados para tu búsqueda.',
                style: RepartidorTextStyles.SubTitle,
              ),
            ),
          for (final pregunta in preguntas)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: RepartidorCard(
                padding: EdgeInsets.zero,
                child: ExpansionTile(
                  key: ValueKey(pregunta['titulo']),
                  title: Text(
                    pregunta['titulo']!,
                    style: RepartidorTextStyles.menu,
                  ),
                  shape: const Border(),
                  collapsedShape: const Border(),
                  iconColor: AppColors.primaryColor,
                  collapsedIconColor: AppColors.primaryColor,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        pregunta['respuesta']!,
                        style: RepartidorTextStyles.SubTitle.copyWith(height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 20),
          Text(
            'Contacto',
            style: RepartidorTextStyles.sectionTitle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          RepartidorCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: const [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primarySoftBg,
                    child: Icon(Icons.email_outlined,
                      color: AppColors.primaryColor),
                  ),
                  title: Text('Soporte por Correo',
                    style: RepartidorTextStyles.menu),
                  subtitle: SelectableText('contacto@agrotrade.com',
                    style: RepartidorTextStyles.SubTitle),
                ),
                Divider(height: 1, indent: 70, color: AppColors.cardBorder),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primarySoftBg,
                    child: Icon(Icons.phone_outlined,
                      color: AppColors.primaryColor),
                  ),
                  title: Text('Llamada Telefónica',
                    style: RepartidorTextStyles.menu),
                  subtitle: SelectableText('+505 2234-5678',
                    style: RepartidorTextStyles.SubTitle),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
