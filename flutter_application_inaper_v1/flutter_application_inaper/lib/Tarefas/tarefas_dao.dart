import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert'; 
import '../cadastro/tarefa.dart';
class TarefasDao {
  Future<File> _getFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return File('${directory.path}/data.json');
    } catch (e) {
      print('Erro ao obter o diretório de documentos: $e');
      rethrow; // Rethrow a exceção para que ela possa ser capturada pelo chamador
    }
  }
  
  Future<File> saveData(List<dynamic> list) async {
    final file = await _getFile();
    String data = json.encode(list);
    return file.writeAsString(data);
  }

  Future<String?> readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class TarefasPage extends StatefulWidget {
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

  late TarefasDao db;

  @override
  void initState() {
    super.initState();
    db = TarefasDao();
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
      setState(() {
        Map<String, dynamic> novaTarefa = {};
        novaTarefa['descricao'] = _tarefaController.text;
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
    final tarefa = ModalRoute.of(context)?.settings.arguments as Tarefa?;
    if (tarefa == null) {
      return const Scaffold(
        body: Center(
          child: Text('Tarefas não encontradas.'),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Tarefas a serem realizadas',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text(
            '${tarefa.nome}',
            style: const TextStyle(fontSize: 30, color: Colors.black),
          ),
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
                          style: const TextStyle(color: Colors.black)),
                      value: _listaTarefas[index]['ok'],
                      secondary: CircleAvatar(
                        foregroundColor: _listaTarefas[index]['ok']
                            ? Colors.orange
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
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: 'Entre com a tarefa',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}

