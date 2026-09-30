/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:playwright_app_server/src/generated/protocol.dart' as _i9sfwcd2;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;

/// A player's best result for a lesson.
abstract class LessonProgress
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
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
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i9sfwcd2.Protocol().deserialize<_iacs.AuthUser>(
              jsonSerialization['authUser'],
            ),
      lessonId: jsonSerialization['lessonId'] as String,
      bestCorrect: jsonSerialization['bestCorrect'] as int,
      total: jsonSerialization['total'] as int,
      stars: jsonSerialization['stars'] as int,
      attempts: jsonSerialization['attempts'] as int,
      lastPlayedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastPlayedAt'],
      ),
    );
  }

  static final t = LessonProgressTable();

  static const db = LessonProgressRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  _iacs.AuthUser? authUser;

  String lessonId;

  int bestCorrect;

  int total;

  /// 0 to 3 stars for the best attempt.
  int stars;

  int attempts;

  DateTime lastPlayedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [LessonProgress]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LessonProgress copyWith({
    int? id,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
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

  static LessonProgressInclude include({_iacs.AuthUserInclude? authUser}) {
    return LessonProgressInclude._(authUser: authUser);
  }

  static LessonProgressIncludeList includeList({
    _is.WhereExpressionBuilder<LessonProgressTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LessonProgressTable>? orderBy,
    _is.OrderByListBuilder<LessonProgressTable>? orderByList,
    LessonProgressInclude? include,
  }) {
    return LessonProgressIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LessonProgress.t),
      orderByList: orderByList?.call(LessonProgress.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LessonProgressImpl extends LessonProgress {
  _LessonProgressImpl({
    int? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
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
  @_is.useResult
  @override
  LessonProgress copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
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
      authUser: authUser is _iacs.AuthUser?
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

class LessonProgressUpdateTable extends _is.UpdateTable<LessonProgressTable> {
  LessonProgressUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> lessonId(String value) => _is.ColumnValue(
    table.lessonId,
    value,
  );

  _is.ColumnValue<int, int> bestCorrect(int value) => _is.ColumnValue(
    table.bestCorrect,
    value,
  );

  _is.ColumnValue<int, int> total(int value) => _is.ColumnValue(
    table.total,
    value,
  );

  _is.ColumnValue<int, int> stars(int value) => _is.ColumnValue(
    table.stars,
    value,
  );

  _is.ColumnValue<int, int> attempts(int value) => _is.ColumnValue(
    table.attempts,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> lastPlayedAt(DateTime value) =>
      _is.ColumnValue(
        table.lastPlayedAt,
        value,
      );
}

class LessonProgressTable extends _is.Table<int?> {
  LessonProgressTable({super.tableRelation})
    : super(tableName: 'lesson_progress') {
    updateTable = LessonProgressUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    lessonId = _is.ColumnString(
      'lessonId',
      this,
    );
    bestCorrect = _is.ColumnInt(
      'bestCorrect',
      this,
    );
    total = _is.ColumnInt(
      'total',
      this,
    );
    stars = _is.ColumnInt(
      'stars',
      this,
    );
    attempts = _is.ColumnInt(
      'attempts',
      this,
    );
    lastPlayedAt = _is.ColumnDateTime(
      'lastPlayedAt',
      this,
    );
  }

  late final LessonProgressUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  _iacs.AuthUserTable? _authUser;

  late final _is.ColumnString lessonId;

  late final _is.ColumnInt bestCorrect;

  late final _is.ColumnInt total;

  /// 0 to 3 stars for the best attempt.
  late final _is.ColumnInt stars;

  late final _is.ColumnInt attempts;

  late final _is.ColumnDateTime lastPlayedAt;

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: LessonProgress.t.authUserId,
      foreignField: _iacs.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iacs.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    lessonId,
    bestCorrect,
    total,
    stars,
    attempts,
    lastPlayedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class LessonProgressInclude extends _is.IncludeObject {
  LessonProgressInclude._({_iacs.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _iacs.AuthUserInclude? _authUser;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<int?> get table => LessonProgress.t;
}

class LessonProgressIncludeList extends _is.IncludeList {
  LessonProgressIncludeList._({
    _is.WhereExpressionBuilder<LessonProgressTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LessonProgress.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => LessonProgress.t;
}

class LessonProgressRepository {
  const LessonProgressRepository._();

  final attachRow = const LessonProgressAttachRowRepository._();

  /// Returns a list of [LessonProgress]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<LessonProgress>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LessonProgressTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LessonProgressTable>? orderBy,
    _is.OrderByListBuilder<LessonProgressTable>? orderByList,
    _is.Transaction? transaction,
    LessonProgressInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LessonProgress>(
      where: where?.call(LessonProgress.t),
      orderBy: orderBy?.call(LessonProgress.t),
      orderByList: orderByList?.call(LessonProgress.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [LessonProgress] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<LessonProgress?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LessonProgressTable>? where,
    int? offset,
    _is.OrderByBuilder<LessonProgressTable>? orderBy,
    _is.OrderByListBuilder<LessonProgressTable>? orderByList,
    _is.Transaction? transaction,
    LessonProgressInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LessonProgress>(
      where: where?.call(LessonProgress.t),
      orderBy: orderBy?.call(LessonProgress.t),
      orderByList: orderByList?.call(LessonProgress.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LessonProgress] by its [id] or null if no such row exists.
  Future<LessonProgress?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    LessonProgressInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LessonProgress>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LessonProgress]s in the list and returns the inserted rows.
  ///
  /// The returned [LessonProgress]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LessonProgress>> insert(
    _is.DatabaseSession session,
    List<LessonProgress> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<LessonProgress>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [LessonProgress] and returns the inserted row.
  ///
  /// The returned [LessonProgress] will have its `id` field set.
  Future<LessonProgress> insertRow(
    _is.DatabaseSession session,
    LessonProgress row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<LessonProgress>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [LessonProgress]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [LessonProgress]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LessonProgress>> upsert(
    _is.DatabaseSession session,
    List<LessonProgress> rows, {
    required _is.ColumnSelections<LessonProgressTable> conflictColumns,
    _is.ColumnSelections<LessonProgressTable>? updateColumns,
    _is.WhereExpressionBuilder<LessonProgressTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<LessonProgress>(
      rows,
      conflictColumns: conflictColumns(LessonProgress.t),
      updateColumns: updateColumns?.call(LessonProgress.t),
      updateWhere: updateWhere?.call(LessonProgress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [LessonProgress] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [LessonProgress] will have its `id` field set.
  Future<LessonProgress?> upsertRow(
    _is.DatabaseSession session,
    LessonProgress row, {
    required _is.ColumnSelections<LessonProgressTable> conflictColumns,
    _is.ColumnSelections<LessonProgressTable>? updateColumns,
    _is.WhereExpressionBuilder<LessonProgressTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<LessonProgress>(
      row,
      conflictColumns: conflictColumns(LessonProgress.t),
      updateColumns: updateColumns?.call(LessonProgress.t),
      updateWhere: updateWhere?.call(LessonProgress.t),
      transaction: transaction,
    );
  }

  /// Updates all [LessonProgress]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LessonProgress>> update(
    _is.DatabaseSession session,
    List<LessonProgress> rows, {
    _is.ColumnSelections<LessonProgressTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<LessonProgress>(
      rows,
      columns: columns?.call(LessonProgress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [LessonProgress]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LessonProgress> updateRow(
    _is.DatabaseSession session,
    LessonProgress row, {
    _is.ColumnSelections<LessonProgressTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<LessonProgress>(
      row,
      columns: columns?.call(LessonProgress.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LessonProgress] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LessonProgress?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<LessonProgressUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<LessonProgress>(
      id,
      columnValues: columnValues(LessonProgress.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LessonProgress]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LessonProgress>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<LessonProgressUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<LessonProgressTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LessonProgressTable>? orderBy,
    _is.OrderByListBuilder<LessonProgressTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<LessonProgress>(
      columnValues: columnValues(LessonProgress.t.updateTable),
      where: where(LessonProgress.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LessonProgress.t),
      orderByList: orderByList?.call(LessonProgress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [LessonProgress]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LessonProgress>> delete(
    _is.DatabaseSession session,
    List<LessonProgress> rows, {
    _is.OrderByBuilder<LessonProgressTable>? orderBy,
    _is.OrderByListBuilder<LessonProgressTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<LessonProgress>(
      rows,
      orderBy: orderBy?.call(LessonProgress.t),
      orderByList: orderByList?.call(LessonProgress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [LessonProgress].
  Future<LessonProgress> deleteRow(
    _is.DatabaseSession session,
    LessonProgress row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LessonProgress>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LessonProgress>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LessonProgressTable> where,
    _is.OrderByBuilder<LessonProgressTable>? orderBy,
    _is.OrderByListBuilder<LessonProgressTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<LessonProgress>(
      where: where(LessonProgress.t),
      orderBy: orderBy?.call(LessonProgress.t),
      orderByList: orderByList?.call(LessonProgress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LessonProgressTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<LessonProgress>(
      where: where?.call(LessonProgress.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LessonProgress] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LessonProgressTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LessonProgress>(
      where: where(LessonProgress.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class LessonProgressAttachRowRepository {
  const LessonProgressAttachRowRepository._();

  /// Creates a relation between the given [LessonProgress] and [AuthUser]
  /// by setting the [LessonProgress]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    LessonProgress lessonProgress,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (lessonProgress.id == null) {
      throw ArgumentError.notNull('lessonProgress.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $lessonProgress = lessonProgress.copyWith(authUserId: authUser.id);
    await session.db.updateRow<LessonProgress>(
      $lessonProgress,
      columns: [LessonProgress.t.authUserId],
      transaction: transaction,
    );
  }
}
