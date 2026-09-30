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
import '../../quiz/models/question_type.dart' as _inxd09w6;

/// A single quiz question in a lesson.
abstract class Question
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Question._({
    required this.id,
    required this.type,
    required this.prompt,
    this.code,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.hint,
  });

  factory Question({
    required String id,
    required _inxd09w6.QuestionType type,
    required String prompt,
    String? code,
    required List<String> options,
    required int correctIndex,
    required String explanation,
    String? hint,
  }) = _QuestionImpl;

  factory Question.fromJson(Map<String, dynamic> jsonSerialization) {
    return Question(
      id: jsonSerialization['id'] as String,
      type: _inxd09w6.QuestionType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      prompt: jsonSerialization['prompt'] as String,
      code: jsonSerialization['code'] as String?,
      options: _i5c00drz.Protocol().deserialize<List<String>>(
        jsonSerialization['options'],
      ),
      correctIndex: jsonSerialization['correctIndex'] as int,
      explanation: jsonSerialization['explanation'] as String,
      hint: jsonSerialization['hint'] as String?,
    );
  }

  /// Stable identifier, e.g. `b1-q3`.
  String id;

  _inxd09w6.QuestionType type;

  /// The question text.
  String prompt;

  /// Optional code snippet shown with the question. `____` marks a blank.
  String? code;

  /// The answer options.
  List<String> options;

  /// Index into [options] of the correct answer.
  int correctIndex;

  /// Why the answer is correct, shown after answering.
  String explanation;

  /// An optional nudge shown when the player asks for a hint.
  String? hint;

  /// Returns a shallow copy of this [Question]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Question copyWith({
    String? id,
    _inxd09w6.QuestionType? type,
    String? prompt,
    String? code,
    List<String>? options,
    int? correctIndex,
    String? explanation,
    String? hint,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Question',
      'id': id,
      'type': type.toJson(),
      'prompt': prompt,
      if (code != null) 'code': code,
      'options': options.toJson(),
      'correctIndex': correctIndex,
      'explanation': explanation,
      if (hint != null) 'hint': hint,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Question',
      'id': id,
      'type': type.toJson(),
      'prompt': prompt,
      if (code != null) 'code': code,
      'options': options.toJson(),
      'correctIndex': correctIndex,
      'explanation': explanation,
      if (hint != null) 'hint': hint,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QuestionImpl extends Question {
  _QuestionImpl({
    required String id,
    required _inxd09w6.QuestionType type,
    required String prompt,
    String? code,
    required List<String> options,
    required int correctIndex,
    required String explanation,
    String? hint,
  }) : super._(
         id: id,
         type: type,
         prompt: prompt,
         code: code,
         options: options,
         correctIndex: correctIndex,
         explanation: explanation,
         hint: hint,
       );

  /// Returns a shallow copy of this [Question]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Question copyWith({
    String? id,
    _inxd09w6.QuestionType? type,
    String? prompt,
    Object? code = _Undefined,
    List<String>? options,
    int? correctIndex,
    String? explanation,
    Object? hint = _Undefined,
  }) {
    return Question(
      id: id ?? this.id,
      type: type ?? this.type,
      prompt: prompt ?? this.prompt,
      code: code is String? ? code : this.code,
      options: options ?? this.options.map((e0) => e0).toList(),
      correctIndex: correctIndex ?? this.correctIndex,
      explanation: explanation ?? this.explanation,
      hint: hint is String? ? hint : this.hint,
    );
  }
}
