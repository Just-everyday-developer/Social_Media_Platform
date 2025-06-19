import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:social_media_platform/utils/text_utils.dart';
import 'package:social_media_platform/models/register_menu.dart';
import 'package:social_media_platform/models/checkboxes.dart';
import 'package:social_media_platform/data/bg_data.dart';
import 'package:social_media_platform/auth_service.dart';

import '../generated/l10n.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  int selectedBgIndex = 0;
  bool showBgSelector = false;
  bool rememberMe = false;
  bool obscurePassword = true;
  bool isLoading = false;
  bool isSuccess = false;
  String? errorMessage;

  
  late AnimationController _successAnimationController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _successAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _successAnimationController.dispose();
    _fadeController.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final user = await AuthService().signIn(
        emailCtrl.text.trim(),
        passwordCtrl.text.trim(),
      );

      if (user != null) {
        setState(() {
          isLoading = false;
          isSuccess = true;
        });

        
        _successAnimationController.forward();
        _fadeController.forward();

        
        await Future.delayed(const Duration(milliseconds: 1800));

        if (mounted) {
          context.go('/home');
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = S.of(context).enter_page_error_message;
        });
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final user = await AuthService().signInWithGoogle();

    if (user != null) {
      setState(() {
        isLoading = false;
        isSuccess = true;
      });

      _successAnimationController.forward();
      _fadeController.forward();

      await Future.delayed(const Duration(milliseconds: 1800));

      if (mounted) {
        context.go('/home');
      }
    } else {
      setState(() {
        isLoading = false;
        errorMessage = S.of(context).enter_page_google_sign_in_error;
      });
    }
  }

  Future<void> _handleGitHubLogin() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final user = await AuthService().signInWithGitHub();

    if (user != null) {
      setState(() {
        isLoading = false;
        isSuccess = true;
      });

      _successAnimationController.forward();
      _fadeController.forward();

      await Future.delayed(const Duration(milliseconds: 1800));

      if (mounted) {
        context.go('/home');
      }
    } else {
      setState(() {
        isLoading = false;
        errorMessage = S.of(context).enter_page_github_sign_in_error;
      });
    }
  }

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
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(bgList[selectedBgIndex]),
                fit: BoxFit.cover,
              ),
            ),
          ),

          
          Center(
            child: AnimatedOpacity(
              opacity: isSuccess ? 0 : 1,
              duration: const Duration(milliseconds: 300),
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
                    child: _buildLoginForm(),
                  ),
                ),
              ),
            ),
          ),

          
          if (isSuccess)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  
                  Container(
                    width: 120,
                    height: 120,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        
                        
                        
                        
                        
                        
                        

                        AnimatedBuilder(
                          animation: _successAnimationController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _successAnimationController.value,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _fadeController,
                    child: Text(
                      S.of(context).successful_login,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          
          if (isLoading && !isSuccess)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
          TextUtil(text: S.of(context).welcome_back, size: 26, weight: true),
          const SizedBox(height: 24),

          
          TextFormField(
            controller: emailCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration("Email", Icons.mail),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).msg_enter_email;
              }
              if (!value.contains('@')) {
                return S.of(context).msg_enter_valid_email;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          
          TextFormField(
            controller: passwordCtrl,
            obscureText: obscurePassword,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration("Password", Icons.lock, isPassword: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).msg_enter_password;
              }
              if (value.length < 6) {
                return S.of(context).msg_enter_long_password;
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => rememberMe = !rememberMe),
                child: Row(
                  children: [
                    rememberMe ? FilledCheckbox() : EmptyCheckbox(),
                    const SizedBox(width: 8),
                    Text(S.of(context).remember_me, style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  
                },
                child: Text(S.of(context).forgot_password,
                    style: TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline)),
              ),
            ],
          ),

          
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 14),
              ),
            ),

          const SizedBox(height: 20),

          
          ElevatedButton(
            onPressed: isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
            ),
            child: isLoading
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            )
                : Text(S.of(context).login),
          ),
          const SizedBox(height: 16),
          Text(S.of(context).or_continue_with, style: TextStyle(color: Colors.white70)),
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
                onPressed: isLoading ? null : _handleGoogleLogin,
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage("assets/github.png"),
                  radius: 25,),
                onPressed: isLoading ? null : _handleGitHubLogin,
              ),
            ],
          ),

          const SizedBox(height: 16),

          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(S.of(context).not_have_account, style: TextStyle(color: Colors.white)),
              TextButton(
                onPressed: isLoading ? null : () {
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
                      child: const RegisterMenu(),
                    ),
                  );
                },
                child: Text(S.of(context).register,
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
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
      errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
      focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
      suffixIcon: isPassword
          ? IconButton(
        icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off, color: Colors.white),
        onPressed: () => setState(() => obscurePassword = !obscurePassword),
      )
          : Icon(icon, color: Colors.white),
    );
  }
}