import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("404", style: GoogleFonts.roboto(fontSize: 100)),
                    Text("Page not found", style: GoogleFonts.roboto(fontSize: 30)),
                    SizedBox(height: 20),
                    TextButton(
                        onPressed: () => context.go('/home'),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.greenAccent
                        ),
                        child: Text("Back to home page"))
                  ],
            )
          )
      );
  }
}