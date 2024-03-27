import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titulo = TextEditingController();
  TextEditingController descricao = TextEditingController();
  TextEditingController quantidade = TextEditingController();
  TextEditingController listaCompras = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return novaLista();
                });
          }, //novaLista(),
          tooltip: 'Increment',
          label: const Text('Nova Lista',style: TextStyle(color: Colors.white, fontSize: 16),),
          icon: const Icon(Icons.add, color: Colors.white,),
          backgroundColor: Colors.green[700],
          
          
        
        ), // This trailing comma makes auto-formatting nicer for build methods.
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
      content: TextFormField(
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

            Navigator.pop(context);
          },
          child: const Text("Adicionar"),
        ),
      ],
    );
  }
}
