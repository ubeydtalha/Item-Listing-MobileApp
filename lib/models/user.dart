import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/pages/category/category.new.dart';
import 'package:flutter_application_3/services/api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class User {
  final String id;
  String username;
  String email;
  String createdAt;
  String? fullName;
  String? image;
  String editedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
    required this.editedAt,
    this.fullName,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'] ?? '',
      email: json['email'],
      createdAt: json['created_at'] ?? '',
      editedAt: json['edited_at'] ?? '',
      fullName: json['full_name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'created_at': createdAt,
      'edited_at': editedAt,
      'full_name': fullName,
      'image': image,
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
          '${API.path}/${ImageLocation.user}/${image!.split('.').first}.jpg'),
      errorBuilder: (context, error, stackTrace) => Image.network(
        Supabase.instance.client.storage
            .from('user_image')
            .getPublicUrl('$id/$image.jpg'),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      ),
    );
  }
}