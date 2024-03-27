import 'package:flutter/material.dart';

class AnunciosPage extends StatelessWidget {
  const AnunciosPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 37, 37, 37),
      appBar: AppBar(
        title: const Text('Vidas em transformação'),
        backgroundColor: const Color.fromARGB(255, 1, 1, 1),
        centerTitle: true,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
         const SizedBox(height: 16),
          const Center(
          child: Text(
            "Olá, somos o Inaper",
            style: TextStyle(
              fontSize: 24,
              color: Color.fromARGB(255, 1, 175, 7),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Text('O Instituto de Apoio e Orientação a Pessoas em Situação de Rua – INAPER, surgiu, em 2016, com o objetivo de levar acolhimento à população carente e tende cerca de 65 pessoas por dia de funcionamento, com o envolvimento de voluntários e colaboradores comprometidos com a causa.',
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),),
        Image.asset(
          '../imagens/micao_inaper.png'
        )
        ],
      ),
    );
  }
}
