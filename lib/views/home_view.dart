import 'package:flutter/material.dart';
import 'package:lista_de_compras/models/lista_model.dart';
import 'package:lista_de_compras/repositories/listas_repository.dart';
import 'package:lista_de_compras/views/lista_itens_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController listaCompras = TextEditingController();
  int tema = 0;
  var nomeListaFormKey = GlobalKey<FormState>();
  final repositorio = ListasRespository();
  List<ListaModel> listas = [];
  List<ListaModel> selecionados = [];
  List<int> indices = [];

  List<Color> cor = [
    Colors.green,
    Colors.blue,
    Colors.pink,
  ];

  List<IconData> icone = [
    Icons.payments_outlined,
    Icons.shopping_cart_outlined,
    Icons.shopify_outlined,
  ];
  @override
  void initState() {
    listas = repositorio.listas;
    super.initState();
  }

  AppBar appBarDinamica() {
    if (selecionados.isEmpty) {
      return AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
      );
    } else {
      return AppBar(
        elevation: 1,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       for (int a = 0; a < selecionados.length; a++) {
        //         repositorio.excluirLista(selecionados[a]);
        //       }
        //       selecionados = [];
        //       indices = [];
        //       setState(() {});
        //     },
        //     icon: const Icon(
        //       Icons.delete_forever,
        //       color: Colors.white,
        //     ),
        //   ),
        // ],
        title: selecionados.length == 1
            ? Text('${selecionados.length} LISTA SELECIONADA')
            : Text('${selecionados.length} LISTAS SELECIONADAS'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            setState(() {
              selecionados = [];
              indices = [];
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: appBarDinamica(),
          body: listas.isNotEmpty
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  itemCount: listas.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Card.outlined(
                        color:
                            indices.contains(index) ? Colors.orange[400] : null,
                        child: SizedBox(
                          height: 110,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                icone[listas[index].tema],
                                color: cor[listas[index].tema],
                                size: 50,
                              ),
                              Text(
                                listas[index].nome,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18.0),
                                overflow: listas[index].nome.length > 15
                                    ? TextOverflow.ellipsis
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                      onLongPress: () {
                        debugPrint('Selecionado');
                        setState(() {
                          (selecionados.contains(listas[index]))
                              ? selecionados.remove(listas[index])
                              : selecionados.add(listas[index]);
                          (indices.contains(index))
                              ? indices.remove(index)
                              : indices.add(index);
                        });
                        opcoes();
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListaItensView(
                              lis: listas[index],
                              lbl: listas[index].nome,
                              indice: index,
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              : const Center(
                  child: Text(
                      'Crie uma lista de compras para Adiconar seus itens')),
          floatingActionButton: selecionados.isEmpty
              ? FloatingActionButton.extended(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return novaLista(false);
                        });
                  },
                  label: const Text(
                    'Criar Lista',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.green[500],
                )
              : null),
    );
  }

  AlertDialog novaLista(bool isEdit) {
    return AlertDialog(
      elevation: 0,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: const Text(
        'Lista de Compras',
        textAlign: TextAlign.center,
      ),
      content: Form(
        key: nomeListaFormKey,
        child: TextFormField(
          controller: listaCompras,
          style: const TextStyle(fontSize: 16),
          decoration: const InputDecoration(
              labelText: 'Nome da Lista',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
              ),
              prefixIcon: Icon(Icons.shopping_cart_outlined)),
          validator: (value) {
            if (value == null) {
              return 'Preenchimento obrigatorio';
            } else if (value.isEmpty) {
              return 'Preenchimento obrigatorio';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            listaCompras.text = '';
            Navigator.pop(context);
          },
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            debugPrint(listaCompras.text);
            if (nomeListaFormKey.currentState!.validate()) {
              if (isEdit) {
                repositorio.editarLista(indices[0], listaCompras.text);
                selecionados = [];
                indices = [];
              } else {
                tema++;
                ListaModel lista =
                    ListaModel(nome: listaCompras.text, tema: tema, itens: []);
                repositorio.criarLista(lista);
              }

              if (tema > 2) tema = 0;

              listaCompras.text = '';
              setState(() {});
              Navigator.pop(context);
            }
          },
          child: const Text("Adicionar"),
        ),
      ],
    );
  }

  void opcoes() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              selecionados.length == 1
                  ? ListTile(
                      title: const Text('Editar Lista'),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 50),
                      trailing: const Icon(Icons.edit),
                      iconColor: Colors.orange,
                      onTap: () {
                        Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            builder: (BuildContext bc) {
                              listaCompras.text = selecionados[0].nome;
                              return novaLista(true);
                            });
                      },
                    )
                  : const Divider(
                      thickness: 0.1,
                      color: Colors.orange,
                    ),
              ListTile(
                title: const Text('Deletar'),
                contentPadding: const EdgeInsets.symmetric(horizontal: 50),
                trailing: const Icon(
                  Icons.delete_forever,
                ),
                iconColor: Colors.orange,
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (BuildContext bc) {
                        return AlertDialog(
                          elevation: 0,
                          title: const Text('IMPORTANTE !!!',
                              textAlign: TextAlign.center),
                          actionsAlignment: MainAxisAlignment.spaceAround,
                          content: Text(
                            selecionados.length == 1
                                ? 'Tem certeza que deseja deletar essa lista ?'
                                : 'Tem certeza que deseja deletar essas listas ?',
                            textAlign: TextAlign.justify,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Não, Cancelar",
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                for (int a = 0; a < selecionados.length; a++) {
                                  repositorio.excluirLista(selecionados[a]);
                                }
                                selecionados = [];
                                indices = [];
                                setState(() {});
                                Navigator.pop(context);
                              },
                              child: const Text("Sim, Deletar"),
                            ),
                          ],
                        );
                      });
                },
              ),
            ],
          );
        });
  }
}
