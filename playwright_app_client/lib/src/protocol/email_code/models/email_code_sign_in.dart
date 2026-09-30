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
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// The result of a successful passwordless sign-in.
abstract class EmailCodeSignIn
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  EmailCodeSignIn._({
    required this.authSuccess,
    required this.isNewUser,
  });

  factory EmailCodeSignIn({
    required _iacc.AuthSuccess authSuccess,
    required bool isNewUser,
  }) = _EmailCodeSignInImpl;

  factory EmailCodeSignIn.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailCodeSignIn(
      authSuccess: _i5c00drz.Protocol().deserialize<_iacc.AuthSuccess>(
        jsonSerialization['authSuccess'],
      ),
      isNewUser: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['isNewUser'],
      ),
    );
  }

  _iacc.AuthSuccess authSuccess;

  /// True when this sign-in created the account.
  bool isNewUser;

  /// Returns a shallow copy of this [EmailCodeSignIn]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  EmailCodeSignIn copyWith({
    _iacc.AuthSuccess? authSuccess,
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
    return _isc.SerializationManager.encode(this);
  }
}

class _EmailCodeSignInImpl extends EmailCodeSignIn {
  _EmailCodeSignInImpl({
    required _iacc.AuthSuccess authSuccess,
    required bool isNewUser,
  }) : super._(
         authSuccess: authSuccess,
         isNewUser: isNewUser,
       );

  /// Returns a shallow copy of this [EmailCodeSignIn]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  EmailCodeSignIn copyWith({
    _iacc.AuthSuccess? authSuccess,
    bool? isNewUser,
  }) {
    return EmailCodeSignIn(
      authSuccess: authSuccess ?? this.authSuccess.copyWith(),
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }
}
