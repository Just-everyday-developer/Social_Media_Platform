
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_platform/settings/font_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_platform/pages/post_sorting_page.dart';
import '../generated/l10n.dart';
import '../models/PostMaker.dart';
import '../models/PostSearchDelegate.dart';
import '../services/firebase_post_service.dart';
import '../generated/l10n.dart';

class ActionsPage extends StatelessWidget {
  const ActionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fontSlider = Provider.of<FontSlider>(context);
    final currentFontSize = fontSlider.sliderFontValue;
    

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).actionsPageTitle, 
              style: GoogleFonts.roboto(
                fontSize: currentFontSize + 8,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            
            _buildSectionTitle(S.of(context).postManagementSectionTitle, currentFontSize, context), 
            const SizedBox(height: 16),

            
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.sort,
                    color: Colors.blue,
                    size: currentFontSize + 4,
                  ),
                ),
                title: Text(
                  S.of(context).sortPostsCardTitle, 
                  style: GoogleFonts.roboto(
                    fontSize: currentFontSize + 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  S.of(context).sortPostsCardSubtitle, 
                  style: GoogleFonts.roboto(
                    fontSize: currentFontSize - 2,
                    color: Colors.grey[600],
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: currentFontSize,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PostSortingPage(),
                      ),
                    );
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PostSortingPage(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            
            _buildSectionTitle(S.of(context).quickActionsSectionTitle, currentFontSize, context), 
            const SizedBox(height: 16),

            
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.add_circle_outline,
                    title: S.of(context).newPostButtonTitle, 
                    color: Colors.green,
                    fontSize: currentFontSize,
                    onTap: () async {
                      await showDialog<bool>(
                        context: context,
                        builder: (context) => const PostMaker(),
                      );
                    },
                    context: context, 
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.search,
                    title: S.of(context).searchButtonTitle, 
                    color: Colors.orange,
                    fontSize: currentFontSize,
                    onTap: () async {
                      final service = FirebasePostService();
                      final allPosts = await service.getPostsOnce();
                      if (!context.mounted) return;
                      await showSearch(
                        context: context,
                        delegate: PostSearchDelegate(allPosts),
                      );
                    },
                    context: context, 
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.refresh,
                    title: S.of(context).refreshButtonTitle, 
                    color: Colors.purple,
                    fontSize: currentFontSize,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            S.of(context).refreshSnackbarMessage, 
                            style: GoogleFonts.roboto(fontSize: currentFontSize - 2),
                          ),
                        ),
                      );
                    },
                    context: context, 
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.settings,
                    title: S.of(context).settingsButtonTitle, 
                    color: Colors.teal,
                    fontSize: currentFontSize,
                    onTap: () {
                      context.go('/settings');
                    },
                    context: context, 
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            
            _buildSectionTitle(S.of(context).statisticsSectionTitle, currentFontSize, context), 
            const SizedBox(height: 16),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          icon: Icons.article,
                          label: S.of(context).totalPostsLabel, 
                          value: S.of(context).loadingText, 
                          color: Colors.blue,
                          fontSize: currentFontSize,
                          context: context, 
                        ),
                        _buildStatItem(
                          icon: Icons.favorite,
                          label: S.of(context).totalLikesLabel, 
                          value: S.of(context).loadingText, 
                          color: Colors.red,
                          fontSize: currentFontSize,
                          context: context, 
                        ),
                        _buildStatItem(
                          icon: Icons.comment,
                          label: S.of(context).commentsLabel, 
                          value: S.of(context).loadingText, 
                          color: Colors.green,
                          fontSize: currentFontSize,
                          context: context, 
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            
            Center(
              child: Text(
                S.of(context).footerText, 
                style: GoogleFonts.roboto(
                  fontSize: currentFontSize - 2,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  
  
  Widget _buildSectionTitle(String titleKey, double fontSize, BuildContext context) {
    
    return Text(
      titleKey, 
      style: GoogleFonts.roboto(
        fontSize: fontSize + 4,
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title, 
    required Color color,
    required double fontSize,
    required VoidCallback onTap,
    required BuildContext context, 
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: fontSize + 6,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title, 
                style: GoogleFonts.roboto(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label, 
    required String value, 
    required Color color,
    required double fontSize,
    required BuildContext context, 
  }) {
    
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: fontSize + 4,
        ),
        const SizedBox(height: 8),
        Text(
          value, 
          style: GoogleFonts.roboto(
            fontSize: fontSize + 2,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label, 
          style: GoogleFonts.roboto(
            fontSize: fontSize - 2,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}