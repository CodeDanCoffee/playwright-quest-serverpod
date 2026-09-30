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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../quiz/models/lesson_progress.dart' as _i6oi7n40;
import '../../quiz/models/player_stats.dart' as _itsztrci;

/// Everything the app needs to render the player's journey.
abstract class PlayerProgress
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PlayerProgress._({
    required this.stats,
    required this.lessons,
    required this.unlockedLessonIds,
  });

  factory PlayerProgress({
    required _itsztrci.PlayerStats stats,
    required List<_i6oi7n40.LessonProgress> lessons,
    required List<String> unlockedLessonIds,
  }) = _PlayerProgressImpl;

  factory PlayerProgress.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlayerProgress(
      stats: _i5c00drz.Protocol().deserialize<_itsztrci.PlayerStats>(
        jsonSerialization['stats'],
      ),
      lessons: _i5c00drz.Protocol().deserialize<List<_i6oi7n40.LessonProgress>>(
        jsonSerialization['lessons'],
      ),
      unlockedLessonIds: _i5c00drz.Protocol().deserialize<List<String>>(
        jsonSerialization['unlockedLessonIds'],
      ),
    );
  }

  _itsztrci.PlayerStats stats;

  List<_i6oi7n40.LessonProgress> lessons;

  /// Ids of lessons the player may play.
  List<String> unlockedLessonIds;

  /// Returns a shallow copy of this [PlayerProgress]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PlayerProgress copyWith({
    _itsztrci.PlayerStats? stats,
    List<_i6oi7n40.LessonProgress>? lessons,
    List<String>? unlockedLessonIds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlayerProgress',
      'stats': stats.toJson(),
      'lessons': lessons.toJson(valueToJson: (v) => v.toJson()),
      'unlockedLessonIds': unlockedLessonIds.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlayerProgress',
      'stats': stats.toJsonForProtocol(),
      'lessons': lessons.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'unlockedLessonIds': unlockedLessonIds.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _PlayerProgressImpl extends PlayerProgress {
  _PlayerProgressImpl({
    required _itsztrci.PlayerStats stats,
    required List<_i6oi7n40.LessonProgress> lessons,
    required List<String> unlockedLessonIds,
  }) : super._(
         stats: stats,
         lessons: lessons,
         unlockedLessonIds: unlockedLessonIds,
       );

  /// Returns a shallow copy of this [PlayerProgress]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PlayerProgress copyWith({
    _itsztrci.PlayerStats? stats,
    List<_i6oi7n40.LessonProgress>? lessons,
    List<String>? unlockedLessonIds,
  }) {
    return PlayerProgress(
      stats: stats ?? this.stats.copyWith(),
      lessons: lessons ?? this.lessons.map((e0) => e0.copyWith()).toList(),
      unlockedLessonIds:
          unlockedLessonIds ?? this.unlockedLessonIds.map((e0) => e0).toList(),
    );
  }
}
