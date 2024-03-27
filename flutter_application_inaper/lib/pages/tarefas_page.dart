import 'package:flutter/material.dart';
import 'dart:convert';
import '../tarefas/tarefas_dao.dart';
import '../cadastro/pessoa.dart';
import '../tarefas/datetime.dart';

class TarefasPage extends StatefulWidget {
  TarefasPage({super.key});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  Map<String, dynamic>? _ultimoItemRemovido;
  int? _posicaoUltimoItemRemovido;
  Time t = Time();
  final _tarefaController = TextEditingController();
  final fieldNome = TextEditingController();

  List _listaTarefas = [];

  TarefasDao db = TarefasDao();

  @override
  void initState() {
    super.initState();
    db.readData().then(
      (data) {
        setState(() {
          _listaTarefas = json.decode(data!);
        });
      },
    );
  }

  void _onSubmit(context, texto) {
    final pessoa = ModalRoute.of(context)!.settings.arguments as Pessoa;
    if (texto.toString().isNotEmpty) {
      setState(() {
        Map<String, dynamic> novaTarefa = {};
        novaTarefa['descricao'] = _tarefaController.text;
        novaTarefa['DataHora'] = t.getdatetime();
        novaTarefa['Pessoa'] = pessoa.assistido;
        _tarefaController.clear();
        novaTarefa['ok'] = false;

        _listaTarefas.add(novaTarefa);
        db.saveData(_listaTarefas);
      });
      print('Tarefa adicionada!!!!');
    } else {
      print('Sem Tarefa preenchida');
    }
  }

  Future<void> _atualiza() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _listaTarefas.sort((a, b) {
        return (a['ok'].toString()).compareTo(b['ok'].toString());
      });
      db.saveData(_listaTarefas);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
        appBar: AppBar(
            title: const Text('Tarefas a serem realizadas'), centerTitle: true),
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
                              '${_listaTarefas[index]['descricao']} - ${_listaTarefas[index]['DataHora']} - ${_listaTarefas[index]['Pessoa']}'),
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
                          _ultimoItemRemovido = Map.from(_listaTarefas[index]);
                          _posicaoUltimoItemRemovido = index;
                          _listaTarefas.removeAt(index);
                          db.saveData(_listaTarefas);
                          print('Direção: $direcao');
                          if (direcao == DismissDirection.startToEnd) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text(
                                  '${_ultimoItemRemovido!['descricao']} removido(a).',
                                  style: TextStyle(color: Colors.black),
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
                            print('Direção: Início para o Fim');
                          }
                          if (direcao == DismissDirection.endToStart) {
                            print('Direção: $direcao');
                            setState(() {
                              _listaTarefas.insert(_posicaoUltimoItemRemovido!,
                                  _ultimoItemRemovido);
                              _listaTarefas[index]['ok'] =
                                  !_listaTarefas[index]['ok'];
                              db.saveData(_listaTarefas);
                            });
                          }
                        });
                  },
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Form(
                  child: TextFormField(
                controller: _tarefaController,
                onFieldSubmitted: (texto) {
                  _onSubmit(context, texto);
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Tarefa',
                  hintText: 'Entre com a tarefa',
                  border: OutlineInputBorder(borderSide: BorderSide()),
                ),
              )),
            )
          ],
        ));
  }
}
