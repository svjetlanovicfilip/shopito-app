import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopito_app/blocs/auth/auth_bloc.dart';
import 'package:shopito_app/blocs/login/login_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/config/router/router.dart';
import 'package:shopito_app/presentation/widgets/L/login_form.dart';
import 'package:shopito_app/presentation/widgets/M/loader.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginBloc = getIt<LoginBloc>();

  final _globalKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocListener<LoginBloc, LoginState>(
        bloc: loginBloc,
        listener: (context, state) {
          if (state.status == LoginStatus.loading) {
            showOverlay();
          } else if (state.status == LoginStatus.success) {
            _removeOverlay();
            getIt<AuthBloc>().add(
              AuthStatusChecked(authSuccess: state.authSuccess),
            );

            if (state.authSuccess?.user.role == "ADMIN") {
              context.goNamed(Routes.adminHome);
            } else {
              context.goNamed(Routes.home);
            }
          } else if (state.status == LoginStatus.failure) {
            _removeOverlay();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),

                // Logo and title
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3C8D2F),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Dobrodošli",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF121212),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Prijavite se na svoj nalog",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                LoginForm(loginBloc: loginBloc),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showOverlay() {
    _removeOverlay();

    final ctx = _globalKey.currentContext ?? context;
    final child = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {}, // Empty callback to prevent interaction
      child: Container(
        color: Colors.black.withValues(alpha: 0.3),
        child: Loader(),
      ),
    );
    _overlayEntry = OverlayEntry(builder: (context) => child);
    Overlay.of(ctx).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  // void _showError(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       backgroundColor: Colors.red,
  //       behavior: SnackBarBehavior.floating,
  //       margin: const EdgeInsets.all(16),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //     ),
  //   );
  // }
}
