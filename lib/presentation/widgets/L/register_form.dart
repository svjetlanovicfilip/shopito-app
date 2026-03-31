import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopito_app/blocs/register/register_bloc.dart';
import 'package:shopito_app/config/router/router.dart';
import 'package:shopito_app/presentation/widgets/M/inputs/input_field.dart';
import 'package:shopito_app/presentation/widgets/S/input_field_label.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key, required this.registerBloc});

  final RegisterBloc registerBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome text
            Text(
              "Registrujte se",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF121212),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Unesite vaše podatke da kreirate novi nalog",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 30),

            // Full name field
            InputFieldLabel(label: "Ime i prezime"),
            const SizedBox(height: 8),
            BlocBuilder<RegisterBloc, RegisterState>(
              bloc: registerBloc,
              buildWhen:
                  (previous, current) =>
                      previous.fullName != current.fullName ||
                      current.fullNameErrorMessage != null,
              builder: (context, state) {
                return InputField(
                  onChanged: (value) {
                    registerBloc.add(RegisterFullNameChanged(fullName: value));
                  },
                  hintText: "Unesite ime i prezime",
                  prefixIcon: Icons.person_outline,
                  errorText: state.fullNameErrorMessage,
                );
              },
            ),

            const SizedBox(height: 20),

            // Phone number field
            InputFieldLabel(label: "Broj telefona"),
            const SizedBox(height: 8),
            BlocBuilder<RegisterBloc, RegisterState>(
              bloc: registerBloc,
              buildWhen:
                  (previous, current) =>
                      previous.phoneNumber != current.phoneNumber ||
                      current.phoneNumberErrorMessage != null,
              builder: (context, state) {
                return InputField(
                  onChanged: (value) {
                    registerBloc.add(
                      RegisterPhoneNumberChanged(phoneNumber: value),
                    );
                  },
                  hintText: "+387 65 123 456",
                  prefixIcon: Icons.phone_outlined,
                  errorText: state.phoneNumberErrorMessage,
                );
              },
            ),

            const SizedBox(height: 20),

            // Email field
            InputFieldLabel(label: "Email"),
            const SizedBox(height: 8),
            BlocBuilder<RegisterBloc, RegisterState>(
              bloc: registerBloc,
              buildWhen:
                  (previous, current) =>
                      previous.email != current.email ||
                      current.emailErrorMessage != null,
              builder: (context, state) {
                return InputField(
                  onChanged: (value) {
                    registerBloc.add(RegisterEmailChanged(email: value));
                  },
                  hintText: "unesite@email.com",
                  prefixIcon: Icons.email_outlined,
                  errorText: state.emailErrorMessage,
                );
              },
            ),

            const SizedBox(height: 20),

            // Password field
            InputFieldLabel(label: "Lozinka"),
            const SizedBox(height: 8),
            BlocBuilder<RegisterBloc, RegisterState>(
              bloc: registerBloc,
              buildWhen:
                  (previous, current) =>
                      previous.password != current.password ||
                      current.passwordErrorMessage != null,
              builder: (context, state) {
                return InputField(
                  onChanged: (value) {
                    registerBloc.add(RegisterPasswordChanged(password: value));
                  },
                  hintText: "Unesite lozinku",
                  prefixIcon: Icons.lock_outline,
                  errorText: state.passwordErrorMessage,
                  isPassword: true,
                );
              },
            ),

            const SizedBox(height: 30),

            // Register button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  registerBloc.add(RegisterSubmitted());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3C8D2F),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: Text(
                  "Registrujte se",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Login link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Već imate nalog? ",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    context.goNamed(Routes.login);
                  },
                  child: Text(
                    "Prijavite se",
                    style: TextStyle(
                      color: Color(0xFF3C8D2F),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
