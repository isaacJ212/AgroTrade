import 'package:flutter/material.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/components.dart';
import '../../shared/profile.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  int _periodoSeleccionado = 1;

  final List<String> _periodos = ['Esta semana', 'Este mes', 'Últimos 3 meses'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          'Ventas',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(_periodos.length, (index) {
                  final bool seleccionado = _periodoSeleccionado == index;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index < _periodos.length - 1 ? 8 : 0,
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _periodoSeleccionado = index;
                          });
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          height: 42,
                          decoration: BoxDecoration(
                            color: seleccionado
                                ? AppColors.primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: seleccionado
                                  ? AppColors.primaryColor
                                  : const Color(0xFFD7DEDA),
                            ),
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            _periodos[index],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: seleccionado
                                  ? Colors.white
                                  : const Color(0xFF5D6762),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFF7F9F8), Color(0xFFE3F0E9)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE0E6E3)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 20,
                          color: Color(0xFF58635E),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Ingresos Totales',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF58635E),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    Text(
                      'C\$ 12,450.00',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),

                    SizedBox(height: 10),

                    Row(
                      children: [
                        Icon(
                          Icons.trending_up,
                          size: 18,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '+14.5% vs mes anterior',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              const Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      title: 'Pedidos',
                      value: '24',
                      description: 'Completados',
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: _SummaryCard(
                      title: 'Productos',
                      value: '186',
                      description: 'Unidades vendidas',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6F5),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE1E6E3)),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFFE1F2E7),
                      child: Icon(
                        Icons.receipt_long_outlined,
                        size: 22,
                        color: AppColors.primaryColor,
                      ),
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        'Ticket Promedio',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5E6963),
                        ),
                      ),
                    ),

                    Text(
                      'C\$ 518.75',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.TextMain,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFDEE4E1)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Rendimiento Diario',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: AppColors.TextMain,
                            ),
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Descargando comprobante...')));
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Ver reporte completo',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const SizedBox(height: 180, child: _DailyBarChart()),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Más vendidos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.TextMain,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFDEE4E1)),
                ),
                child: const Column(
                  children: [
                    _BestSellerItem(
                      position: '1',
                      product: 'Tomate',
                      sales: '64 libras vendidas',
                      first: true,
                    ),

                    Divider(height: 1, color: Color(0xFFE5E9E7)),

                    _BestSellerItem(
                      position: '2',
                      product: 'Naranja',
                      sales: '38 docenas vendidas',
                    ),

                    Divider(height: 1, color: Color(0xFFE5E9E7)),

                    _BestSellerItem(
                      position: '3',
                      product: 'Limón',
                      sales: '31 libras vendidas',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AgroBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 2) {
            return;
          }

          if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Profile()),
            );
          }
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String description;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E6E3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF68736D),
            ),
          ),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.TextMain,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            description,
            style: const TextStyle(fontSize: 10, color: Color(0xFF929A96)),
          ),
        ],
      ),
    );
  }
}

class _DailyBarChart extends StatelessWidget {
  const _DailyBarChart();

  @override
  Widget build(BuildContext context) {
    final List<double> values = [0.34, 0.48, 0.30, 0.64, 0.82, 0.54, 0.96];

    final List<String> days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

    return LayoutBuilder(
      builder: (context, constraints) {
        const double labelHeight = 26;

        final double chartHeight = constraints.maxHeight - labelHeight;

        return Column(
          children: [
            SizedBox(
              height: chartHeight,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return Container(
                        height: 1,
                        color: const Color(0xFFEEF1EF),
                      );
                    }),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(values.length, (index) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FractionallySizedBox(
                              heightFactor: values[index],
                              child: Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(3),
                                    topRight: Radius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: List.generate(days.length, (index) {
                final bool sunday = index == 6;

                return Expanded(
                  child: Text(
                    days[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: sunday ? FontWeight.w700 : FontWeight.w400,
                      color: sunday
                          ? AppColors.primaryColor
                          : const Color(0xFF929B96),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}

class _BestSellerItem extends StatelessWidget {
  final String position;
  final String product;
  final String sales;
  final bool first;

  const _BestSellerItem({
    required this.position,
    required this.product,
    required this.sales,
    this.first = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: first ? const Color(0xFFEAF5EE) : const Color(0xFFF0F2F1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              position,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: first ? AppColors.primaryColor : const Color(0xFF858F8A),
              ),
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.TextMain,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  sales,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF858F8A),
                  ),
                ),
              ],
            ),
          ),

          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Ver detalle',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
