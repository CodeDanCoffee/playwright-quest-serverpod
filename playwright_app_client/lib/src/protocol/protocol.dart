/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:playwright_app_client/src/protocol/quiz/models/tier.dart'
    as _iuolio2b;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'email_code/models/email_code_error_reason.dart' as _idavh3r5;
import 'email_code/models/email_code_login_exception.dart' as _icvkorls;
import 'email_code/models/email_code_sign_in.dart' as _ixik46of;
import 'quiz/models/lesson.dart' as _ie9f23zi;
import 'quiz/models/lesson_progress.dart' as _il5jp6pe;
import 'quiz/models/lesson_result.dart' as _i18gwwv5;
import 'quiz/models/player_progress.dart' as _ia71xc6h;
import 'quiz/models/player_stats.dart' as _ix91l851;
import 'quiz/models/question.dart' as _iok6p1jo;
import 'quiz/models/question_type.dart' as _iaugdg8q;
import 'quiz/models/quiz_exception.dart' as _is74f24v;
import 'quiz/models/tier.dart' as _ioba0ldi;
export 'email_code/models/email_code_error_reason.dart';
export 'email_code/models/email_code_login_exception.dart';
export 'email_code/models/email_code_sign_in.dart';
export 'quiz/models/lesson.dart';
export 'quiz/models/lesson_progress.dart';
export 'quiz/models/lesson_result.dart';
export 'quiz/models/player_progress.dart';
export 'quiz/models/player_stats.dart';
export 'quiz/models/question.dart';
export 'quiz/models/question_type.dart';
export 'quiz/models/quiz_exception.dart';
export 'quiz/models/tier.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _idavh3r5.EmailCodeErrorReason) {
      return _idavh3r5.EmailCodeErrorReason.fromJson(data) as T;
    }
    if (t == _icvkorls.EmailCodeLoginException) {
      return _icvkorls.EmailCodeLoginException.fromJson(data) as T;
    }
    if (t == _ixik46of.EmailCodeSignIn) {
      return _ixik46of.EmailCodeSignIn.fromJson(data) as T;
    }
    if (t == _ie9f23zi.Lesson) {
      return _ie9f23zi.Lesson.fromJson(data) as T;
    }
    if (t == _il5jp6pe.LessonProgress) {
      return _il5jp6pe.LessonProgress.fromJson(data) as T;
    }
    if (t == _i18gwwv5.LessonResult) {
      return _i18gwwv5.LessonResult.fromJson(data) as T;
    }
    if (t == _ia71xc6h.PlayerProgress) {
      return _ia71xc6h.PlayerProgress.fromJson(data) as T;
    }
    if (t == _ix91l851.PlayerStats) {
      return _ix91l851.PlayerStats.fromJson(data) as T;
    }
    if (t == _iok6p1jo.Question) {
      return _iok6p1jo.Question.fromJson(data) as T;
    }
    if (t == _iaugdg8q.QuestionType) {
      return _iaugdg8q.QuestionType.fromJson(data) as T;
    }
    if (t == _is74f24v.QuizException) {
      return _is74f24v.QuizException.fromJson(data) as T;
    }
    if (t == _ioba0ldi.Tier) {
      return _ioba0ldi.Tier.fromJson(data) as T;
    }
    if (t == _isc.getType<_idavh3r5.EmailCodeErrorReason?>()) {
      return (data != null
              ? _idavh3r5.EmailCodeErrorReason.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_icvkorls.EmailCodeLoginException?>()) {
      return (data != null
              ? _icvkorls.EmailCodeLoginException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ixik46of.EmailCodeSignIn?>()) {
      return (data != null ? _ixik46of.EmailCodeSignIn.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ie9f23zi.Lesson?>()) {
      return (data != null ? _ie9f23zi.Lesson.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_il5jp6pe.LessonProgress?>()) {
      return (data != null ? _il5jp6pe.LessonProgress.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i18gwwv5.LessonResult?>()) {
      return (data != null ? _i18gwwv5.LessonResult.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ia71xc6h.PlayerProgress?>()) {
      return (data != null ? _ia71xc6h.PlayerProgress.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ix91l851.PlayerStats?>()) {
      return (data != null ? _ix91l851.PlayerStats.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iok6p1jo.Question?>()) {
      return (data != null ? _iok6p1jo.Question.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iaugdg8q.QuestionType?>()) {
      return (data != null ? _iaugdg8q.QuestionType.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_is74f24v.QuizException?>()) {
      return (data != null ? _is74f24v.QuizException.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ioba0ldi.Tier?>()) {
      return (data != null ? _ioba0ldi.Tier.fromJson(data) : null) as T;
    }
    if (t == List<_iok6p1jo.Question>) {
      return (data as List)
              .map((e) => deserialize<_iok6p1jo.Question>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_iok6p1jo.Question>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_iok6p1jo.Question>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_il5jp6pe.LessonProgress>) {
      return (data as List)
              .map((e) => deserialize<_il5jp6pe.LessonProgress>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_ie9f23zi.Lesson>) {
      return (data as List)
              .map((e) => deserialize<_ie9f23zi.Lesson>(e))
              .toList()
          as T;
    }
    if (t == List<_iuolio2b.Tier>) {
      return (data as List).map((e) => deserialize<_iuolio2b.Tier>(e)).toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _idavh3r5.EmailCodeErrorReason => 'EmailCodeErrorReason',
      _icvkorls.EmailCodeLoginException => 'EmailCodeLoginException',
      _ixik46of.EmailCodeSignIn => 'EmailCodeSignIn',
      _ie9f23zi.Lesson => 'Lesson',
      _il5jp6pe.LessonProgress => 'LessonProgress',
      _i18gwwv5.LessonResult => 'LessonResult',
      _ia71xc6h.PlayerProgress => 'PlayerProgress',
      _ix91l851.PlayerStats => 'PlayerStats',
      _iok6p1jo.Question => 'Question',
      _iaugdg8q.QuestionType => 'QuestionType',
      _is74f24v.QuizException => 'QuizException',
      _ioba0ldi.Tier => 'Tier',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'playwright_app.',
        '',
      );
    }

    switch (data) {
      case _idavh3r5.EmailCodeErrorReason():
        return 'EmailCodeErrorReason';
      case _icvkorls.EmailCodeLoginException():
        return 'EmailCodeLoginException';
      case _ixik46of.EmailCodeSignIn():
        return 'EmailCodeSignIn';
      case _ie9f23zi.Lesson():
        return 'Lesson';
      case _il5jp6pe.LessonProgress():
        return 'LessonProgress';
      case _i18gwwv5.LessonResult():
        return 'LessonResult';
      case _ia71xc6h.PlayerProgress():
        return 'PlayerProgress';
      case _ix91l851.PlayerStats():
        return 'PlayerStats';
      case _iok6p1jo.Question():
        return 'Question';
      case _iaugdg8q.QuestionType():
        return 'QuestionType';
      case _is74f24v.QuizException():
        return 'QuizException';
      case _ioba0ldi.Tier():
        return 'Tier';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'EmailCodeErrorReason') {
      return deserialize<_idavh3r5.EmailCodeErrorReason>(data['data']);
    }
    if (dataClassName == 'EmailCodeLoginException') {
      return deserialize<_icvkorls.EmailCodeLoginException>(data['data']);
    }
    if (dataClassName == 'EmailCodeSignIn') {
      return deserialize<_ixik46of.EmailCodeSignIn>(data['data']);
    }
    if (dataClassName == 'Lesson') {
      return deserialize<_ie9f23zi.Lesson>(data['data']);
    }
    if (dataClassName == 'LessonProgress') {
      return deserialize<_il5jp6pe.LessonProgress>(data['data']);
    }
    if (dataClassName == 'LessonResult') {
      return deserialize<_i18gwwv5.LessonResult>(data['data']);
    }
    if (dataClassName == 'PlayerProgress') {
      return deserialize<_ia71xc6h.PlayerProgress>(data['data']);
    }
    if (dataClassName == 'PlayerStats') {
      return deserialize<_ix91l851.PlayerStats>(data['data']);
    }
    if (dataClassName == 'Question') {
      return deserialize<_iok6p1jo.Question>(data['data']);
    }
    if (dataClassName == 'QuestionType') {
      return deserialize<_iaugdg8q.QuestionType>(data['data']);
    }
    if (dataClassName == 'QuizException') {
      return deserialize<_is74f24v.QuizException>(data['data']);
    }
    if (dataClassName == 'Tier') {
      return deserialize<_ioba0ldi.Tier>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('playwright_app', this);
    _iacc.Protocol().registerHostProtocol('playwright_app', this);
  }

  @override
  String getModuleName() => 'playwright_app';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
