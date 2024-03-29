import 'package:lista_de_compras/models/item_model.dart';

class ListaModel {
  String nome;
  List<ItemModel> itens = [];
  
  ListaModel({
    required this.nome,
    required this.itens,
  });
}
