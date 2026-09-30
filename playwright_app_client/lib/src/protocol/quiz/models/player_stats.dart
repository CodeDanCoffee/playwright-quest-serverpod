/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:playwright_app_client/src/protocol/protocol.dart' as _i5c00drz;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// Aggregated game stats for a player.
abstract class PlayerStats
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PlayerStats._({
    this.id,
    required this.authUserId,
    this.authUser,
    int? xp,
    int? currentStreak,
    int? longestStreak,
    this.lastPlayedAt,
  }) : xp = xp ?? 0,
       currentStreak = currentStreak ?? 0,
       longestStreak = longestStreak ?? 0;

  factory PlayerStats({
    int? id,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    int? xp,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastPlayedAt,
  }) = _PlayerStatsImpl;

  factory PlayerStats.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlayerStats(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i5c00drz.Protocol().deserialize<_iacc.AuthUser>(
              jsonSerialization['authUser'],
            ),
      xp: jsonSerialization['xp'] as int?,
      currentStreak: jsonSerialization['currentStreak'] as int?,
      longestStreak: jsonSerialization['longestStreak'] as int?,
      lastPlayedAt: jsonSerialization['lastPlayedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastPlayedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  _iacc.AuthUser? authUser;

  int xp;

  /// Consecutive days (UTC) with at least one finished lesson.
  int currentStreak;

  int longestStreak;

  DateTime? lastPlayedAt;

  /// Returns a shallow copy of this [PlayerStats]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PlayerStats copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    _iacc.AuthUser? authUser,
    int? xp,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastPlayedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlayerStats',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'xp': xp,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      if (lastPlayedAt != null) 'lastPlayedAt': lastPlayedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlayerStats',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'xp': xp,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      if (lastPlayedAt != null) 'lastPlayedAt': lastPlayedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlayerStatsImpl extends PlayerStats {
  _PlayerStatsImpl({
    int? id,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    int? xp,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastPlayedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         xp: xp,
         currentStreak: currentStreak,
         longestStreak: longestStreak,
         lastPlayedAt: lastPlayedAt,
       );

  /// Returns a shallow copy of this [PlayerStats]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PlayerStats copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    Object? authUser = _Undefined,
    int? xp,
    int? currentStreak,
    int? longestStreak,
    Object? lastPlayedAt = _Undefined,
  }) {
    return PlayerStats(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacc.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      xp: xp ?? this.xp,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastPlayedAt: lastPlayedAt is DateTime?
          ? lastPlayedAt
          : this.lastPlayedAt,
    );
  }
}
