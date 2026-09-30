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
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;

/// The result of a successful passwordless sign-in.
abstract class EmailCodeSignIn
    implements _is.SerializableModel, _is.ProtocolSerialization {
  EmailCodeSignIn._({
    required this.authSuccess,
    required this.isNewUser,
  });

  factory EmailCodeSignIn({
    required _iacs.AuthSuccess authSuccess,
    required bool isNewUser,
  }) = _EmailCodeSignInImpl;

  factory EmailCodeSignIn.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailCodeSignIn(
      authSuccess: _i9sfwcd2.Protocol().deserialize<_iacs.AuthSuccess>(
        jsonSerialization['authSuccess'],
      ),
      isNewUser: _is.BoolJsonExtension.fromJson(jsonSerialization['isNewUser']),
    );
  }

  _iacs.AuthSuccess authSuccess;

  /// True when this sign-in created the account.
  bool isNewUser;

  /// Returns a shallow copy of this [EmailCodeSignIn]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EmailCodeSignIn copyWith({
    _iacs.AuthSuccess? authSuccess,
    bool? isNewUser,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EmailCodeSignIn',
      'authSuccess': authSuccess.toJson(),
      'isNewUser': isNewUser,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EmailCodeSignIn',
      'authSuccess': authSuccess.toJson(),
      'isNewUser': isNewUser,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _EmailCodeSignInImpl extends EmailCodeSignIn {
  _EmailCodeSignInImpl({
    required _iacs.AuthSuccess authSuccess,
    required bool isNewUser,
  }) : super._(
         authSuccess: authSuccess,
         isNewUser: isNewUser,
       );

  /// Returns a shallow copy of this [EmailCodeSignIn]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EmailCodeSignIn copyWith({
    _iacs.AuthSuccess? authSuccess,
    bool? isNewUser,
  }) {
    return EmailCodeSignIn(
      authSuccess: authSuccess ?? this.authSuccess.copyWith(),
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }
}
