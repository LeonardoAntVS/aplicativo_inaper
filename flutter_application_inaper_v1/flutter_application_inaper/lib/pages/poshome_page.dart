import '../Pages/assistidos_page.dart';
import '../Pages/tarefas_page.dart';
import 'package:flutter/material.dart';

class PosHomePage extends StatelessWidget {
  const PosHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            centerTitle: false,
            bottom: const TabBar(tabs: [
              Tab(icon: Icon(Icons.people)),
              Tab(icon: Icon(Icons.work_history)),
            ]),
          ),
          body: TabBarView(
              children: [
              AssistidosPage(),
              Builder(builder: (context) => const TarefasPage(),)
              ],
          )),
    );
  }
}
