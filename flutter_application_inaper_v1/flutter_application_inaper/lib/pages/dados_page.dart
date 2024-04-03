import 'package:flutter/material.dart';
import '../Cadastro/pessoa.dart';
import '../Cadastro/validation.dart';
import '../Cadastro/routes.dart';

class DadosPage extends StatefulWidget {
  const DadosPage({super.key});

  @override
  State<DadosPage> createState() => _DadosPageState();
}

class _DadosPageState extends State<DadosPage> {
  final _senhaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final Validation validar = Validation();

  final Pessoa usuario = Pessoa();

  @override
  Widget build(BuildContext context) {
    bool passwordObscured = true;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          title: const Text('Acesso colaborador'),
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
                      labelStyle: TextStyle(color: Colors.black),
                      hintStyle: TextStyle(color: Colors.black54),
                      labelText: 'E-mail',
                      hintText: 'Entre com seu e-mail',
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                    ),
                    style: const TextStyle(color: Colors.black), // Texto preto
                    onSaved: (String? value) {
                      usuario.email = value;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    validator: (email) => validar.campoEmail(email.toString()),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      hintStyle: TextStyle(color: Colors.black54),
                      labelText: 'Senha',
                      hintText: 'Entre com sua senha',
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                    ),
                    controller: _senhaController,
                    style: const TextStyle(color: Colors.black), // Texto preto
                    onSaved: (String? value) {
                      usuario.senha = value;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    obscureText: passwordObscured,

                    validator: (senha) => validar.campoSenha(senha.toString()),
                    onFieldSubmitted: (value) {
                      _onSubmit(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        _onSubmit(context);
                      },
                      child: const Text('Acessar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _onSubmit(inContext) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(inContext).pushNamed(
        Routes.PAGINA_POSHOME,
        arguments: usuario,
      );
    } else {
      showDialog(
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
