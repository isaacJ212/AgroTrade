import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 64,
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 16),
            const Text(
              'Categorías de Productos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.TextMain,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Próximamente disponible para clientes.',
              style: TextStyle(
                color: AppColors.TextSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
