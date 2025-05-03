import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_platform/models/Video.dart';
class ShortVideosPage extends StatefulWidget {
  @override
  _ShortVideosPageState createState() => _ShortVideosPageState();
}

class _ShortVideosPageState extends State<ShortVideosPage> {
  int index = 0;
  List<Video> videos = [];
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () => setState(() => index = 0),
              child: Text("Followees",
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w200,
                    color: Colors.white,
                  )
              )
            ),
            GestureDetector(
              onTap: () => setState(() => index = 1),
                child: Text("Followees",
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    )
                ) 
            )
          ]
        )
      ),
      body: SafeArea(
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: videos.length,
            itemBuilder: (context, index) => Stack(
              children: [],
            ),
          )
      ),
    );
  }
}