import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:lista_de_compras/models/item_model.dart';
import 'package:lista_de_compras/models/lista_model.dart';

class ListasRespository {
final List<ListaModel> _listaItems = [];

  UnmodifiableListView<ListaModel> get listas => UnmodifiableListView(_listaItems);

  criarLista(ListaModel lista){

    _listaItems.add(lista);

    debugPrint('Lista criada');

  }

    editarLista(int index, String nome){

    _listaItems[index].nome = nome;

    debugPrint('Lista editada');

  }

    excluirLista(ListaModel lista){

    _listaItems.remove(lista);

    debugPrint('Lista excluida');

  }

  addItem(int index ,ItemModel item){

    _listaItems[index].itens.add(item);

    debugPrint('item adiconado a lista ${_listaItems[index].nome}');
  }

  removerItem(int index ,ItemModel item){

    _listaItems[index].itens.remove(item);

    debugPrint('item removido da lista ${_listaItems[index].nome}');

  }

    editarItem(int index ,int indexI, ItemModel item){

    _listaItems[index].itens[indexI] = item;

    debugPrint('item editado na lista ${_listaItems[index].nome}');

  }


}