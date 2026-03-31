import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopito_app/blocs/login/login_bloc.dart';
import 'package:shopito_app/config/router/router.dart';
import 'package:shopito_app/presentation/widgets/M/inputs/input_field.dart';
import 'package:shopito_app/presentation/widgets/S/input_field_label.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key, required this.loginBloc});

  final LoginBloc loginBloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputFieldLabel(label: "Email"),
        const SizedBox(height: 8),
        BlocBuilder<LoginBloc, LoginState>(
          bloc: loginBloc,
          buildWhen:
              (previous, current) =>
                  previous.email != current.email ||
                  current.emailErrorMessage != null,
          builder: (context, state) {
            return InputField(
              onChanged: (value) {
                loginBloc.add(LoginEmailChanged(email: value));
              },
              hintText: "unesite@email.com",
              prefixIcon: Icons.email_outlined,
              errorText: state.emailErrorMessage,
            );
          },
        ),

        const SizedBox(height: 20),

        InputFieldLabel(label: "Lozinka"),
        const SizedBox(height: 8),
        BlocBuilder<LoginBloc, LoginState>(
          bloc: loginBloc,
          buildWhen:
              (previous, current) =>
                  previous.password != current.password ||
                  current.passwordErrorMessage != null,
          builder: (context, state) {
            return InputField(
              onChanged: (value) {
                loginBloc.add(LoginPasswordChanged(password: value));
              },
              hintText: "Unesite lozinku",
              prefixIcon: Icons.lock_outline,
              errorText: state.passwordErrorMessage,
              isPassword: true,
            );
          },
        ),

        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              loginBloc.add(LoginSubmitted());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3C8D2F),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              "Prijavite se",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Divider
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "ili",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),

        const SizedBox(height: 24),

        // Register button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () {
              context.goNamed(Routes.register);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF3C8D2F),
              side: const BorderSide(color: Color(0xFF3C8D2F), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              "Napravite nalog",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
