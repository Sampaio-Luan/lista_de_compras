import 'package:flutter/material.dart';
import 'package:lista_de_compras/models/lista_model.dart';
import 'package:lista_de_compras/repositories/listas_repository.dart';

class ListaItensView extends StatefulWidget {
  final ListaModel lista;
  final int indice;
  const ListaItensView({
    super.key,
    required this.lista,
    required this.indice,
  });

  @override
  State<ListaItensView> createState() => _ListaItensViewState();
}

class _ListaItensViewState extends State<ListaItensView> {
  final repositorio = ListasRespository();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(widget.lista.nome),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget.lista.itens.length,
        itemBuilder: (BuildContext context, int index) {
          return ColoredBox(
            color: Colors.green,
            child: Material(
              child: CheckboxListTile(
                //tileColor: Colors.red,
                title: Text(widget.lista.itens[index].nmItem),
                subtitle: Text(widget.lista.itens[index].descricao),
                value: widget.lista.itens[index].isCheck,
                onChanged: (bool? value) {
                  widget.lista.itens[index].isCheck = !widget.lista.itens[index].isCheck;
                  repositorio.editarItem(widget.indice, index, widget.lista.itens[index]);
                  setState(() {
                    
                  });
                },
              ),
            ),
          );
          // Card(
          //   child: ListTile(
          //     title: Text(widget.lista.itens[index].nmItem),
          //     subtitle: Text(widget.lista.itens[index].descricao),
          //     selected: widget.lista.itens[index].isCheck,
          //     leading: CircleAvatar(
          //       child: Text('${widget.lista.itens[index].quantidade}'),
          //     ),

          //   ),
          // );
        },
      ),
    ));
  }
}
