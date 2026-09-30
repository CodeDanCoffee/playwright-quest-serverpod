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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../email_code/models/email_code_error_reason.dart' as _i90jfz6t;

/// Thrown by the passwordless email sign-in endpoint.
abstract class EmailCodeLoginException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  EmailCodeLoginException._({required this.reason});

  factory EmailCodeLoginException({
    required _i90jfz6t.EmailCodeErrorReason reason,
  }) = _EmailCodeLoginExceptionImpl;

  factory EmailCodeLoginException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return EmailCodeLoginException(
      reason: _i90jfz6t.EmailCodeErrorReason.fromJson(
        (jsonSerialization['reason'] as String),
      ),
    );
  }

  _i90jfz6t.EmailCodeErrorReason reason;

  /// Returns a shallow copy of this [EmailCodeLoginException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  EmailCodeLoginException copyWith({_i90jfz6t.EmailCodeErrorReason? reason});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EmailCodeLoginException',
      'reason': reason.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EmailCodeLoginException',
      'reason': reason.toJson(),
    };
  }

  @override
  String toString() {
    return 'EmailCodeLoginException(reason: $reason)';
  }
}

class _EmailCodeLoginExceptionImpl extends EmailCodeLoginException {
  _EmailCodeLoginExceptionImpl({required _i90jfz6t.EmailCodeErrorReason reason})
    : super._(reason: reason);

  /// Returns a shallow copy of this [EmailCodeLoginException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  EmailCodeLoginException copyWith({_i90jfz6t.EmailCodeErrorReason? reason}) {
    return EmailCodeLoginException(reason: reason ?? this.reason);
  }
}
