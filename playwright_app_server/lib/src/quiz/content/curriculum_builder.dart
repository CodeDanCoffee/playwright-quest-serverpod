import '../../generated/protocol.dart';

/// Small helpers that keep the curriculum files readable.

Question mc(
  String id,
  String prompt, {
  String? code,
  required List<String> options,
  required int answer,
  required String explain,
  String? hint,
}) => Question(
  id: id,
  type: QuestionType.multipleChoice,
  prompt: prompt,
  code: code,
  options: options,
  correctIndex: answer,
  explanation: explain,
  hint: hint,
);

Question tf(
  String id,
  String statement, {
  String? code,
  required bool answer,
  required String explain,
  String? hint,
}) => Question(
  id: id,
  type: QuestionType.trueFalse,
  prompt: statement,
  code: code,
  options: const ['True', 'False'],
  correctIndex: answer ? 0 : 1,
  explanation: explain,
  hint: hint,
);

/// A fill-the-blank question. [code] must contain `____`.
Question blank(
  String id,
  String prompt, {
  required String code,
  required List<String> options,
  required int answer,
  required String explain,
  String? hint,
}) {
  assert(code.contains('____'), 'Blank question $id has no ____ in code');
  return Question(
    id: id,
    type: QuestionType.fillTheBlank,
    prompt: prompt,
    code: code,
    options: options,
    correctIndex: answer,
    explanation: explain,
    hint: hint,
  );
}

Lesson lesson(
  String id, {
  required String title,
  required String summary,
  required String conceptTitle,
  required String conceptBody,
  String? conceptCode,
  String? proTip,
  required List<Question> questions,
}) => Lesson(
  id: id,
  tierId: '',
  order: 0,
  title: title,
  summary: summary,
  conceptTitle: conceptTitle,
  conceptBody: conceptBody,
  conceptCode: conceptCode,
  proTip: proTip,
  questionCount: questions.length,
  questions: questions,
);
