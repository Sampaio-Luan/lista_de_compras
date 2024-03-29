class ItemModel {
  String nmItem;
  String descricao;
  int quantidade;
  bool isCheck;


  ItemModel({
    required this.nmItem,
    required this.descricao,
    required this.quantidade,
    this.isCheck = false
  });
  
}
