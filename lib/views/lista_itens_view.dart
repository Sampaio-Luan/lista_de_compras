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
  TextEditingController filtrar = TextEditingController();
  final repositorio = ListasRespository();
  final List<Color> cor = [
    Colors.green,
    Colors.blue,
    Colors.pink,
  ];

  List<ItemModel> selecionados = [];
  bool isFiltrar = false;
  List<ItemModel> filtro = [];
  List<ItemModel> lista = [];
  @override
  void initState() {
    lista = widget.lis.itens;
    super.initState();
  }

  AppBar appBarDinamica() {
    if (isFiltrar) {
      return AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                isFiltrar = !isFiltrar;
                filtrar.text = '';
              });
            }),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10, right: 10),
          child: TextField(
            controller: filtrar,
            onEditingComplete: () {},
            onChanged: (value) {
              _fill(value);
            },
            style: const TextStyle(color: Colors.black),
            cursorColor: cor[widget.lis.tema],
            autofocus: true,
            decoration: InputDecoration(
              focusColor: cor[widget.lis.tema],
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
            ),
          ),
        ),
      );
    } else if (selecionados.isEmpty) {
      return AppBar(
        elevation: 1,
        title: Text(widget.lbl),
        centerTitle: true,
        backgroundColor: cor[widget.lis.tema],
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
                size: 26,
              ),
              onPressed: () {
                isFiltrar = !isFiltrar;
                setState(() {});
              }),
        ],
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

  void _fill(String query) {
    setState(() {
      filtro = lista
          .where(
              (obj) => obj.nmItem.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Widget pesquisar(Function cancelSearch, Function searching,
      TextEditingController searchController) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            cancelSearch();
          }),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10),
        child: TextField(
          controller: searchController,
          onEditingComplete: () {
            searching();
          },
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          autofocus: true,
          decoration: const InputDecoration(
            focusColor: Colors.white,
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
          ),
        ),
      ),
    );
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
            : isFiltrar
                ? filtro.isEmpty
                    ? const Center(child: Text('Nenhum item encontrado'))
                    : ListView.builder(
                        itemCount: filtro.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: Colors.white,
                            surfaceTintColor: cor[widget.lis.tema],
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 9,
                                  child: ListTile(
                                    onLongPress: () {
                                      setState(() {
                                        (selecionados.contains(lista[index]))
                                            ? selecionados.remove(lista[index])
                                            : selecionados.add(lista[index]);
                                      });
                                    },
                                    selected:
                                        selecionados.contains(filtro[index]),
                                    selectedTileColor: Colors.orange,
                                    selectedColor: Colors.white,
                                    title: Text(filtro[index].nmItem),
                                    subtitle: Text(
                                      filtro[index].descricao,
                                      overflow:
                                          filtro[index].descricao.length > 30
                                              ? TextOverflow.ellipsis
                                              : null,
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          cor[widget.lis.tema].withAlpha(180),
                                      child: Text(
                                        '${filtro[index].quantidade}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    trailing: Checkbox(
                                      activeColor: cor[widget.lis.tema],
                                      value: filtro[index].isCheck,
                                      onChanged: (bool? novoValor) {
                                        setState(() {
                                          filtro[index].isCheck =
                                              !lista[index].isCheck;
                                        });

                                        repositorio.editarItem(
                                            widget.indice, index, lista[index]);
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                    onPressed: () {
                                      titulo.text = filtro[index].nmItem;
                                      descricao.text = filtro[index].descricao;
                                      quantidade.text =
                                          filtro[index].quantidade.toString();
                                          selecionados = [];
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return addItem(
                                                widget.indice, index, 1);
                                          });
                                    },
                                    icon: Icon(
                                      Icons.edit_rounded,
                                      color: cor[widget.lis.tema],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                : ListView.builder(
                    itemCount: lista.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Colors.white,
                        surfaceTintColor: cor[widget.lis.tema],
                        child: Row(
                          children: [
                            Expanded(
                              flex: 9,
                              child: ListTile(
                                onLongPress: () {
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
                                  backgroundColor:
                                      cor[widget.lis.tema].withAlpha(180),
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
                                      lista[index].isCheck =
                                          !lista[index].isCheck;
                                    });

                                    repositorio.editarItem(
                                        widget.indice, index, lista[index]);
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                onPressed: () {
                                  titulo.text = lista[index].nmItem;
                                  descricao.text = lista[index].descricao;
                                  quantidade.text =
                                      lista[index].quantidade.toString();
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return addItem(widget.indice, index, 1);
                                      });
                                },
                                icon: Icon(
                                  Icons.edit_rounded,
                                  color: cor[widget.lis.tema],
                                ),
                              ),
                            ),
                          ],
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
                  if (selecionados.isNotEmpty) {
                    for (int a = 0; a < selecionados.length; a++) {
                      lista.remove(selecionados[a]);
                      repositorio.removerItem(widget.indice, selecionados[a]);
                    }

                    setState(() {
                      selecionados = [];
                    });
                  }
                },
                label: const Text(
                  'Excluir',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                icon: const Icon(
                  Icons.delete_forever,
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
      insetPadding: const EdgeInsets.all(25),
      elevation: 0,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Text(
        op == 1
            ? 'Editar Item em ${widget.lbl}'
            : 'Adiconar Item a ${widget.lbl}',
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Form(
            key: formItemKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  campoTexto(titulo, 'Nome Item', true, null, false),
                  const SizedBox(height: 15),
                  campoTexto(descricao, 'Descrição', false, 3, false),
                  const SizedBox(height: 15),
                  campoTexto(quantidade, 'Quantidade', false, null, true),
                ],
              ),
            )),
      ),
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
                  repositorio.editarItem(indiceLista, indiceItem, item);
                  selecionados = [];
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
