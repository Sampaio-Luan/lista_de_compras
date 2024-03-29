import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:lista_de_compras/models/item_model.dart';
import 'package:lista_de_compras/models/lista_model.dart';

class ListasRespository {
final List<ListaModel> _listaItens = [];

  UnmodifiableListView<ListaModel> get listas => UnmodifiableListView(_listaItens);

  criarLista(ListaModel lista){

    _listaItens.add(lista);

    debugPrint('Lista criada');

  }

    editarLista(int index, String nome){

    _listaItens[index].nome = nome;

    debugPrint('Lista editada');

  }

    excluirLista(ListaModel lista){

    _listaItens.remove(lista);

    debugPrint('Lista excluida');

  }

  addItem(int index ,ItemModel item){

    _listaItens[index].itens.add(item);

    debugPrint('item adiconado a lista ${_listaItens[index].nome}');
  }

  removerItem(int index ,ItemModel item){

    _listaItens[index].itens.remove(item);

    debugPrint('item removido da lista ${_listaItens[index].nome}');

  }

    editarItem(int index ,int indexI, ItemModel item){

    _listaItens[index].itens[indexI] = item;

    debugPrint('item editado na lista ${_listaItens[index].nome}');

  }


}