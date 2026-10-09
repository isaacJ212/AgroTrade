import 'package:flutter/material.dart';

import '../../ui/app_theme.dart';

class RecursosTecnicosScreen extends StatelessWidget {
  const RecursosTecnicosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.White,
        elevation: 0,
        title: const Text(
          'Recursos Técnicos MAG',
          style: AppTextStyles.Title,
        ),
        iconTheme: const IconThemeData(color: AppColors.TextMain),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primarySoftBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.primarySoft, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Material técnico y normativas del Ministerio Agropecuario de Nicaragua (MAG).',
                      style: AppTextStyles.SubTitle.copyWith(
                        color: AppColors.primarySoft,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Guías de Cultivo', style: AppTextStyles.Title),
            const SizedBox(height: 12),
            _buildRecursoCard(
              context,
              title: 'Manual de Buenas Prácticas Agrícolas',
              description: 'Lineamientos oficiales del MAG para garantizar la inocuidad y calidad en la producción primaria.',
              icon: Icons.book,
            ),
            _buildRecursoCard(
              context,
              title: 'Manejo de Plagas en Granos Básicos',
              description: 'Estrategias y normativas para el control de plagas en maíz y frijol.',
              icon: Icons.bug_report,
            ),
            const SizedBox(height: 24),
            const Text('Clima y Suelos', style: AppTextStyles.Title),
            const SizedBox(height: 12),
            _buildRecursoCard(
              context,
              title: 'Zonificación Agroecológica',
              description: 'Mapas e indicadores de zonas aptas para diferentes cultivos en el territorio nacional.',
              icon: Icons.map,
            ),
            _buildRecursoCard(
              context,
              title: 'Recomendaciones de Fertilizantes',
              description: 'Guía técnica para el uso adecuado de fertilizantes en diferentes tipos de suelo.',
              icon: Icons.grass,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecursoCard(BuildContext context, {required String title, required String description, required IconData icon}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryColor),
        ),
        title: Text(title, style: AppTextStyles.SubTitle.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            description,
            style: AppTextStyles.SubTitle.copyWith(fontSize: 12, color: AppColors.TextSoft),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.TextSoft),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Abriendo documento...')),
          );
        },
      ),
    );
  }
}
