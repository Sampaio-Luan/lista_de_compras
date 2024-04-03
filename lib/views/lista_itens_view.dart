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

  void _fill(String query) {
    setState(() {
      filtro = lista
          .where(
              (obj) => obj.nmItem.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarDinamica(),
        body: lista.isEmpty
            ? Center(child: Text('Adicone Itens a sua lista ${widget.lbl}'))
            : isFiltrar
                ? filtro.isEmpty
                    ? Center(
                        child: Text(
                          filtrar.text.isEmpty
                              ? 'Digite o nome do item para pesquisar'
                              : 'Não há "${filtrar.text}" nessa lista !',
                          style: const TextStyle(fontSize: 18),
                        ),
                      )
                    : visualizacaoLisya(filtro)
                : visualizacaoLisya(lista),
        floatingActionButtonLocation: selecionados.isEmpty
            ? FloatingActionButtonLocation.endFloat
            : FloatingActionButtonLocation.centerFloat,
        floatingActionButton: selecionados.isEmpty && !isFiltrar
            ? FloatingActionButton.extended(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return addItem('', 0);
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
            : isFiltrar && selecionados.isNotEmpty || selecionados.isNotEmpty
                ? FloatingActionButton.extended(
                    onPressed: () {
                      if (selecionados.isNotEmpty) {
                        for (int a = 0; a < selecionados.length; a++) {
                          lista.remove(selecionados[a]);
                          filtro.remove(selecionados[a]);
                          repositorio.removerItem(
                              widget.indice, selecionados[a]);
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
                  )
                : null,
      ),
    );
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
                filtro = [];
                selecionados = [];
              });
            }),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10, right: 10),
          child: TextField(
            controller: filtrar,
            onEditingComplete: () {},
            onChanged: (value) {
              filtrar.text.isEmpty
                  ? setState(() {
                      filtro = [];
                    })
                  : _fill(value);
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
        title: Text(
          widget.lbl,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: cor[widget.lis.tema],
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
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

  ListView visualizacaoLisya(List<ItemModel> l) {
    return ListView.builder(
      itemCount: l.length,
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
                      (selecionados.contains(l[index]))
                          ? selecionados.remove(l[index])
                          : selecionados.add(l[index]);
                    });
                  },
                  selected: selecionados.contains(l[index]),
                  selectedTileColor: Colors.orange,
                  selectedColor: Colors.white,
                  title: Text(l[index].nmItem),
                  subtitle: Text(
                    l[index].descricao,
                    overflow: l[index].descricao.length > 30
                        ? TextOverflow.ellipsis
                        : null,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: cor[widget.lis.tema].withAlpha(180),
                    child: Text(
                      l[index].quantidade,
                      style: const TextStyle(color: Colors.white),
                      overflow: l[index].quantidade.length > 4
                          ? TextOverflow.ellipsis
                          : null,
                    ),
                  ),
                  trailing: Checkbox(
                    activeColor: cor[widget.lis.tema],
                    value: l[index].isCheck,
                    onChanged: (bool? novoValor) {
                      setState(() {
                        l[index].isCheck = !l[index].isCheck;
                      });

                      repositorio.editarItem(l[index]);
                    },
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    titulo.text = l[index].nmItem;
                    descricao.text = l[index].descricao;
                    quantidade.text = l[index].quantidade.toString();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return addItem(l[index].id, 1);
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
    );
  }

  AlertDialog addItem(String id, int op) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(25),
      elevation: 0,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Text(
        op == 1
            ? 'Editar Item em ${widget.lbl}'
            : 'Adiconar Item a ${widget.lbl}',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: cor[widget.lis.tema]),
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
                  campoTexto(descricao, 'Descrição', false, 2, false),
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
          child: Text(
            "Cancelar",
            style: TextStyle(fontSize: 16, color: cor[widget.lis.tema]),
          ),
        ),
        TextButton(
          onPressed: () {
            if (formItemKey.currentState!.validate()) {
              ItemModel item = ItemModel(
                  nmItem: titulo.text,
                  descricao: descricao.text.isEmpty ? '' : descricao.text,
                  quantidade: quantidade.text.isEmpty ? '1' : quantidade.text,
                  id: id.isNotEmpty ? id : DateTime.now().toString());

              if (op == 1) {
                for (int a = 0; a < lista.length; a++) {
                  if (lista[a].id == id) {
                    lista[a] = item;
                  }
                }
                for (int a = 0; a < filtro.length; a++) {
                  if (filtro[a].id == id) {
                    filtro[a] = item;
                  }
                }
                if(filtro.isNotEmpty){
                  _fill(filtrar.text);
                }
                repositorio.editarItem(item);
                
                selecionados = [];
              } else {
                debugPrint(
                    'Valor do indice passado por parametro: ${widget.indice}');

                setState(() {
                  lista.add(item);
                  widget.lis.itens = lista;
                  repositorio.addItem(widget.lis);
                });
              }

              setState(() {});

              titulo.text = '';
              descricao.text = '';
              quantidade.text = '';

              Navigator.pop(context);
            }
          },
          child: Text(
            op == 0 ? "Adicionar" : 'Confirmar',
            style: TextStyle(fontSize: 16, color: cor[widget.lis.tema]),
          ),
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
