import 'package:flutter/material.dart';
import '../cadastro/pessoa.dart';
import '../cadastro/validation.dart';
import '../cadastro/routes.dart';

class AssistidosPage extends StatefulWidget {
  const AssistidosPage({super.key});

  @override
  State<AssistidosPage> createState() => _AssistidosPageState();
}

class _AssistidosPageState extends State<AssistidosPage> {

  final _formKey = GlobalKey<FormState>();

  final Validation validar = Validation();

  final Pessoa usuario = Pessoa();

  final day = DateTime.now().day;
  final month = DateTime.now().month;
  final year = DateTime.now().year;
  final hora = DateTime.now().hour;
  final minuto = DateTime.now().minute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          title: const Text('Acompanhamento ao Assistido'),
          backgroundColor: const Color.fromARGB(255, 1, 1, 1),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox( height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      hintStyle: TextStyle(color: Colors.black54),
                      labelText: 'Nome',
                      hintText: 'Entre com o nome',
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                    style: const TextStyle(color: Colors.black),
                    onSaved: (String? value) {
                      usuario.assistido = value;
                    },
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    validator: (nome) => validar.campoNome(nome.toString()),
                  ),
                  const SizedBox(height: 10),
                  Text('Dia: $day/$month/$year Hora: $hora:$minuto'),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          textStyle: const TextStyle(
                              color: Colors.orange,
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        _onSubmit(context);
                      },
                      child: const Text('Cadastrar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _onSubmit(inContext) {
    if (_formKey.currentState!.validate()) { // Formulário validado
      _formKey.currentState!.save();
      Navigator.of(inContext).pushNamed(
        Routes.PAGINA_DADOS,
        arguments: usuario,
      );
    } else {
      showDialog( // Formulário com erro
        context: inContext,
        barrierDismissible: false,
        builder: (inContext) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: const Text('Dados Inválidos!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(inContext);
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(inContext);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
