class Favorite {
  final String id;
  String userId;
  final String productId;
  String createdAt = DateTime.now().toString();
  String editedAt = DateTime.now().toString();

  Favorite({
    required this.id,
    required this.userId,
    required this.productId,
    String? createdAt,
    String? editedAt,
  }){
    this.createdAt = createdAt ?? this.createdAt;
    this.editedAt = editedAt ?? this.editedAt;
  }

  Favorite copyWith({
    String? id,
    String? userId,
    String? productId,
    String? createdAt,
    String? editedAt,
  }) {
    return Favorite(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      createdAt: createdAt ?? this.createdAt,
      editedAt: editedAt ?? this.editedAt,
    );
  }

  static fromJson(dynamic json) {
    return Favorite(
      id: json['id'] as String,
      userId: json['userId'] as String,
      productId: json['productId'] as String,
      createdAt: json['createdAt'] as String, 
      editedAt: json['editedAt'] as String,
    );
  }

  dynamic toJson() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'createdAt': createdAt,
      'editedAt': editedAt,
    };
  }

  dynamic toCreateJson() {
    return {
      'userId': userId,
      'productId': productId,
    };
  }


  
}