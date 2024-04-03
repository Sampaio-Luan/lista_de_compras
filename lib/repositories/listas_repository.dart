import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lista_de_compras/models/item_model.dart';
import 'package:lista_de_compras/models/lista_model.dart';

class ListasRespository {
  final List<ListaModel> _listaItens = [];

  UnmodifiableListView<ListaModel> get listas =>
      UnmodifiableListView(_listaItens);

  ListasRespository() {
    iniciaRepositorio();
  }

  iniciaRepositorio() {
    if (_listaItens.isEmpty) {
      ListaModel listaExemplo =
          ListaModel(nome: 'Lista Exemplo', tema: 0, itens: [
        ItemModel(
            nmItem: 'Arroz',
            descricao: 'Pacote de 2kg do Arroz tio ze',
            quantidade: '3',
            id: 'abc'),
        ItemModel(
            nmItem: 'Feijao',
            descricao: 'Pacote de 3kg Fazenda Vaquinha Feliz',
            quantidade: '4',
            isCheck: true,
            id: 'cba'),
        ItemModel(
            nmItem: 'Açucar',
            descricao: 'Pacote de 5kg do Santa Isabel',
            quantidade: '2',
            id: 'cab'),
      ]);

      _listaItens.add(listaExemplo);
    }
  }

  criarLista(ListaModel lista) async {
    _listaItens.add(lista);

    debugPrint('Lista criada, tamanho ${_listaItens.length}');
  }

  editarLista(int index, String nome) async {
    _listaItens[index].nome = nome;

    debugPrint('Lista editada');
  }

  excluirLista(ListaModel lista) async {
    _listaItens.remove(lista);

    debugPrint('Lista excluida');
  }

  addItem(ListaModel l) async {
    _listaItens.add(l);

    debugPrint('item adiconado a lista ${l.nome}');
  }

  removerItem(int index, ItemModel item) async {
    _listaItens[index].itens.remove(item);

    debugPrint('item removido da lista ${_listaItens[index].nome}');
  }

  editarItem(ItemModel item) async {
    for (int i = 0; i < _listaItens.length; i++) {
      for (int j = 0; j < _listaItens[i].itens.length; j++) {
        if (_listaItens[i].itens[j].id == item.id) {
          _listaItens[i].itens[j] = item;
          debugPrint('item editado na lista ${_listaItens[i].nome}');
        }
      }
    }
  }
}
