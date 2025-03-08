import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/pages/category/category.new.dart';
import 'package:flutter_application_3/services/api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'model.dart';

class Category extends ModelBase {
  @override
  String name;
  @override
  String image;
  int order = 0;
  @override
  String id;
  @override
  String editedAt = DateTime.now().toString();
  @override
  String createdAt = DateTime.now().toString();
  @override
  String userId;
  @override
  String teamId = "00000000-0000-0000-0000-000000000000";

  bool _is_synced = false;
  String _dummy_id = const Uuid().v4();

  @override
  bool get is_synced => _is_synced;
  @override
  set is_synced(bool value) {
    _is_synced = value;
  }

  @override
  String get dummy_id => _dummy_id;

  Category({
    required this.name,
    required this.image,
    required this.id,
    required this.order,
    required this.userId,
    String? createdAt,
    String? editedAt,
    String? teamId,
    String? dummy_id,
    bool? is_synced,
  }) : super(
          name: name,
          image: image,
          id: id,
          userId: userId,
          createdAt: createdAt,
          editedAt: editedAt,
          teamId: teamId,
          dummy_id: dummy_id,
        ) {
    this.createdAt = createdAt ?? this.createdAt;
    this.editedAt = editedAt ?? this.editedAt;
    // this.user_id = user_id ?? this.user_id;
    this.teamId = teamId ?? this.teamId;
    _dummy_id = dummy_id ?? _dummy_id;
    _is_synced = is_synced ?? _is_synced;
  }

  Category copyWith(
      {String? id,
      String? name,
      String? image,
      int? order,
      String? editedAt,
      String? createdAt,
      String? userId,
      String? teamId,
      String? dummy_id,
      bool? is_synced}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      editedAt: editedAt ?? this.editedAt,
      userId: userId ?? this.userId,
      teamId: teamId ?? this.teamId,
      dummy_id: dummy_id ?? this.dummy_id,
      is_synced: is_synced ?? this.is_synced,
    );
  }

  @override
  String toString() {
    return name;
  }

  void update({String? name, String? image, int? order}) {
    this.name = name ?? this.name;
    this.image = image ?? this.image;
    this.order = order ?? this.order;
    editedAt = DateTime.now().toString();
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      image: json['image'] ?? '',
      id: json['id'],
      order: json['order'] ?? 0,
      createdAt: json['created_at'],
      editedAt: json['edited_at'],
      userId: json['user_id'],
      teamId: json['team_id'],
      dummy_id: json['dummy_id'] ?? const Uuid().v4(),
      is_synced: json['is_synced'] ?? false,
    );
  }

  factory Category.fromDatabase(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      image: json['image'],
      id: json['id'],
      order: json['order'],
      createdAt: json['created_at'],
      editedAt: json['edited_at'],
      userId: json['user_id'],
      teamId: json['team_id'],
    );
  }

  // static Category random({int order = 0}) {
  //   var uuid = Uuid();

  //   return Category(
  //     name: 'Category $order',
  //     image: 'https://picsum.photos/250?image=${order+300}',
  //     id: uuid.v4().toString(),
  //     order: order,

  //   );
  // }

  // static List<Category> randomCategoryList(
  //     {int count = 10}
  // ) {
  //   return
  //     List<Category>.generate(count, (index) => Category.random(order: index+1));

  // }

  static List<Category> fromJsonList(List<dynamic> json) {
    return json.map((e) => Category.fromJson(e)).toList();
  }

  static List<dynamic> toJsonList(List<Category> categories) {
    return categories.map((e) => e.toJson()).toList();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'id': id,
      'order': order,
      'created_at': createdAt,
      'edited_at': editedAt,
      'user_id': userId,
      'team_id': teamId,
      'dummy_id': dummy_id,
      'is_synced': is_synced,
    };
  }

  Map<String, dynamic> toDatabase() {
    return {
      'name': name,
      'image': image,
      'id': id,
      'order': order,
      'created_at': createdAt,
      'edited_at': editedAt,
      'user_id': userId,
      'team_id': teamId,
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'name': name,
      'image': image,
      'order': order,
      'created_at': createdAt,
      'edited_at': editedAt,
      'user_id': userId,
      'team_id': teamId,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'order': order,
      'edited_at': editedAt,
    };
  }

  @override
  Image getImage(
      {double? width,
      double? height,
      BoxFit? fit = BoxFit.fill,
      String? errorText}) {
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
