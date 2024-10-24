import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_area/features/auth/presentation/providers/providers.dart';
import 'package:guardian_area/shared/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(), // Ocultar teclado al hacer tap fuera
      child: Scaffold(
        body: Stack(
          children: [
            // Fondo de imagen
            Positioned.fill(
              child: Image.asset(
                'assets/images/login_img.jpg',
                fit: BoxFit.cover,
              ),
            ),
            // * Contenido principal
            Center(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Accede a",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "GuardianArea",
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _EmailInput(),
                      const SizedBox(height: 20),
                      _PasswordInput(),
                      const SizedBox(height: 30),
                      _LoginButton(),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "¿No tienes una cuenta?",
                            style: TextStyle(color: Colors.black54),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Regístrate Aquí',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm = ref.watch(loginFormProvider);

    return CustomTextFormField(
      label: 'Correo',
      keyboardType: TextInputType.emailAddress,
      onChanged: ref.read(loginFormProvider.notifier).onEmailChanged,
      errorMessage:
          loginForm.isFormPosted ? loginForm.email.errorMessage : null,
    );
  }
}

class _PasswordInput extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm = ref.watch(loginFormProvider);

    return CustomTextFormField(
      label: 'Contraseña',
      obscureText: true,
      onChanged: ref.read(loginFormProvider.notifier).onPasswordChanged,
      errorMessage:
          loginForm.isFormPosted ? loginForm.password.errorMessage : null,
    );
  }
}

class _LoginButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm = ref.watch(loginFormProvider);

    return SizedBox(
      width: double.infinity,
      child: CustomFilledButton(
        text: 'Ingresar',
        buttonColor: const Color(0xFF08273A),
        onPressed: loginForm.isPosting
            ? null
            : ref.read(loginFormProvider.notifier).onFormSubmit,
      ),
    );
  }
}
