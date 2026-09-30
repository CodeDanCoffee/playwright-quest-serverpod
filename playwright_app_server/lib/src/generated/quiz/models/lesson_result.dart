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
import 'package:playwright_app_server/src/generated/protocol.dart' as _i9sfwcd2;
import 'package:serverpod/serverpod.dart' as _is;
import '../../quiz/models/player_stats.dart' as _itsztrci;

/// The outcome of submitting a finished lesson.
abstract class LessonResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LessonResult._({
    required this.lessonId,
    required this.correct,
    required this.total,
    required this.stars,
    required this.xpEarned,
    required this.isNewBest,
    this.unlockedLessonId,
    required this.stats,
  });

  factory LessonResult({
    required String lessonId,
    required int correct,
    required int total,
    required int stars,
    required int xpEarned,
    required bool isNewBest,
    String? unlockedLessonId,
    required _itsztrci.PlayerStats stats,
  }) = _LessonResultImpl;

  factory LessonResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return LessonResult(
      lessonId: jsonSerialization['lessonId'] as String,
      correct: jsonSerialization['correct'] as int,
      total: jsonSerialization['total'] as int,
      stars: jsonSerialization['stars'] as int,
      xpEarned: jsonSerialization['xpEarned'] as int,
      isNewBest: _is.BoolJsonExtension.fromJson(jsonSerialization['isNewBest']),
      unlockedLessonId: jsonSerialization['unlockedLessonId'] as String?,
      stats: _i9sfwcd2.Protocol().deserialize<_itsztrci.PlayerStats>(
        jsonSerialization['stats'],
      ),
    );
  }

  String lessonId;

  int correct;

  int total;

  int stars;

  int xpEarned;

  bool isNewBest;

  /// The lesson unlocked by this attempt, if any.
  String? unlockedLessonId;

  _itsztrci.PlayerStats stats;

  /// Returns a shallow copy of this [LessonResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LessonResult copyWith({
    String? lessonId,
    int? correct,
    int? total,
    int? stars,
    int? xpEarned,
    bool? isNewBest,
    String? unlockedLessonId,
    _itsztrci.PlayerStats? stats,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LessonResult',
      'lessonId': lessonId,
      'correct': correct,
      'total': total,
      'stars': stars,
      'xpEarned': xpEarned,
      'isNewBest': isNewBest,
      if (unlockedLessonId != null) 'unlockedLessonId': unlockedLessonId,
      'stats': stats.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LessonResult',
      'lessonId': lessonId,
      'correct': correct,
      'total': total,
      'stars': stars,
      'xpEarned': xpEarned,
      'isNewBest': isNewBest,
      if (unlockedLessonId != null) 'unlockedLessonId': unlockedLessonId,
      'stats': stats.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LessonResultImpl extends LessonResult {
  _LessonResultImpl({
    required String lessonId,
    required int correct,
    required int total,
    required int stars,
    required int xpEarned,
    required bool isNewBest,
    String? unlockedLessonId,
    required _itsztrci.PlayerStats stats,
  }) : super._(
         lessonId: lessonId,
         correct: correct,
         total: total,
         stars: stars,
         xpEarned: xpEarned,
         isNewBest: isNewBest,
         unlockedLessonId: unlockedLessonId,
         stats: stats,
       );

  /// Returns a shallow copy of this [LessonResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LessonResult copyWith({
    String? lessonId,
    int? correct,
    int? total,
    int? stars,
    int? xpEarned,
    bool? isNewBest,
    Object? unlockedLessonId = _Undefined,
    _itsztrci.PlayerStats? stats,
  }) {
    return LessonResult(
      lessonId: lessonId ?? this.lessonId,
      correct: correct ?? this.correct,
      total: total ?? this.total,
      stars: stars ?? this.stars,
      xpEarned: xpEarned ?? this.xpEarned,
      isNewBest: isNewBest ?? this.isNewBest,
      unlockedLessonId: unlockedLessonId is String?
          ? unlockedLessonId
          : this.unlockedLessonId,
      stats: stats ?? this.stats.copyWith(),
    );
  }
}
