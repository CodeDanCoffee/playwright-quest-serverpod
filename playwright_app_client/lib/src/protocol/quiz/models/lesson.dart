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
import '../../quiz/models/question.dart' as _iww4bzdm;

/// A lesson: a short concept card followed by a quiz.
abstract class Lesson
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Lesson._({
    required this.id,
    required this.tierId,
    required this.order,
    required this.title,
    required this.summary,
    required this.conceptTitle,
    required this.conceptBody,
    this.conceptCode,
    this.proTip,
    required this.questionCount,
    this.questions,
  });

  factory Lesson({
    required String id,
    required String tierId,
    required int order,
    required String title,
    required String summary,
    required String conceptTitle,
    required String conceptBody,
    String? conceptCode,
    String? proTip,
    required int questionCount,
    List<_iww4bzdm.Question>? questions,
  }) = _LessonImpl;

  factory Lesson.fromJson(Map<String, dynamic> jsonSerialization) {
    return Lesson(
      id: jsonSerialization['id'] as String,
      tierId: jsonSerialization['tierId'] as String,
      order: jsonSerialization['order'] as int,
      title: jsonSerialization['title'] as String,
      summary: jsonSerialization['summary'] as String,
      conceptTitle: jsonSerialization['conceptTitle'] as String,
      conceptBody: jsonSerialization['conceptBody'] as String,
      conceptCode: jsonSerialization['conceptCode'] as String?,
      proTip: jsonSerialization['proTip'] as String?,
      questionCount: jsonSerialization['questionCount'] as int,
      questions: jsonSerialization['questions'] == null
          ? null
          : _i5c00drz.Protocol().deserialize<List<_iww4bzdm.Question>>(
              jsonSerialization['questions'],
            ),
    );
  }

  /// Stable identifier, e.g. `b1`.
  String id;

  String tierId;

  /// Position in the overall learning path (0-based).
  int order;

  String title;

  /// One-line teaser shown on the map.
  String summary;

  /// Title of the concept card shown before the quiz.
  String conceptTitle;

  /// Body of the concept card, in plain text with paragraphs.
  String conceptBody;

  /// Example code for the concept card.
  String? conceptCode;

  /// A practical tip to take into real projects.
  String? proTip;

  int questionCount;

  /// Only included when a single lesson is fetched.
  List<_iww4bzdm.Question>? questions;

  /// Returns a shallow copy of this [Lesson]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Lesson copyWith({
    String? id,
    String? tierId,
    int? order,
    String? title,
    String? summary,
    String? conceptTitle,
    String? conceptBody,
    String? conceptCode,
    String? proTip,
    int? questionCount,
    List<_iww4bzdm.Question>? questions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Lesson',
      'id': id,
      'tierId': tierId,
      'order': order,
      'title': title,
      'summary': summary,
      'conceptTitle': conceptTitle,
      'conceptBody': conceptBody,
      if (conceptCode != null) 'conceptCode': conceptCode,
      if (proTip != null) 'proTip': proTip,
      'questionCount': questionCount,
      if (questions != null)
        'questions': questions?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Lesson',
      'id': id,
      'tierId': tierId,
      'order': order,
      'title': title,
      'summary': summary,
      'conceptTitle': conceptTitle,
      'conceptBody': conceptBody,
      if (conceptCode != null) 'conceptCode': conceptCode,
      if (proTip != null) 'proTip': proTip,
      'questionCount': questionCount,
      if (questions != null)
        'questions': questions?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LessonImpl extends Lesson {
  _LessonImpl({
    required String id,
    required String tierId,
    required int order,
    required String title,
    required String summary,
    required String conceptTitle,
    required String conceptBody,
    String? conceptCode,
    String? proTip,
    required int questionCount,
    List<_iww4bzdm.Question>? questions,
  }) : super._(
         id: id,
         tierId: tierId,
         order: order,
         title: title,
         summary: summary,
         conceptTitle: conceptTitle,
         conceptBody: conceptBody,
         conceptCode: conceptCode,
         proTip: proTip,
         questionCount: questionCount,
         questions: questions,
       );

  /// Returns a shallow copy of this [Lesson]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Lesson copyWith({
    String? id,
    String? tierId,
    int? order,
    String? title,
    String? summary,
    String? conceptTitle,
    String? conceptBody,
    Object? conceptCode = _Undefined,
    Object? proTip = _Undefined,
    int? questionCount,
    Object? questions = _Undefined,
  }) {
    return Lesson(
      id: id ?? this.id,
      tierId: tierId ?? this.tierId,
      order: order ?? this.order,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      conceptTitle: conceptTitle ?? this.conceptTitle,
      conceptBody: conceptBody ?? this.conceptBody,
      conceptCode: conceptCode is String? ? conceptCode : this.conceptCode,
      proTip: proTip is String? ? proTip : this.proTip,
      questionCount: questionCount ?? this.questionCount,
      questions: questions is List<_iww4bzdm.Question>?
          ? questions
          : this.questions?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
