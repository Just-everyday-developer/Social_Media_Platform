import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:social_media_platform/utils/text_utils.dart';

class RegisterMenu extends StatefulWidget {
  const RegisterMenu({super.key});

  @override
  State<RegisterMenu> createState() => _RegisterMenuState();
}

class _RegisterMenuState extends State<RegisterMenu> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  int selectedBgIndex = 0;
  bool showBgSelector = false;
  bool rememberMe = false;
  bool obscurePassword = true;
  bool acceptTerms = false;

  String email = '';
  String password = '';

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(
                    hint: "Email",
                    icon: Icons.mail,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailCtrl,
                    validator: (val) =>
                    val != null && !EmailValidator.validate(val)
                        ? 'Enter a valid email'
                        : null,
                    onSaved: (val) => email = val!,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    hint: "Password",
                    icon: Icons.lock,
                    isPassword: true,
                    controller: passwordCtrl,
                    validator: (val) => (val == null || val.length < 6)
                        ? 'Password must be at least 6 characters'
                        : null,
                    onSaved: (val) => password = val!,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: acceptTerms,
                        onChanged: (val) =>
                            setState(() => acceptTerms = val ?? false),
                      ),
                      Expanded(
                        child: TextUtil(
                          text: "I accept the Terms & Conditions",
                          size: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (!acceptTerms) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('You must accept terms')),
                          );
                          return;
                        }
                        _formKey.currentState!.save();

                        // ✅ Точка действия после валидации
                        debugPrint("Email: $email");
                        debugPrint("Password: $password");

                        // Тут можешь вставить переход, API вызов, Firebase и т.п.
                      }
                    },
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      child: TextUtil(
                          text: "Sign Up",
                          color: Colors.black,
                          weight: true),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    required TextEditingController controller,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && obscurePassword,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            obscurePassword
                ? Icons.visibility_off
                : Icons.visibility,
            color: Colors.white,
          ),
          onPressed: () =>
              setState(() => obscurePassword = !obscurePassword),
        )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
      ),
    );
  }
}
