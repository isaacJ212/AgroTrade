import 'package:flutter/material.dart';
import '../ui/app_theme.dart';
import '../ui/components.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _controller = PageController();
  int _pagina = 0;

  final List<Map<String, String>> _paginas = [
    {
      "titulo": "Bienvenido a AgroTrade",
      "texto":
          "Conectamos productores, compradores y repartidores en un solo lugar.",
    },
    {
      "titulo": "Compra y vende directo",
      "texto":
          "Publica tus productos o encuentra lo mejor del campo sin intermediarios.",
    },
    {
      "titulo": "Entrega garantizada",
      "texto": "Repartidores conectados para que cada pedido llegue a tiempo.",
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _irLogin() {
    //Navigator.pushReplacement(context, Builder(builder: (_)=> const Login()));
  }

  void siguiente() {
    if (_pagina < _paginas.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      //_irLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _esUltima = _pagina == _paginas.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _irLogin,
                child: const Text(
                  "Omitir",
                  style: TextStyle(color: AppColors.TextSoft),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _paginas.length,
                onPageChanged: (i) => setState(() => _pagina = i),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Logo(size: 250),
                        const SizedBox(height: 32),
                        Text(
                          _paginas[index]["titulo"]!,
                          style: AppTextStyles.Title,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _paginas[index]["texto"]!,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.SubTitle,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _paginas.length,
                (i) => Dot(activo: i == _pagina),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryButton(
                label: _esUltima ? "Comenzar" : "Siguiente",
                radius: 100,
                onPressed: siguiente,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
