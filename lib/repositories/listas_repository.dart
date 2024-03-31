import 'dart:collection';
import 'package:flutter/material.dart';
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
            quantidade: 3),
        ItemModel(
            nmItem: 'Feijao',
            descricao: 'Pacote de 3kg Fazenda Vaquinha Feliz',
            quantidade: 4,
            isCheck: true),
        ItemModel(
            nmItem: 'Açucar',
            descricao: 'Pacote de 5kg do Santa Isabel',
            quantidade: 2),
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

  addItem(int index, ItemModel item) async {
    _listaItens[index].itens.add(item);

    debugPrint('item adiconado a lista ${_listaItens[index].nome}');
  }

  removerItem(int index, ItemModel item) async {
    _listaItens[index].itens.remove(item);

    debugPrint('item removido da lista ${_listaItens[index].nome}');
  }

  editarItem(int index, int indexI, ItemModel item) async {
    _listaItens[index].itens[indexI] = item;

    debugPrint('item editado na lista ${_listaItens[index].nome}');
  }
}
