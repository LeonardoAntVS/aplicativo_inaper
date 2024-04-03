import 'package:flutter/material.dart';
import '../Cadastro/pessoa.dart';
import '../Cadastro/validation.dart';
import '../Cadastro/routes.dart';
import '../Tarefas/datetime.dart';

Time t = Time();

class AssistidosPage extends StatefulWidget {
  AssistidosPage({super.key});

  @override
  State<AssistidosPage> createState() => _AssistidosPageState();
}

class _AssistidosPageState extends State<AssistidosPage> {

  final _formKey = GlobalKey<FormState>();

  final Validation validar = Validation();

  final Pessoa usuario = Pessoa();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 37, 37, 37),
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
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      hintText: 'Entre com o nome',
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                    onSaved: (String? value) {
                      usuario.assistido = value;
                    },
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    validator: (nome) => validar.campoNome(nome.toString()),
                  ),
                  const SizedBox(height: 10),
                  Text('Dia: ${t.day}/${t.month}/${t.year} Hora: ${t.hora}:${t.getminuto()}'),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      child: Text('Cadastrar'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        _onSubmit(context);
                      },
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
              title: Text('Dados Inválidos!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(inContext);
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(inContext);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}