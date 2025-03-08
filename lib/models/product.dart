import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/model.dart';
import 'package:flutter_application_3/pages/category/category.new.dart';
import 'package:flutter_application_3/services/api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class Product extends ModelBase {
  @override
  String id;
  @override
  String name;
  String description;
  String secondName;
  @override
  String image;
  List<String> images = [];
  double price;
  int quantity;
  String categoryId = '00000000-0000-0000-0000-000000000000';
  String barcode;
  @override
  String editedAt = DateTime.now().toString();
  @override
  String createdAt = DateTime.now().toString();
  @override
  String userId;
  @override
  String teamId = '00000000-0000-0000-0000-000000000000';

  bool _is_synced = false;

  @override
  bool get is_synced => _is_synced;
  @override
  set is_synced(bool value) {
    _is_synced = value;
  }

  String _dummy_id = const Uuid().v4();
  @override
  String get dummy_id => _dummy_id;
  set dummy_id(String value) {
    _dummy_id = value;
  }

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.secondName,
    required this.image,
    required this.images,
    required this.price,
    required this.quantity,
    required this.categoryId,
    required this.barcode,
    required this.userId,
    String? teamId,
    int? stock,
    String? editedAt,
    String? createdAt,
    bool is_synced = false,
    String? dummy_id,
  }) : super(
          name: name,
          image: image,
          id: id,
          userId: userId,
          createdAt: createdAt,
          editedAt: editedAt,
          teamId: teamId,
          dummy_id: dummy_id,
          is_synced: is_synced,
        ) {
    this.editedAt = editedAt ?? this.editedAt;
    this.createdAt = createdAt ?? this.createdAt;
    this.teamId = teamId ?? this.teamId;
    this.is_synced = is_synced;
    this.dummy_id = dummy_id ?? this.dummy_id;
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? secondName,
    String? image,
    List<String>? images,
    double? price,
    int? quantity,
    String? category,
    String? barcode,
    int? stock,
    String? editedAt,
    String? createdAt,
    String? userId,
    String? teamId,
    String? dummy_id,
    bool? is_synced,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      secondName: secondName ?? this.secondName,
      image: image ?? this.image,
      images: images ?? this.images,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      categoryId: category ?? categoryId,
      barcode: barcode ?? this.barcode,
      editedAt: editedAt ?? this.editedAt,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      teamId: teamId ?? this.teamId,
      dummy_id: dummy_id ?? this.dummy_id,
      is_synced: is_synced ?? this.is_synced,
    );
  }

  void update({
    String? id,
    String? name,
    String? description,
    String? secondName,
    String? image,
    List<String>? images,
    double? price,
    int? quantity,
    String? category,
    String? barcode,
    int? stock,
  }) {
    this.id = id ?? this.id;
    this.name = name ?? this.name;
    this.description = description ?? this.description;
    this.secondName = secondName ?? this.secondName;
    this.image = image ?? this.image;
    this.images = images ?? this.images;
    this.price = price ?? this.price;
    this.quantity = quantity ?? this.quantity;
    categoryId = category ?? categoryId;
    this.barcode = barcode ?? this.barcode;
    editedAt = DateTime.now().toString();
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      secondName: json['second_name'],
      image: json['image'] ?? '',
      images: List<String>.from(json['images']),
      price: json['price'] ?? 0.0,
      quantity: json['quantity'] ?? 1,
      categoryId: json['category_id'] ?? 0,
      barcode: json['barcode'] ?? '',
      stock: json['stock'] ?? 0,
      editedAt: json['editedAt'],
      createdAt: json['createdAt'],
      userId: json['user_id'],
      teamId: json['team_id'],
      dummy_id: json['dummy_id'] ?? const Uuid().v4(),
      is_synced: json['is_synced'] ?? false,
    );
  }

  factory Product.fromDatabase(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      secondName: json['second_name'],
      image: json['image'],
      images: List<String>.from(json['images']),
      price: json['price'] ?? 0.0,
      quantity: json['quantity'] ?? 1,
      categoryId: json['category_id'] ?? 0,
      barcode: json['barcode'] ?? '',
      stock: json['stock'] ?? 0,
      editedAt: json['edited_at'],
      createdAt: json['created_at'],
      userId: json['user_id'],
      teamId: json['team_id'],
    );
  }

  // // create random produckt
  // static Product random() {
  //   var uuid = Uuid();
  //   int randomNumber = Random().nextInt(1000);

  //   return Product(
  //     id: uuid.v4(),
  //     name: loremIpsum(words: 2, paragraphs: 1),
  //     description: loremIpsum(words: 10, paragraphs: 1),
  //     secondName: loremIpsum(words: 2, paragraphs: 1),
  //     image: 'https://picsum.photos/250?image=$randomNumber',
  //     images: List.generate(Random().nextInt(3)+1, (index) => 'https://picsum.photos/250?image=${randomNumber+index}'),
  //     price: 10.0,
  //     quantity: 1,
  //     category: Random().nextInt(9)+1,
  //     barcode: randomNumber.toString(),
  //     stock: Random().nextInt(100),

  //   );
  // }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'second_name': secondName,
      'image': image,
      'images': images,
      'price': price,
      'quantity': quantity,
      'category_id': categoryId,
      'barcode': barcode,
      'edited_at': editedAt,
      'created_at': createdAt,
      'user_id': userId,
      'team_id': teamId,
      'dummy_id': dummy_id,
      'is_synced': is_synced,
    };
  }

  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'second_name': secondName,
      'image': image,
      'images': images,
      'price': price,
      'quantity': quantity,
      'category_id': categoryId,
      'barcode': barcode,
      'edited_at': editedAt,
      'created_at': createdAt,
      'user_id': userId,
      'team_id': teamId,
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'name': name,
      'description': description,
      'second_name': secondName,
      'image': image,
      'images': images,
      'price': price,
      'quantity': quantity,
      'category_id': categoryId,
      'barcode': barcode,
      'edited_at': editedAt,
      'user_id': userId,
      'team_id': teamId,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'second_name': secondName,
      'image': image,
      'images': images,
      'price': price,
      'quantity': quantity,
      'category_id': categoryId,
      'barcode': barcode,
      'edited_at': DateTime.now().toString(),
    };
  }

  @override
  String toString() {
    return name;
  }

  @override
  Image getImage({double? width, double? height, BoxFit? fit = BoxFit.fill, String? errorText}) {
    return Image.file(
      File(
          '${API.path}/${ImageLocation.product}/${image.split('.').first}.jpg'),
      errorBuilder: (context, error, stackTrace) => Image.network(
        Supabase.instance.client.storage
            .from('product_image')
            .getPublicUrl('$userId/$image.jpg'),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      ),
    );
  }
}

enum ProductType {
  kilogram,
  adet,
}
