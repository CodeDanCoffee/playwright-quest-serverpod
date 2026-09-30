import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playwright_app_client/playwright_app_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../game/game_controller.dart';
import '../widgets/quest_ui.dart';

/// Shows [child] when signed in, otherwise the passwordless sign-in screen.
class SignInScreen extends StatefulWidget {
  final Widget child;
  const SignInScreen({super.key, required this.child});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    client.auth.authInfoListenable.addListener(_updateSignedInState);
    _isSignedIn = client.auth.isAuthenticated;
  }

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(_updateSignedInState);
    super.dispose();
  }

  void _updateSignedInState() {
    setState(() {
      _isSignedIn = client.auth.isAuthenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isSignedIn) return widget.child;
    return const _AuthPage();
  }
}

enum _Mode { up, inn }

enum _Step { email, code }

class _AuthPage extends StatefulWidget {
  const _AuthPage();

  @override
  State<_AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<_AuthPage> {
  static final _emailPattern = RegExp(r'^\S+@\S+\.\S+$');

  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _codeFocus = FocusNode();

  _Mode _mode = _Mode.up;
  _Step _step = _Step.email;
  String? _error;
  bool _busy = false;

  String get _email => _emailController.text.trim().toLowerCase();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_clearError);
    _codeController.addListener(_clearError);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _codeFocus.dispose();
    super.dispose();
  }

  void _clearError() {
    if (_error != null) setState(() => _error = null);
  }

  void _toggleMode() => setState(() {
    _mode = _mode == _Mode.up ? _Mode.inn : _Mode.up;
    _error = null;
  });

  Future<void> _sendCode() async {
    if (_busy) return;
    if (!_emailPattern.hasMatch(_emailController.text.trim())) {
      setState(() => _error = 'Enter a valid email, like you@example.com');
      return;
    }
    setState(() => _busy = true);
    try {
      await client.emailCode.requestCode(_email);
      _codeController.clear();
      setState(() {
        _step = _Step.code;
        _error = null;
      });
      _focusCodeField();
    } on EmailCodeLoginException catch (e) {
      setState(() => _error = _messageFor(e.reason));
    } catch (_) {
      setState(() => _error = _offlineMessage);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verify() async {
    if (_busy) return;
    final code = _codeController.text;
    if (code.length < 6) {
      setState(() => _error = 'Enter all 6 digits');
      return;
    }
    setState(() => _busy = true);
    try {
      final result = await client.emailCode.verifyCode(_email, code);
      if (!mounted) return;
      // Decides which welcome variant the app shows next.
      GameScope.read(context).pendingWelcome = result.isNewUser
          ? WelcomeKind.newUser
          : WelcomeKind.returning;
      // Signing in swaps this page for the app.
      await client.auth.updateSignedInUser(result.authSuccess);
    } on EmailCodeLoginException catch (e) {
      setState(() => _error = _messageFor(e.reason));
    } catch (_) {
      setState(() => _error = _offlineMessage);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Moves focus to the code field once the code step is on screen.
  /// `autofocus` alone is ignored while the email field still has focus.
  void _focusCodeField() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _step == _Step.code) _codeFocus.requestFocus();
    });
    // Retry after the step transition, in case the outgoing step took focus
    // away while it was being removed.
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted && _step == _Step.code && !_codeFocus.hasFocus) {
        _codeFocus.requestFocus();
      }
    });
  }

  void _useDifferentEmail() => setState(() {
    _step = _Step.email;
    _error = null;
  });

  static const _offlineMessage =
      "Couldn't reach the server. Check your connection and try again.";

  String _messageFor(EmailCodeErrorReason reason) => switch (reason) {
    EmailCodeErrorReason.invalidEmail =>
      'Enter a valid email, like you@example.com',
    EmailCodeErrorReason.tooManyRequests =>
      'A code was just sent. Please wait 30 seconds before asking again.',
    EmailCodeErrorReason.invalidCode =>
      "That code doesn't match. Check your email and try again.",
    EmailCodeErrorReason.expired =>
      'That code has expired. Use a different email or send a new code.',
    EmailCodeErrorReason.tooManyAttempts =>
      'Too many tries. Go back and send yourself a new code.',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QuestBackground(
        child: SafeArea(
          bottom: false,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              // At least one screen tall so the footer pins to the bottom,
              // scrolling when the keyboard or a small screen needs it.
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const _Header(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                              child: _card(),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 34),
                          child: _step == _Step.email
                              ? _footer()
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _card() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: QuestColors.ink.withValues(alpha: 0.08),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        alignment: Alignment.topCenter,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween(
                begin: const Offset(0.04, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: KeyedSubtree(
            key: ValueKey((_step, _mode)),
            child: switch (_step) {
              _Step.email => _emailStep(),
              _Step.code => _codeStep(),
            },
          ),
        ),
      ),
    );
  }

  Widget _emailStep() {
    final up = _mode == _Mode.up;
    // No AutofillGroup: when the step is removed it would end the autofill
    // context, which on the web closes the input the code field just opened.
    return Form(
      child: _Gap18(
        children: [
          _Titles(
            title: up ? 'Start your quest' : 'Welcome back',
            subtitle: Text(
              up
                  ? 'Free, bite-sized lessons. No coding experience needed.'
                  : 'Enter your email and pick up where you left off.',
              style: questNunito(15.5, color: QuestColors.muted, height: 1.45),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExcludeSemantics(
                child: Text(
                  'Email',
                  style: questNunito(13, weight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 8),
              _SpecInput(
                controller: _emailController,
                semanticLabel: 'Email',
                hint: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                onSubmitted: _sendCode,
                hasError: _error != null,
              ),
              _ErrorText(_error),
            ],
          ),
          QuestButton(
            label: up ? 'Send my code' : 'Send sign-in code',
            busy: _busy,
            onPressed: _sendCode,
          ),
          Text(
            "No password needed — we'll email you a one-time code. "
            'We only use your email to save your progress.',
            textAlign: TextAlign.center,
            style: questNunito(13, color: QuestColors.faint, height: 1.45),
          ),
        ],
      ),
    );
  }

  Widget _codeStep() {
    return Form(
      child: _Gap18(
        children: [
          _Titles(
            title: 'Check your inbox',
            subtitle: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'We sent a 6-digit code to '),
                  TextSpan(
                    text: _email,
                    style: questNunito(15.5, weight: FontWeight.w800),
                  ),
                ],
              ),
              style: questNunito(15.5, color: QuestColors.muted, height: 1.45),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SpecInput(
                controller: _codeController,
                focusNode: _codeFocus,
                semanticLabel: '6-digit code',
                hint: '••••••',
                height: 64,
                centered: true,
                autofocus: true,
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                style: questBaloo(28).copyWith(letterSpacing: 14),
                onSubmitted: _verify,
                hasError: _error != null,
              ),
              _ErrorText(_error),
            ],
          ),
          QuestButton(
            label: _mode == _Mode.up ? 'Verify & start' : 'Verify & continue',
            busy: _busy,
            onPressed: _verify,
          ),
          Center(
            child: QuestLinkButton(
              label: 'Use a different email',
              style: questNunito(
                14,
                weight: FontWeight.w700,
                color: QuestColors.muted,
              ),
              onPressed: _useDifferentEmail,
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer() {
    final up = _mode == _Mode.up;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          up ? 'Already on a quest? ' : 'New here? ',
          style: questNunito(
            15,
            weight: FontWeight.w600,
            color: QuestColors.muted,
          ),
        ),
        QuestLinkButton(
          label: up ? 'Sign in' : 'Create account',
          style: questNunito(
            15,
            weight: FontWeight.w800,
            color: QuestColors.greenDark,
          ),
          onPressed: _toggleMode,
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 44, 28, 0),
      child: Column(
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 112,
            semanticLabel: 'Playwright Quest logo',
          ),
          Text(
            'Playwright Quest',
            textAlign: TextAlign.center,
            style: questBaloo(38, height: 1).copyWith(letterSpacing: -0.5),
          ),
          const SizedBox(height: 12),
          const Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _Chip(
                '4 levels',
                text: QuestColors.greenDark,
                dot: QuestColors.green,
              ),
              _Chip(
                '3-min lessons',
                text: QuestColors.blue,
                dot: QuestColors.blueDot,
              ),
              _Chip(
                'Stars & XP',
                text: QuestColors.orange,
                dot: QuestColors.orangeDot,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label, {required this.text, required this.dot});

  final String label;
  final Color text;
  final Color dot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: questNunito(12.5, weight: FontWeight.w700, color: text),
          ),
        ],
      ),
    );
  }
}

