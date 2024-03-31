import 'package:flutter/material.dart';
import 'package:lista_de_compras/models/item_model.dart';
import 'package:lista_de_compras/models/lista_model.dart';
import 'package:lista_de_compras/repositories/listas_repository.dart';

class ListaItensView extends StatefulWidget {
  final ListaModel lis;
  final String lbl;
  final int indice;
  const ListaItensView({
    super.key,
    required this.lis,
    required this.lbl,
    required this.indice,
  });

  @override
  State<ListaItensView> createState() => _ListaItensViewState();
}

class _ListaItensViewState extends State<ListaItensView> {
  var formItemKey = GlobalKey<FormState>();
  TextEditingController titulo = TextEditingController();
  TextEditingController descricao = TextEditingController();
  TextEditingController quantidade = TextEditingController();
  final repositorio = ListasRespository();
  final List<Color> cor = [
    Colors.green,
    Colors.blue,
    Colors.pink,
  ];

  List<ItemModel> selecionados = [];
  List<ItemModel> lista = [];
  @override
  void initState() {
    lista = widget.lis.itens;
    super.initState();
  }

  AppBar appBarDinamica() {
    if (selecionados.isEmpty) {
      return AppBar(
        elevation: 1,
        title: Text(widget.lbl),
        centerTitle: true,
        backgroundColor: cor[widget.lis.tema],
      );
    } else {
      return AppBar(
        elevation: 1,
        title: selecionados.length == 1
            ? Text('${selecionados.length} ITEM SELECIONADO')
            : Text('${selecionados.length} ITENS SELECIONADOS'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            setState(() {
              selecionados = [];
            });
          },
          icon: const Icon(Icons.close),
        ),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      );
    }
  }

  int indiceItem = 0;
  @override
  Widget build(BuildContext context) {
    int i = widget.indice;
    debugPrint('valor de i $i');

    return SafeArea(
      child: Scaffold(
        appBar: appBarDinamica(),
        body: lista.isEmpty
            ? Center(child: Text('Adicone Itens a sua lista ${widget.lbl}'))
            : ListView.builder(
                itemCount: lista.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: Colors.white,
                    surfaceTintColor: cor[widget.lis.tema],
                    child: ListTile(
                      onLongPress: () {
                        if (selecionados.length == 1) {
                          indiceItem = index;
                        }

                        setState(() {
                          (selecionados.contains(lista[index]))
                              ? selecionados.remove(lista[index])
                              : selecionados.add(lista[index]);
                        });
                      },
                      selected: selecionados.contains(lista[index]),
                      selectedTileColor: Colors.orange,
                      selectedColor: Colors.white,
                      title: Text(lista[index].nmItem),
                      subtitle: Text(
                        lista[index].descricao,
                        overflow: lista[index].descricao.length > 30
                            ? TextOverflow.ellipsis
                            : null,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: cor[widget.lis.tema].withAlpha(180),
                        child: Text(
                          '${lista[index].quantidade}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      trailing: Checkbox(
                        activeColor: cor[widget.lis.tema],
                        value: lista[index].isCheck,
                        onChanged: (bool? novoValor) {
                          setState(() {
                            lista[index].isCheck = !lista[index].isCheck;
                          });

                          repositorio.editarItem(
                              widget.indice, index, lista[index]);
                        },
                      ),
                    ),
                  );
                },
              ),
        floatingActionButtonLocation: selecionados.isEmpty
            ? FloatingActionButtonLocation.endFloat
            : FloatingActionButtonLocation.centerFloat,
        floatingActionButton: selecionados.isEmpty
            ? FloatingActionButton.extended(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return addItem(widget.indice, indiceItem, 0);
                      });
                },
                label: const Text(
                  'Add Item',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: cor[widget.lis.tema],
              )
            : FloatingActionButton.extended(
                onPressed: () {
                  if (selecionados.length == 1) {
                    titulo.text = selecionados[0].nmItem;
                    descricao.text = selecionados[0].descricao;
                    quantidade.text = selecionados[0].quantidade.toString();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return addItem(widget.indice, indiceItem, 1);
                        });
                  } else {}
                },
                label: Text(
                  selecionados.length == 1 ? 'Editar' : 'Excluir',
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                ),
                icon: Icon(
                  selecionados.length == 1
                      ? Icons.edit_document
                      : Icons.delete_forever,
                  size: 30,
                  color: Colors.white,
                ),
                backgroundColor: Colors.orange,
              ),
      ),
    );
  }

  AlertDialog addItem(int indiceLista, int indiceItem, int op) {
    return AlertDialog(
      elevation: 0,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Text(
        'Adiconar Item a ${widget.lbl}',
        textAlign: TextAlign.center,
      ),
      content: Form(
          key: formItemKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              campoTexto(titulo, 'Nome Item', true, null, false),
              const SizedBox(height: 15),
              campoTexto(descricao, 'Descrição', false, 5, false),
              const SizedBox(height: 15),
              campoTexto(quantidade, 'Quantidade', false, null, true),
            ],
          )),
      actions: [
        TextButton(
          onPressed: () {
            titulo.text = '';
            descricao.text = '';
            quantidade.text = '';
            Navigator.pop(context);
          },
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            if (formItemKey.currentState!.validate()) {
              ItemModel item = ItemModel(
                  nmItem: titulo.text,
                  descricao: descricao.text.isEmpty ? '' : descricao.text,
                  quantidade:
                      quantidade.text.isEmpty ? 1 : int.parse(quantidade.text));

              setState(() {
                if (op == 1) {
                  lista[indiceItem] = item;
                  repositorio.editarItem(indiceLista, indiceLista, item);
                  selecionados =[];
                } else {
                  repositorio.addItem(indiceLista, item);
                  lista.add(item);
                }
              });

              titulo.text = '';
              descricao.text = '';
              quantidade.text = '';

              Navigator.pop(context);
            }
          },
          child: Text(op == 0 ? "Adicionar" : 'Confirmar'),
        ),
      ],
    );
  }

  TextFormField campoTexto(TextEditingController controle, String label,
      bool validacao, int? linhas, bool tipo) {
    return TextFormField(
      controller: controle,
      style: const TextStyle(fontSize: 16),
      minLines: linhas ?? 1,
      maxLines: 50,
      keyboardType: tipo ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(25.0),
            ),
          ),
          prefixIcon: const Icon(Icons.shopping_cart_outlined)),
      validator: (value) {
        if (validacao) {
          if (value == null) {
            return 'Preenchimento obrigatorio';
          } else if (value.isEmpty) {
            return 'Preenchimento obrigatorio';
          }
        }
        return null;
      },
    );
  }
}
