import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/assistidos_page.dart';
import '../Pages/home_page.dart';
import '../Cadastro/routes.dart';
import '../Pages/tarefas_page.dart';
import '../Cadastro/pessoa.dart';
import '../Pages/poshome_page.dart';

main() => runApp(const MyApp());

class CadastroPage {
  final Pessoa usuario = Pessoa();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(scheme: FlexScheme.amber),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.amber),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
      routes: {
      Routes.PAGINA_DADOS: (context) => const TarefasPage(),
      Routes.PAGINA_ASSISTIDO:(context) => AssistidosPage(),
      Routes.PAGINA_POSHOME: (context) => const PosHomePage(),
      }
    );
  }
}
