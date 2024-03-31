import 'package:lista_de_compras/models/item_model.dart';

class ListaModel {
  String nome;
  int tema;
  List<ItemModel> itens;
  
  ListaModel({
    required this.nome,
    required this.tema,
    required this.itens,
  });
}