/// A vertical stack with 18px between children.
class _Gap18 extends StatelessWidget {
  const _Gap18({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (i, child) in children.indexed) ...[
          if (i > 0) const SizedBox(height: 18),
          child,
        ],
      ],
    );
  }
}

class _Titles extends StatelessWidget {
  const _Titles({required this.title, required this.subtitle});

  final String title;
  final Widget subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            style: questBaloo(28, height: 1.05),
          ),
        ),
        const SizedBox(height: 8),
        subtitle,
      ],
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.message);

  final String? message;

  @override
  Widget build(BuildContext context) {
    final message = this.message;
    return AnimatedSize(
      duration: const Duration(milliseconds: 150),
      alignment: Alignment.topLeft,
      child: message == null
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  message,
                  style: questNunito(
                    13,
                    weight: FontWeight.w700,
                    color: QuestColors.error,
                  ),
                ),
              ),
            ),
    );
  }
}

/// The spec's input: soft fill, 2px border, green border and ring on focus.
class _SpecInput extends StatefulWidget {
  const _SpecInput({
    required this.controller,
    required this.semanticLabel,
    required this.hint,
    required this.onSubmitted,
    this.height = 54,
    this.centered = false,
    this.autofocus = false,
    this.keyboardType,
    this.autofillHints,
    this.inputFormatters,
    this.style,
    this.hasError = false,
    this.focusNode,
  });

