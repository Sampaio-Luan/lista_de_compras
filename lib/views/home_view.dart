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
  Widget build(BuildContext context) {
    final listas = repositorio.listas;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
        ),
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
                    onLongPress: () {},
                    onTap: () {
                      debugPrint('$index');
                      
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
                child:
                    Text('Crie uma lista de compras para Adiconar seus itens')),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return novaLista();
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
        ),
      ),
    );
  }

  AlertDialog novaLista() {
    return AlertDialog(
      elevation: 0,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: const Text(
        'Nova Lista de Compras',
        textAlign: TextAlign.center,
      ),
      content: Form(
        key: nomeListaFormKey,
        child: TextFormField(
          controller: listaCompras,
          style: const TextStyle(fontSize: 16),
          decoration: const InputDecoration(
              helperText: 'Digite o nome da sua lista de compras',
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
              tema++;
              if (tema > 2) tema = 0;
              ListaModel lista =
                  ListaModel(nome: listaCompras.text, tema: tema, itens: []);
              repositorio.criarLista(lista);
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
}
