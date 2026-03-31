import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopito_app/blocs/auth/auth_bloc.dart';
import 'package:shopito_app/blocs/register/register_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/config/router/router.dart';
import 'package:shopito_app/config/theme/colors.dart';
import 'package:shopito_app/presentation/widgets/L/register_form.dart';
import 'package:shopito_app/presentation/widgets/M/loader.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final registerBloc = getIt<RegisterBloc>();

  final _globalKey = GlobalKey();
  late OverlayEntry _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: AppColors.primary,
      body: BlocListener<RegisterBloc, RegisterState>(
        bloc: registerBloc,
        listener: (context, state) {
          if (state.status == RegisterStatus.loading) {
            showOverlay();
          } else if (state.status == RegisterStatus.success) {
            _overlayEntry.remove();
            getIt<AuthBloc>().add(
              AuthStatusChecked(authSuccess: state.registerSuccess),
            );
            context.goNamed(Routes.home);
          } else if (state.status == RegisterStatus.failure) {
            _overlayEntry.remove();
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
                child: Column(
                  children: [
                    Text(
                      "Registracija",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // App logo/title
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Kreirajte nalog",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Register form
              Expanded(child: RegisterForm(registerBloc: registerBloc)),
            ],
          ),
        ),
      ),
    );
  }

  void showOverlay() {
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
    Overlay.of(ctx).insert(_overlayEntry);
  }
}
