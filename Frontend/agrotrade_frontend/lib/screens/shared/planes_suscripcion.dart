import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../routes/app_routes.dart';
import '../../services/subscription_api_service.dart';
import 'pago_suscripcion.dart';

class PlanesSuscripcionScreen extends StatefulWidget {
  const PlanesSuscripcionScreen({super.key});

  @override
  State<PlanesSuscripcionScreen> createState() => _PlanesSuscripcionScreenState();
}

class _PlanesSuscripcionScreenState extends State<PlanesSuscripcionScreen> {
  List<Map<String, dynamic>> _planes = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPlanes();
  }

  Future<void> _loadPlanes() async {
    try {
      final planesData = await SubscriptionApiService.instance.fetchPlanes();
      setState(() {
        _planes = planesData.where((p) {
          final estado = p['estado'];
          if (estado is bool) return estado == true;
          final estadoStr = (estado ?? '').toString().toLowerCase();
          return estadoStr == 'activo' || estadoStr == 'activa' || estadoStr == 'true' || estadoStr == '1';
        }).map((p) {
          return {
            'id': p['idTipoPlan'] ?? p['id'] ?? 0,
            'nombre': p['nombrePlan'] ?? 'Plan',
            'precio': (p['precio'] ?? 0).toDouble(),
            'descripcion': p['descripcion'] ?? '',
            'caracteristicas': p['beneficios'] != null
                ? p['beneficios'].toString().split(',').map((e) => e.trim()).toList()
                : [],
            'color': _getColorForPlan(p['nombrePlan'] ?? ''),
          };
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los planes: $e';
        _isLoading = false;
      });
    }
  }

  Color _getColorForPlan(String name) {
    name = name.toLowerCase();
    if (name.contains('básico') || name.contains('basico')) return Colors.blueGrey;
    if (name.contains('premium')) return AppColors.primaryColor;
    if (name.contains('elite')) return Colors.orange.shade700;
    return AppColors.primaryColor;
  }

  void _suscribirse(Map<String, dynamic> plan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PagoSuscripcionScreen(plan: plan),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.titleDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Planes de Suscripción',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _loadPlanes();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }
    if (_planes.isEmpty) {
      return const Center(child: Text('No hay planes disponibles en este momento.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _planes.length,
      itemBuilder: (context, index) {
        final plan = _planes[index];
        return _buildPlanCard(plan);
      },
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    final Color planColor = plan['color'] ?? AppColors.primaryColor;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: planColor.withOpacity(0.3), width: 1),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  plan['nombre'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: planColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: planColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '\$${plan['precio']}/mes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: planColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              plan['descripcion'],
              style: const TextStyle(color: AppColors.TextSoft, fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'Incluye:',
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.titleDark),
            ),
            const SizedBox(height: 8),
            if (plan['caracteristicas'] != null)
              ...List.generate((plan['caracteristicas'] as List).length, (i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 16, color: planColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          plan['caracteristicas'][i], 
                          style: const TextStyle(fontSize: 14)
                        ),
                      ),
                    ],
                  ),
                );
              }),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: planColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _suscribirse(plan),
                child: const Text('Suscribirse ahora', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
