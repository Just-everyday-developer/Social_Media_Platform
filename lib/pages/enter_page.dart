import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_platform/utils/text_utils.dart';
import 'package:social_media_platform/models/register_menu.dart';
import 'package:social_media_platform/models/checkboxes.dart';
import 'package:social_media_platform/data/bg_data.dart';
import 'package:social_media_platform/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  int selectedBgIndex = 0;
  bool showBgSelector = false;
  bool rememberMe = false;
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: showBgSelector
            ? _buildBgSelector()
            : FloatingActionButton(
          onPressed: () => setState(() => showBgSelector = true),
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(bgList[selectedBgIndex]),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(bgList[selectedBgIndex]),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Blur + Login box
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: _buildLoginForm(

                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBgSelector() {
    return Container(
      height: 80,
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: bgList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) => GestureDetector(
                onTap: () => setState(() => selectedBgIndex = i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: selectedBgIndex == i ? Colors.white : Colors.transparent,
                    child: CircleAvatar(
                      radius: 26,
                      backgroundImage: AssetImage(bgList[i]),
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => setState(() => showBgSelector = false),
          )
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextUtil(text: "Welcome Back", size: 26, weight: true),
          const SizedBox(height: 24),

          // Email field
          TextFormField(
            controller: emailCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration("Email", Icons.mail),
            validator: (value) => value!.isEmpty ? 'Enter your email' : null,
          ),
          const SizedBox(height: 20),

          // Password field
          TextFormField(
            controller: passwordCtrl,
            obscureText: obscurePassword,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration("Password", Icons.lock, isPassword: true),
            validator: (value) => value!.isEmpty ? 'Enter your password' : null,
          ),
          const SizedBox(height: 12),

          // Remember Me and Forgot
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => rememberMe = !rememberMe),
                child: rememberMe ? FilledCheckbox() : EmptyCheckbox(),
              ),
              const SizedBox(width: 8),
              const Text("Remember Me", style: TextStyle(color: Colors.white)),
              const Spacer(),
              InkWell(
                onTap: () {
                  // TODO: Implement forgot password
                },
                child: const Text("Forgot Password?",
                    style: TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Login button
          ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final user = await AuthService().signIn(emailCtrl.text.trim(), passwordCtrl.text.trim());
                  if (user != null) {
                    context.go('/home');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login failed. Please check your credentials.')),
                    );
                  }
                }
              },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
            ),
            child: const Text("Log In"),
          ),
          const SizedBox(height: 16),
          Text("or continue with", style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage("assets/google.png"),
                  radius: 20,
                ),
                onPressed: () async {
                  final user = await AuthService().signInWithGoogle();
                  if (user != null) {
                    context.go('/home');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Google login failed')),
                    );
                  }
                },
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage("assets/github.png"),
                  radius: 25,),
                onPressed: () async {
                  final user = await AuthService().signInWithGitHub();
                  if (user != null) {
                    context.go('/home');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('GitHub login failed')),
                    );
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Register
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?", style: TextStyle(color: Colors.white)),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (_) => Container(
                      height: 350,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        border: Border(top: BorderSide(color: Colors.white)),
                      ),
                      child: const RegisterMenu(

                      ),
                    ),
                  );
                },
                child: const Text("Register",
                    style: TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline)),
              )
            ],
          )
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon, {bool isPassword = false}) {
    return InputDecoration(
      hintText: label,
      hintStyle: const TextStyle(color: Colors.white54),
      border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      suffixIcon: isPassword
          ? IconButton(
        icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off, color: Colors.white),
        onPressed: () => setState(() => obscurePassword = !obscurePassword),
      )
          : Icon(icon, color: Colors.white),
    );
  }
}
