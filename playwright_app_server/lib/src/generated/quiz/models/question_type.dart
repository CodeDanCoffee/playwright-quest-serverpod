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
import 'package:serverpod/serverpod.dart' as _is;

/// The style of a quiz question, used by the app to label and render it.
enum QuestionType implements _is.SerializableModel {
  multipleChoice,
  trueFalse,
  fillTheBlank;

  static QuestionType fromJson(String name) {
    switch (name) {
      case 'multipleChoice':
        return QuestionType.multipleChoice;
      case 'trueFalse':
        return QuestionType.trueFalse;
      case 'fillTheBlank':
        return QuestionType.fillTheBlank;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "QuestionType"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
