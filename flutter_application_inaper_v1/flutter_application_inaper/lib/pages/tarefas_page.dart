import 'package:flutter/material.dart';
import 'dart:convert';
import '../Tarefas/tarefas_dao.dart';
import '../cadastro/tarefa.dart';

class TarefasPage extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const TarefasPage({Key? key});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  Map<String, dynamic>? _ultimoItemRemovido;
  int? _posicaoUltimoItemRemovido;
  final _tarefaController = TextEditingController();
  final fieldNome = TextEditingController();

  List _listaTarefas = [];

  TarefasDao db = TarefasDao();

  @override
  void initState() {
    super.initState();
    // A chamada para readData() foi removida do initState()
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Chamando readData() aqui, após as dependências estarem completamente inicializadas
    db.readData().then(
      (data) {
        setState(() {
          if (data != null) {
            _listaTarefas = json.decode(data);
          } else {
            _listaTarefas = [];
          }
        });
      },
    );
  }

  void _onSubmit(context, texto) {
    if (texto.toString().isNotEmpty) {
      Map<String, dynamic> novaTarefa = {};
      novaTarefa['descricao'] = _tarefaController.text;
      _tarefaController.clear();
      novaTarefa['ok'] = false;

      setState(() {
        _listaTarefas.add(novaTarefa);
      });

      db.saveData(_listaTarefas); // Salva os dados fora do setState
      // ignore: avoid_print
      print('Tarefa adicionada!!!!');
    } else {
      // ignore: avoid_print
      print('Sem Tarefa preenchida');
    }
  }

  Future<void> _atualiza() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _listaTarefas.sort((a, b) {
        return (a['ok'].toString()).compareTo(b['ok'].toString());
      });
      db.saveData(_listaTarefas);
    });
  }

  @override
  Widget build(BuildContext context) {
//    final tarefa = ModalRoute.of(context)?.settings.arguments as Tarefa?;
//   if (tarefa == null) {
//      return const Scaffold(
//        backgroundColor: Colors.green, // Define o fundo como branco
//        body: Center(
//          child: Text('Tarefa não encontrada.'),
//        ),
//      );
//    }
    return Scaffold(
      backgroundColor: Colors.white, // Define o fundo como branco
      appBar: AppBar(
        backgroundColor: Colors.black, // Define a cor verde para o topo da página
        title: const Text('Tarefas a serem realizadas', style: TextStyle(color: Colors.white)), // Define a cor preta para o título
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _atualiza,
              child: ListView.builder(
                itemCount: _listaTarefas.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(
                        DateTime.now().millisecondsSinceEpoch.toString()),
                    background: Container(
                      color: Colors.red,
                      child: const Align(
                        alignment: Alignment(-0.9, 0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.green,
                      child: const Align(
                        alignment: Alignment(0.9, 0),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    child: CheckboxListTile(
                      title: Text(
                          '${_listaTarefas[index]['descricao']}',
                          style: const TextStyle(color: Colors.black)), // Define a cor preta para o texto
                      value: _listaTarefas[index]['ok'],
                      secondary: CircleAvatar(
                        foregroundColor: _listaTarefas[index]['ok']
                            ? Colors.green
                            : Colors.red,
                        child: Icon(_listaTarefas[index]['ok']
                            ? Icons.check
                            : Icons.close),
                      ),
                      onChanged: (checked) {
                        setState(() {
                          _listaTarefas[index]['ok'] = checked;
                          db.saveData(_listaTarefas);
                        });
                      },
                    ),
                    onDismissed: (direcao) {
                      _ultimoItemRemovido =
                          Map.from(_listaTarefas[index]);
                      _posicaoUltimoItemRemovido = index;
                      _listaTarefas.removeAt(index);
                      db.saveData(_listaTarefas);
                      // ignore: avoid_print
                      print('Direção: $direcao');
                      if (direcao == DismissDirection.startToEnd) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 2),
                            content: Text(
                              '${_ultimoItemRemovido!['descricao']} removido(a).',
                              style: const TextStyle(color: Colors.black),
                            ),
                                                        action: SnackBarAction(
                              label: 'Desfazer',
                              textColor: Colors.black,
                              onPressed: () {
                                setState(() {
                                  _listaTarefas.insert(
                                      _posicaoUltimoItemRemovido!,
                                      _ultimoItemRemovido);
                                  db.saveData(_listaTarefas);
                                });
                              },
                            ),
                          ),
                        );
                        // ignore: avoid_print
                        print('Direção: Início para o Fim');
                      }
                      if (direcao == DismissDirection.endToStart) {
                        // ignore: avoid_print
                        print('Direção: $direcao');
                        setState(() {
                          _listaTarefas.insert(_posicaoUltimoItemRemovido!,
                              _ultimoItemRemovido);
                          _listaTarefas[index]['ok'] =
                              !_listaTarefas[index]['ok'];
                          db.saveData(_listaTarefas);
                        });
                      }
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Form(
              child: TextFormField(
                controller: _tarefaController,
                onFieldSubmitted: (texto) {
                  _onSubmit(context, texto);
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Tarefa',
                  labelStyle: TextStyle(color: Colors.black), // Alterado para preto
                  hintText: 'Entre com a tarefa',
                  hintStyle: TextStyle(color: Colors.grey), // Alterado para preto
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)), // Alterado para preto
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
