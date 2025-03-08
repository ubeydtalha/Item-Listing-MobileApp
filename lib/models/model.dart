

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

abstract class ModelBase  extends Object{

  String id = '';
  String name = '';
  String userId = '';
  String teamId = '00000000-0000-0000-0000-000000000000';
  String createdAt = DateTime.now().toString();
  String editedAt = DateTime.now().toString();
  String image = '';
  
  bool _is_synced = false;
  final String _dummy_id = const Uuid().v4();

  bool get is_synced => _is_synced;
  set is_synced(bool value) {
    _is_synced = value;
  }

  String get dummy_id => _dummy_id;

  ModelBase(
    {
    required this.name,
    required this.image,
    required this.id,
    required this.userId,
    String? createdAt,
    String? editedAt,
    String? teamId,
    String? dummy_id,
    bool? is_synced,
  }
  );

  Map<String, dynamic> toJson();

  ModelBase.fromJson(Map<String, dynamic> json);

  Image getImage();

}