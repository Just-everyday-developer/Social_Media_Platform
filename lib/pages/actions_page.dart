import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_platform/settings/font_slider.dart';

class ActionsPage extends StatefulWidget {
  const ActionsPage({super.key});

  @override
  _ActionsPageState createState() => _ActionsPageState();
}

class _ActionsPageState extends State<ActionsPage> {
  final List<String> filters = ["All", "Subscribers", "Answers", "Reposts"];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final fontSize = Provider.of<FontSlider>(context).sliderFontValue;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 20),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.deepPurpleAccent : Colors.grey[200],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            filters[index],
                            style: TextStyle(
                              fontSize: fontSize * 1.1,
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                "Showing: ${filters[selectedIndex]}",
                style: TextStyle(
                  fontSize: fontSize * 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
