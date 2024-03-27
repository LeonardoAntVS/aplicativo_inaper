import 'package:flutter/material.dart';
import '../Pages/anuncios_page.dart';
import '../Pages/dados_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Inaper'),
            backgroundColor: Colors.green,
            centerTitle: false,
            bottom: const TabBar(tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.work)),
            ]),
          ),
          body: TabBarView(
              children: [
               const AnunciosPage(),
              Builder(builder: (context) => const DadosPage(),)
              ],
          )),
    );
  }
}
