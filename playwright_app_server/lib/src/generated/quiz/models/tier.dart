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
import '../../quiz/models/lesson.dart' as _iwl56hxb;

/// A difficulty tier (Beginner to Expert) grouping several lessons.
abstract class Tier
    implements _is.SerializableModel, _is.ProtocolSerialization {
  Tier._({
    required this.id,
    required this.order,
    required this.difficulty,
    required this.title,
    required this.description,
    required this.lessons,
  });

  factory Tier({
    required String id,
    required int order,
    required String difficulty,
    required String title,
    required String description,
    required List<_iwl56hxb.Lesson> lessons,
  }) = _TierImpl;

  factory Tier.fromJson(Map<String, dynamic> jsonSerialization) {
    return Tier(
      id: jsonSerialization['id'] as String,
      order: jsonSerialization['order'] as int,
      difficulty: jsonSerialization['difficulty'] as String,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      lessons: _i9sfwcd2.Protocol().deserialize<List<_iwl56hxb.Lesson>>(
        jsonSerialization['lessons'],
      ),
    );
  }

  String id;

  int order;

  /// e.g. `Beginner`.
  String difficulty;

  /// Theatrical name, e.g. `Act I · Rehearsal`.
  String title;

  String description;

  List<_iwl56hxb.Lesson> lessons;

  /// Returns a shallow copy of this [Tier]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Tier copyWith({
    String? id,
    int? order,
    String? difficulty,
    String? title,
    String? description,
    List<_iwl56hxb.Lesson>? lessons,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Tier',
      'id': id,
      'order': order,
      'difficulty': difficulty,
      'title': title,
      'description': description,
      'lessons': lessons.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Tier',
      'id': id,
      'order': order,
      'difficulty': difficulty,
      'title': title,
      'description': description,
      'lessons': lessons.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _TierImpl extends Tier {
  _TierImpl({
    required String id,
    required int order,
    required String difficulty,
    required String title,
    required String description,
    required List<_iwl56hxb.Lesson> lessons,
  }) : super._(
         id: id,
         order: order,
         difficulty: difficulty,
         title: title,
         description: description,
         lessons: lessons,
       );

  /// Returns a shallow copy of this [Tier]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Tier copyWith({
    String? id,
    int? order,
    String? difficulty,
    String? title,
    String? description,
    List<_iwl56hxb.Lesson>? lessons,
  }) {
    return Tier(
      id: id ?? this.id,
      order: order ?? this.order,
      difficulty: difficulty ?? this.difficulty,
      title: title ?? this.title,
      description: description ?? this.description,
      lessons: lessons ?? this.lessons.map((e0) => e0.copyWith()).toList(),
    );
  }
}