  final TextEditingController controller;
  final String semanticLabel;
  final String hint;
  final VoidCallback onSubmitted;
  final double height;
  final bool centered;
  final bool autofocus;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? style;
  final bool hasError;

  /// Optional external focus node, e.g. to move focus programmatically.
  final FocusNode? focusNode;

  @override
  State<_SpecInput> createState() => _SpecInputState();
}

class _SpecInputState extends State<_SpecInput> {
  late final FocusNode _focus = widget.focusNode ?? FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChanged);
  }

  void _onFocusChanged() => setState(() {});

  @override
  void dispose() {
    _focus.removeListener(_onFocusChanged);
    if (widget.focusNode == null) _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;
    final style = widget.style ?? questNunito(16, weight: FontWeight.w600);
    final borderColor = widget.hasError
        ? QuestColors.error
        : focused
        ? QuestColors.green
        : QuestColors.inputBorder;
    final ringColor = widget.hasError ? QuestColors.error : QuestColors.green;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: focused ? Colors.white : QuestColors.inputBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          if (focused)
            BoxShadow(
              color: ringColor.withValues(alpha: 0.14),
              spreadRadius: 4,
            ),
        ],
      ),
      // The visible label above the box is excluded from semantics, so the
      // field announces it itself.
      child: Semantics(
        label: widget.semanticLabel,
        child: TextField(
          controller: widget.controller,
          focusNode: _focus,
          autofocus: widget.autofocus,
          keyboardType: widget.keyboardType,
          autofillHints: widget.autofillHints,
          inputFormatters: widget.inputFormatters,
          textInputAction: TextInputAction.go,
          textAlign: widget.centered ? TextAlign.center : TextAlign.start,
          autocorrect: false,
          enableSuggestions: false,
          style: style,
          cursorColor: QuestColors.green,
          onSubmitted: (_) => widget.onSubmitted(),
          decoration: InputDecoration(
            isCollapsed: true,
            border: InputBorder.none,
            hintText: widget.hint,
            hintStyle: style.copyWith(color: QuestColors.placeholder),
          ),
        ),
      ),
    );
  }
}
