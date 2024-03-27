import 'package:flutter/material.dart';
import '../cadastro/pessoa.dart';
import '../cadastro/validation.dart';
import '../cadastro/routes.dart';

class DadosPage extends StatefulWidget {
  DadosPage({super.key});

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
        backgroundColor: Color.fromARGB(255, 37, 37, 37),
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
                      labelText: 'Nome',
                      hintText: 'Entre com seu nome',
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                    onSaved: (String? value) {
                      usuario.nome = value;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    validator: (nome) => validar.campoNome(nome.toString()),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Sobrenome',
                      hintText: 'Entre com seu sobrenome',
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                    onSaved: (String? value) {
                      usuario.sobrenome = value;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    validator: (sobrenome) =>
                        validar.campoSobreNome(sobrenome.toString()),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      hintText: 'Entre com seu e-mail',
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
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
                      labelText: 'Senha',
                      hintText: 'Entre com sua senha',
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                    controller: _senhaController,
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
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Confirmar Senha',
                      hintText: 'Confirme sua senha',
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                    onSaved: (String? value) {
                      usuario.confSena = value;
                    },
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    validator: (confSenha) => validar.confirmaSenha(
                        confSenha.toString(), _senhaController.text),
                    onFieldSubmitted: (value) {
                      _onSubmit(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      child: Text('Acessar'),
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
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(inContext).pushNamed(
        Routes.PAGINA_ASSISTIDO,
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
