import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/pages/category/category.new.dart';
import 'package:flutter_application_3/services/api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Team {
  final String id;
  String name;
  String image;
  String createdAt = DateTime.now().toString();
  String editedAt = DateTime.now().toString();
  String userId;
  bool isPublic = false;

  Team({
    required this.id,
    required this.name,
    this.userId = '', // Add a field initializer for 'userId'
    this.image = '',
    String? editedAt,
    String? createdAt,
    this.isPublic = false,
  }) {
    this.editedAt = editedAt ?? this.editedAt;
    this.createdAt = createdAt ?? this.createdAt;
  }
  
  factory Team.initial() {
    return Team(
      id: '',
      name: '',
      userId: '',
      image: '',
      isPublic: false,
    );
  }

  Team copyWith({
    String? id,
    String? name,
    String? createdAt,
    String? image,
    String? editedAt,
    String? userId,
    String? isPublic,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      image: image ?? this.image,
      editedAt: editedAt,
      userId: userId ?? this.userId,
      isPublic: isPublic == 'true' ? true : false,
    );
  }

  static Team fromJson(dynamic json) {
    return Team(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: json['created_at'] as String,
      image: json['image'] as String,
      editedAt: json['edited_at'] as String,
      userId: json['user_id'] as String,
      isPublic: json['is_public'] as bool,
    );
  }

  dynamic toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toString(),
      'image': image,
      'edited_at': editedAt,
      'user_id': userId,
      'is_public': isPublic,
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'name': name,
      'image': image,
      'user_id': userId,
      'is_public': isPublic,
    };
  }

  void update({
    String? name,
    String? image,
    bool? isPublic,
  }) {
    this.name = name ?? this.name;
    this.image = image ?? this.image;
    this.isPublic = isPublic ?? this.isPublic;
    editedAt = DateTime.now().toString();
  }

  Image getImage(
    {double width = 100, double height = 100, BoxFit fit = BoxFit.cover}
  ) {
      return Image.file(
      File(
          '${API.path}/${ImageLocation.product}/${image.split('.').first}.jpg'),
      errorBuilder: (context, error, stackTrace) => Image.network(
        Supabase.instance.client.storage
            .from('team_image')
            .getPublicUrl('$image.jpg'),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => const Center(child :Icon(Icons.error)),
      ),
    );
  }
}
