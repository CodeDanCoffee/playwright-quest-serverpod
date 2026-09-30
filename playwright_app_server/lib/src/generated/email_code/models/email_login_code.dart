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

/// A pending one-time sign-in code for passwordless email login.
///
/// At most one code is active per email. The code itself is never stored,
/// only a keyed hash of it.
abstract class EmailLoginCode
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  EmailLoginCode._({
    this.id,
    required this.email,
    required this.codeHash,
    required this.createdAt,
    required this.expiresAt,
    int? failedAttempts,
  }) : failedAttempts = failedAttempts ?? 0;

  factory EmailLoginCode({
    int? id,
    required String email,
    required String codeHash,
    required DateTime createdAt,
    required DateTime expiresAt,
    int? failedAttempts,
  }) = _EmailLoginCodeImpl;

  factory EmailLoginCode.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailLoginCode(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      codeHash: jsonSerialization['codeHash'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      failedAttempts: jsonSerialization['failedAttempts'] as int?,
    );
  }

  static final t = EmailLoginCodeTable();

  static const db = EmailLoginCodeRepository._();

  @override
  int? id;

  /// Lower-cased email address the code was sent to.
  String email;

  /// HMAC-SHA256 of the code, keyed with the server's hash pepper.
  String codeHash;

  DateTime createdAt;

  DateTime expiresAt;

  /// Number of wrong guesses so far.
  int failedAttempts;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [EmailLoginCode]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EmailLoginCode copyWith({
    int? id,
    String? email,
    String? codeHash,
    DateTime? createdAt,
    DateTime? expiresAt,
    int? failedAttempts,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EmailLoginCode',
      if (id != null) 'id': id,
      'email': email,
      'codeHash': codeHash,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
      'failedAttempts': failedAttempts,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static EmailLoginCodeInclude include() {
    return EmailLoginCodeInclude._();
  }

  static EmailLoginCodeIncludeList includeList({
    _is.WhereExpressionBuilder<EmailLoginCodeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailLoginCodeTable>? orderBy,
    _is.OrderByListBuilder<EmailLoginCodeTable>? orderByList,
    EmailLoginCodeInclude? include,
  }) {
    return EmailLoginCodeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailLoginCode.t),
      orderByList: orderByList?.call(EmailLoginCode.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailLoginCodeImpl extends EmailLoginCode {
  _EmailLoginCodeImpl({
    int? id,
    required String email,
    required String codeHash,
    required DateTime createdAt,
    required DateTime expiresAt,
    int? failedAttempts,
  }) : super._(
         id: id,
         email: email,
         codeHash: codeHash,
         createdAt: createdAt,
         expiresAt: expiresAt,
         failedAttempts: failedAttempts,
       );

  /// Returns a shallow copy of this [EmailLoginCode]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EmailLoginCode copyWith({
    Object? id = _Undefined,
    String? email,
    String? codeHash,
    DateTime? createdAt,
    DateTime? expiresAt,
    int? failedAttempts,
  }) {
    return EmailLoginCode(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      codeHash: codeHash ?? this.codeHash,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      failedAttempts: failedAttempts ?? this.failedAttempts,
    );
  }
}

class EmailLoginCodeUpdateTable extends _is.UpdateTable<EmailLoginCodeTable> {
  EmailLoginCodeUpdateTable(super.table);

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<String, String> codeHash(String value) => _is.ColumnValue(
    table.codeHash,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _is.ColumnValue(
        table.expiresAt,
        value,
      );

  _is.ColumnValue<int, int> failedAttempts(int value) => _is.ColumnValue(
    table.failedAttempts,
    value,
  );
}

class EmailLoginCodeTable extends _is.Table<int?> {
  EmailLoginCodeTable({super.tableRelation})
    : super(tableName: 'email_login_code') {
    updateTable = EmailLoginCodeUpdateTable(this);
    email = _is.ColumnString(
      'email',
      this,
    );
    codeHash = _is.ColumnString(
      'codeHash',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    expiresAt = _is.ColumnDateTime(
      'expiresAt',
      this,
    );
    failedAttempts = _is.ColumnInt(
      'failedAttempts',
      this,
      hasDefault: true,
    );
  }

  late final EmailLoginCodeUpdateTable updateTable;

  /// Lower-cased email address the code was sent to.
  late final _is.ColumnString email;

  /// HMAC-SHA256 of the code, keyed with the server's hash pepper.
  late final _is.ColumnString codeHash;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime expiresAt;

  /// Number of wrong guesses so far.
  late final _is.ColumnInt failedAttempts;

  @override
  List<_is.Column> get columns => [
    id,
    email,
    codeHash,
    createdAt,
    expiresAt,
    failedAttempts,
  ];
}

class EmailLoginCodeInclude extends _is.IncludeObject {
  EmailLoginCodeInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => EmailLoginCode.t;
}

class EmailLoginCodeIncludeList extends _is.IncludeList {
  EmailLoginCodeIncludeList._({
    _is.WhereExpressionBuilder<EmailLoginCodeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailLoginCode.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => EmailLoginCode.t;
}

class EmailLoginCodeRepository {
  const EmailLoginCodeRepository._();

  /// Returns a list of [EmailLoginCode]s matching the given query parameters.
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
  Future<List<EmailLoginCode>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailLoginCodeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailLoginCodeTable>? orderBy,
    _is.OrderByListBuilder<EmailLoginCodeTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EmailLoginCode>(
      where: where?.call(EmailLoginCode.t),
      orderBy: orderBy?.call(EmailLoginCode.t),
      orderByList: orderByList?.call(EmailLoginCode.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EmailLoginCode] matching the given query parameters.
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
  Future<EmailLoginCode?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailLoginCodeTable>? where,
    int? offset,
    _is.OrderByBuilder<EmailLoginCodeTable>? orderBy,
    _is.OrderByListBuilder<EmailLoginCodeTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EmailLoginCode>(
      where: where?.call(EmailLoginCode.t),
      orderBy: orderBy?.call(EmailLoginCode.t),
      orderByList: orderByList?.call(EmailLoginCode.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EmailLoginCode] by its [id] or null if no such row exists.
  Future<EmailLoginCode?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EmailLoginCode>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EmailLoginCode]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailLoginCode]s will have their `id` fields set.
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
  Future<List<EmailLoginCode>> insert(
    _is.DatabaseSession session,
    List<EmailLoginCode> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<EmailLoginCode>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [EmailLoginCode] and returns the inserted row.
  ///
  /// The returned [EmailLoginCode] will have its `id` field set.
  Future<EmailLoginCode> insertRow(
    _is.DatabaseSession session,
    EmailLoginCode row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailLoginCode>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [EmailLoginCode]s in the list and returns the resulting rows.
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
  /// The returned [EmailLoginCode]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailLoginCode>> upsert(
    _is.DatabaseSession session,
    List<EmailLoginCode> rows, {
    required _is.ColumnSelections<EmailLoginCodeTable> conflictColumns,
    _is.ColumnSelections<EmailLoginCodeTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailLoginCodeTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<EmailLoginCode>(
      rows,
      conflictColumns: conflictColumns(EmailLoginCode.t),
      updateColumns: updateColumns?.call(EmailLoginCode.t),
      updateWhere: updateWhere?.call(EmailLoginCode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [EmailLoginCode] and returns the resulting row.
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
  /// The returned [EmailLoginCode] will have its `id` field set.
  Future<EmailLoginCode?> upsertRow(
    _is.DatabaseSession session,
    EmailLoginCode row, {
    required _is.ColumnSelections<EmailLoginCodeTable> conflictColumns,
    _is.ColumnSelections<EmailLoginCodeTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailLoginCodeTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<EmailLoginCode>(
      row,
      conflictColumns: conflictColumns(EmailLoginCode.t),
      updateColumns: updateColumns?.call(EmailLoginCode.t),
      updateWhere: updateWhere?.call(EmailLoginCode.t),
      transaction: transaction,
    );
  }

  /// Updates all [EmailLoginCode]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailLoginCode>> update(
    _is.DatabaseSession session,
    List<EmailLoginCode> rows, {
    _is.ColumnSelections<EmailLoginCodeTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<EmailLoginCode>(
      rows,
      columns: columns?.call(EmailLoginCode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [EmailLoginCode]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailLoginCode> updateRow(
    _is.DatabaseSession session,
    EmailLoginCode row, {
    _is.ColumnSelections<EmailLoginCodeTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailLoginCode>(
      row,
      columns: columns?.call(EmailLoginCode.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailLoginCode] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EmailLoginCode?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<EmailLoginCodeUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<EmailLoginCode>(
      id,
      columnValues: columnValues(EmailLoginCode.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EmailLoginCode]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailLoginCode>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<EmailLoginCodeUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<EmailLoginCodeTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailLoginCodeTable>? orderBy,
    _is.OrderByListBuilder<EmailLoginCodeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<EmailLoginCode>(
      columnValues: columnValues(EmailLoginCode.t.updateTable),
      where: where(EmailLoginCode.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailLoginCode.t),
      orderByList: orderByList?.call(EmailLoginCode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [EmailLoginCode]s in the list and returns the deleted rows.
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
  Future<List<EmailLoginCode>> delete(
    _is.DatabaseSession session,
    List<EmailLoginCode> rows, {
    _is.OrderByBuilder<EmailLoginCodeTable>? orderBy,
    _is.OrderByListBuilder<EmailLoginCodeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<EmailLoginCode>(
      rows,
      orderBy: orderBy?.call(EmailLoginCode.t),
      orderByList: orderByList?.call(EmailLoginCode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [EmailLoginCode].
  Future<EmailLoginCode> deleteRow(
    _is.DatabaseSession session,
    EmailLoginCode row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailLoginCode>(
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
  Future<List<EmailLoginCode>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailLoginCodeTable> where,
    _is.OrderByBuilder<EmailLoginCodeTable>? orderBy,
    _is.OrderByListBuilder<EmailLoginCodeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<EmailLoginCode>(
      where: where(EmailLoginCode.t),
      orderBy: orderBy?.call(EmailLoginCode.t),
      orderByList: orderByList?.call(EmailLoginCode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailLoginCodeTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<EmailLoginCode>(
      where: where?.call(EmailLoginCode.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EmailLoginCode] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailLoginCodeTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EmailLoginCode>(
      where: where(EmailLoginCode.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
