class ItemModel {
  String nmItem;
  String descricao;
  int quantidade;
  bool isCheck;
  String id;

  ItemModel({
    required this.nmItem,
    required this.descricao,
    required this.quantidade,
    this.isCheck = false,
    required this.id,
  });
}
