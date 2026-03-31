import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopito_app/blocs/auth/auth_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/config/router/router.dart';
import 'package:shopito_app/config/theme/custom_theme.dart';
import 'package:shopito_app/services/firebase_service.dart';

import 'flavors.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AuthBloc get _authBloc => getIt<AuthBloc>();

  @override
  void initState() {
    super.initState();
    getIt<FirebaseService>().initListeners();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: F.title,
      theme: theme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return BlocListener<AuthBloc, AuthState>(
          bloc: _authBloc,
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              if (state.userRole == 'ADMIN') {
                _navigateToAdminHome();
              } else if (state.userRole == 'USER') {
                _navigateToUserHome();
              } else {
                _navigateToLogin();
              }
            } else if (state is AuthUnauthenticated) {
              _navigateToLogin();
            }
          },
          child: child,
        );
      },
    );
  }

  void _navigateToLogin() {
    router.pushReplacementNamed(Routes.login);
  }

  void _navigateToUserHome() {
    router.pushReplacementNamed(Routes.home);
  }

  void _navigateToAdminHome() {
    router.pushReplacementNamed(Routes.adminHome);
  }
}
