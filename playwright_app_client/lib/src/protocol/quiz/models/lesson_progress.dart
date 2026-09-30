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

/// A player's best result for a lesson.
abstract class LessonProgress
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LessonProgress._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.lessonId,
    required this.bestCorrect,
    required this.total,
    required this.stars,
    required this.attempts,
    required this.lastPlayedAt,
  });

  factory LessonProgress({
    int? id,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    required String lessonId,
    required int bestCorrect,
    required int total,
    required int stars,
    required int attempts,
    required DateTime lastPlayedAt,
  }) = _LessonProgressImpl;

  factory LessonProgress.fromJson(Map<String, dynamic> jsonSerialization) {
    return LessonProgress(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i5c00drz.Protocol().deserialize<_iacc.AuthUser>(
              jsonSerialization['authUser'],
            ),
      lessonId: jsonSerialization['lessonId'] as String,
      bestCorrect: jsonSerialization['bestCorrect'] as int,
      total: jsonSerialization['total'] as int,
      stars: jsonSerialization['stars'] as int,
      attempts: jsonSerialization['attempts'] as int,
      lastPlayedAt: _isc.DateTimeJsonExtension.fromJson(
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

  String lessonId;

  int bestCorrect;

  int total;

  /// 0 to 3 stars for the best attempt.
  int stars;

  int attempts;

  DateTime lastPlayedAt;

  /// Returns a shallow copy of this [LessonProgress]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LessonProgress copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    _iacc.AuthUser? authUser,
    String? lessonId,
    int? bestCorrect,
    int? total,
    int? stars,
    int? attempts,
    DateTime? lastPlayedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LessonProgress',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'lessonId': lessonId,
      'bestCorrect': bestCorrect,
      'total': total,
      'stars': stars,
      'attempts': attempts,
      'lastPlayedAt': lastPlayedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LessonProgress',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'lessonId': lessonId,
      'bestCorrect': bestCorrect,
      'total': total,
      'stars': stars,
      'attempts': attempts,
      'lastPlayedAt': lastPlayedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LessonProgressImpl extends LessonProgress {
  _LessonProgressImpl({
    int? id,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    required String lessonId,
    required int bestCorrect,
    required int total,
    required int stars,
    required int attempts,
    required DateTime lastPlayedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         lessonId: lessonId,
         bestCorrect: bestCorrect,
         total: total,
         stars: stars,
         attempts: attempts,
         lastPlayedAt: lastPlayedAt,
       );

  /// Returns a shallow copy of this [LessonProgress]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LessonProgress copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? lessonId,
    int? bestCorrect,
    int? total,
    int? stars,
    int? attempts,
    DateTime? lastPlayedAt,
  }) {
    return LessonProgress(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacc.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      lessonId: lessonId ?? this.lessonId,
      bestCorrect: bestCorrect ?? this.bestCorrect,
      total: total ?? this.total,
      stars: stars ?? this.stars,
      attempts: attempts ?? this.attempts,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
    );
  }
}
