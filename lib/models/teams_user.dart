import 'package:flutter_application_3/models/user.dart';

enum TeamRole { USER, ADMIN, OWNER, GUEST , CANDIDATE }

enum TeamsUserUpdateType { 
  UPGRADE , DOWNGRADE , REMOVE , NOTHING
 }
/// Takımlardaki kullanıcıları temsil eden sınıf.
/// 
/// 
/// 

class TeamsUser {
  final String id;
  final String teamId;
  final String userId;
  final TeamRole role;
  final String editedAt;
  final String createdAt;

  User? user;

  TeamsUser({
    required this.id,
    required this.teamId,
    required this.userId,
    required this.role,
    required this.editedAt,
    required this.createdAt,
    User? user
  }){
    this.user = user;
  }

  factory TeamsUser.fromJson(Map<String, dynamic> json) {
    return TeamsUser(
      id: json['id'],
      teamId: json['team_id'],
      userId: json['user_id'],
      role: () {
        switch (json['role'].toString().toUpperCase()) {
          case 'USER':
            return TeamRole.USER;
          case 'ADMIN':
            return TeamRole.ADMIN;
          case 'OWNER':
            return TeamRole.OWNER;
          case 'GUEST':
            return TeamRole.GUEST;
          case 'CANDIDATE':
            return TeamRole.CANDIDATE;
          default:
            return TeamRole.USER;
        }
      }(),
      editedAt: json['edited_at'],
      createdAt: json['created_at'],
      // user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'team_id': teamId,
      'user_id': userId,
      'role': role.index,
      'edited_at': editedAt,
      'created_at': createdAt,
      'user': user?.toJson(),
    };
  }

  TeamsUser copyWith({
    String? id,
    String? teamId,
    String? userId,
    TeamRole? role,
    String? editedAt,
    String? createdAt,
    User? user
  }) {
    return TeamsUser(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      editedAt: editedAt ?? this.editedAt,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
    );
  }

  Map<String, Object> toUpdateJson() {
    return {
      'role': role.name,
      'edited_at': editedAt,
    };
  }

  TeamRole getUpgradeRole(){
    switch (role) {
      case TeamRole.USER:
        return TeamRole.ADMIN;
      case TeamRole.ADMIN:
        return TeamRole.ADMIN;
      case TeamRole.OWNER:
        return TeamRole.OWNER;
      case TeamRole.GUEST:
        return TeamRole.USER;
      case TeamRole.CANDIDATE:
        return TeamRole.USER;
      default:
        return role;
    }
  }

  TeamRole getDowngradeRole(){
    switch (role) {
      case TeamRole.USER:
        return TeamRole.GUEST;
      case TeamRole.ADMIN:
        return TeamRole.USER;
      case TeamRole.OWNER:
        return TeamRole.OWNER;
      case TeamRole.GUEST:
        return TeamRole.GUEST;
      case TeamRole.CANDIDATE:
        return TeamRole.CANDIDATE;
      default:
        return role;
    }
  }

  @override
  String toString() {
    return 'TeamsUser{id: $id, teamId: $teamId, userId: $userId, role: $role, editedAt: $editedAt, createdAt: $createdAt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamsUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          teamId == other.teamId &&
          userId == other.userId &&
          role == other.role &&
          editedAt == other.editedAt &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      teamId.hashCode ^
      userId.hashCode ^
      role.hashCode ^
      editedAt.hashCode ^
      createdAt.hashCode;

  static List<TeamsUser> fromJsonList(List<dynamic> json) {
    return json.map((e) => TeamsUser.fromJson(e)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<TeamsUser> teamsUser) {
    return teamsUser.map((e) => e.toJson()).toList();
  }

  static List<Map<String, dynamic>> toUpdateJsonList(List<TeamsUser> teamsUser) {
    return teamsUser.map((e) => e.toUpdateJson()).toList();
  }

  static List<TeamsUser> copyList(List<TeamsUser> teamsUser) {
    return teamsUser.map((e) => e.copyWith()).toList();
  }

  static List<TeamsUser> copyListWith(List<TeamsUser> teamsUser, {String? id, String? teamId, String? userId, TeamRole? role, String? editedAt, String? createdAt , User? user}) {
    return teamsUser.map((e) => e.copyWith(id: id, teamId: teamId, userId: userId, role: role, editedAt: editedAt, createdAt: createdAt , user: user)).toList();
  }

  static List<TeamsUser> copyListFromJson(List<dynamic> json) {
    return json.map((e) => TeamsUser.fromJson(e)).toList();
  }

  
  



}
