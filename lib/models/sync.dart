


import 'package:flutter_application_3/action_base/action.base.dart';
import 'package:flutter_application_3/models/category.dart';
import 'package:flutter_application_3/models/model.dart';
import 'package:flutter_application_3/models/product.dart';



enum DescriptionType {
  SUCCESS,
  ERROR,
  FETCH,
  UNKNOWN
}



class SyncItemModel {

  final ActionType action;
  final ModelBase item;
  final String type;
  bool is_synced = false;
  DescriptionType description = DescriptionType.UNKNOWN;

  SyncItemModel({required this.action, required this.item, required this.type, this.is_synced = false, this.description = DescriptionType.UNKNOWN});

  @override
  String toString() {
    return 'SyncItemModel { action: $action, item: $item, type: $type }';
  }

  SyncItemModel copyWith({
    ActionType? action,
    ModelBase? item,
    String? type,
    DescriptionType description = DescriptionType.UNKNOWN,
    bool is_synced = false,
  }) {
    return SyncItemModel(
      action: action ?? this.action,
      item: item ?? this.item,
      type: type ?? this.type, 
      description: description,
      is_synced: is_synced,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncItemModel &&
          runtimeType == other.runtimeType &&
          item == other.item &&
          action == other.action &&
          type == other.type;

  @override
  int get hashCode => action.hashCode ^ item.hashCode ^ type.hashCode ^ is_synced.hashCode ^ description.hashCode;

  SyncItemModel.fromJson(Map<String, dynamic> json)
      : action = switch (json['action']) {
                      'ADD' => ActionType.ADD,
                      'UPDATE' => ActionType.UPDATE,
                      'DELETE' => ActionType.DELETE,
                      _ => ActionType.UNKNOWN
                    },
        item = json['type'] == 'Category'
            ? Category.fromJson(json['item'])
            : Product.fromJson(json['item']),
        type = json['type'],
        is_synced = json['is_synced'] ?? false,
        description =   switch (json['description']) {
                      'SUCCESS' => DescriptionType.SUCCESS,
                      'ERROR' => DescriptionType.ERROR,
                      'FETCH' => DescriptionType.FETCH,
                      _ => DescriptionType.UNKNOWN
                    };

  Map<String, dynamic> toJson() {
    return {
      'action': action.name,
      'item': item.toJson(),
      'type': item.runtimeType.toString(),
      'is_synced': is_synced,
      'description': description.name,
    };
  }

}


// class SyncRecivedModel extends SyncItemModel{


//   bool is_synced = false;
//   String description = '';

//   SyncRecivedModel({required super.action, required super.item, required super.type});


//   SyncRecivedModel.fromJsonText(String text) 

// }