// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `My Social Media Platform`
  String get title {
    return Intl.message(
      'My Social Media Platform',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Actions`
  String get actions {
    return Intl.message('Actions', name: 'actions', desc: '', args: []);
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Map`
  String get map {
    return Intl.message('Map', name: 'map', desc: '', args: []);
  }

  /// `Videos`
  String get videos {
    return Intl.message('Videos', name: 'videos', desc: '', args: []);
  }

  /// `News`
  String get news {
    return Intl.message('News', name: 'news', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Search functionality for posts is not yet integrated with Firebase`
  String get main_screen_snackbar {
    return Intl.message(
      'Search functionality for posts is not yet integrated with Firebase',
      name: 'main_screen_snackbar',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get greeting {
    return Intl.message('Hello', name: 'greeting', desc: '', args: []);
  }

  /// `User`
  String get user {
    return Intl.message('User', name: 'user', desc: '', args: []);
  }

  /// `Login / Sign up`
  String get login_signup {
    return Intl.message(
      'Login / Sign up',
      name: 'login_signup',
      desc: '',
      args: [],
    );
  }

  /// `Search Location`
  String get search_location {
    return Intl.message(
      'Search Location',
      name: 'search_location',
      desc: '',
      args: [],
    );
  }

  /// `Enter address to search`
  String get address_hint_text {
    return Intl.message(
      'Enter address to search',
      name: 'address_hint_text',
      desc: '',
      args: [],
    );
  }

  /// `Messages`
  String get messages {
    return Intl.message('Messages', name: 'messages', desc: '', args: []);
  }

  /// `Dark Theme`
  String get dark_theme {
    return Intl.message('Dark Theme', name: 'dark_theme', desc: '', args: []);
  }

  /// `The font size`
  String get font_size {
    return Intl.message('The font size', name: 'font_size', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Subscribers`
  String get subscribers {
    return Intl.message('Subscribers', name: 'subscribers', desc: '', args: []);
  }

  /// `Answers`
  String get answers {
    return Intl.message('Answers', name: 'answers', desc: '', args: []);
  }

  /// `Reposts`
  String get reposts {
    return Intl.message('Reposts', name: 'reposts', desc: '', args: []);
  }

  /// `Showing`
  String get showing {
    return Intl.message('Showing', name: 'showing', desc: '', args: []);
  }

  /// `Tap for more info`
  String get more_info {
    return Intl.message(
      'Tap for more info',
      name: 'more_info',
      desc: '',
      args: [],
    );
  }

  /// `Location permissions are denied`
  String get denied_permissions {
    return Intl.message(
      'Location permissions are denied',
      name: 'denied_permissions',
      desc: '',
      args: [],
    );
  }

  /// `Location permissions are permanently denied, please enable them in settings`
  String get permanently_denied_permissions {
    return Intl.message(
      'Location permissions are permanently denied, please enable them in settings',
      name: 'permanently_denied_permissions',
      desc: '',
      args: [],
    );
  }

  /// `Your Location`
  String get your_location {
    return Intl.message(
      'Your Location',
      name: 'your_location',
      desc: '',
      args: [],
    );
  }

  /// `Search for a location`
  String get search_for_location {
    return Intl.message(
      'Search for a location',
      name: 'search_for_location',
      desc: '',
      args: [],
    );
  }

  /// `You are here`
  String get you_are_here {
    return Intl.message(
      'You are here',
      name: 'you_are_here',
      desc: '',
      args: [],
    );
  }

  /// `Error getting location`
  String get error_getting_location {
    return Intl.message(
      'Error getting location',
      name: 'error_getting_location',
      desc: '',
      args: [],
    );
  }

  /// `Searched location`
  String get searched_location {
    return Intl.message(
      'Searched location',
      name: 'searched_location',
      desc: '',
      args: [],
    );
  }

  /// `Could not find location`
  String get not_find_location {
    return Intl.message(
      'Could not find location',
      name: 'not_find_location',
      desc: '',
      args: [],
    );
  }

  /// `This is additional information about this location`
  String get additional_info {
    return Intl.message(
      'This is additional information about this location',
      name: 'additional_info',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `New Location`
  String get new_location {
    return Intl.message(
      'New Location',
      name: 'new_location',
      desc: '',
      args: [],
    );
  }

  /// `Added by tapping`
  String get added_by_tapping {
    return Intl.message(
      'Added by tapping',
      name: 'added_by_tapping',
      desc: '',
      args: [],
    );
  }

  /// `Current Address`
  String get current_address {
    return Intl.message(
      'Current Address',
      name: 'current_address',
      desc: '',
      args: [],
    );
  }

  /// `Enter address to search`
  String get enter_address_to_search {
    return Intl.message(
      'Enter address to search',
      name: 'enter_address_to_search',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email or password`
  String get enter_page_error_message {
    return Intl.message(
      'Invalid email or password',
      name: 'enter_page_error_message',
      desc: '',
      args: [],
    );
  }

  /// `Google sign-in failed`
  String get enter_page_google_sign_in_error {
    return Intl.message(
      'Google sign-in failed',
      name: 'enter_page_google_sign_in_error',
      desc: '',
      args: [],
    );
  }

  /// `Github sign-in failed`
  String get enter_page_github_sign_in_error {
    return Intl.message(
      'Github sign-in failed',
      name: 'enter_page_github_sign_in_error',
      desc: '',
      args: [],
    );
  }

  /// `Login Successful!`
  String get successful_login {
    return Intl.message(
      'Login Successful!',
      name: 'successful_login',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back`
  String get welcome_back {
    return Intl.message(
      'Welcome Back',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get msg_enter_email {
    return Intl.message(
      'Please enter your email',
      name: 'msg_enter_email',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get msg_enter_valid_email {
    return Intl.message(
      'Please enter a valid email',
      name: 'msg_enter_valid_email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Please enter your password`
  String get msg_enter_password {
    return Intl.message(
      'Please enter your password',
      name: 'msg_enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get msg_enter_long_password {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'msg_enter_long_password',
      desc: '',
      args: [],
    );
  }

  /// `Remember Me`
  String get remember_me {
    return Intl.message('Remember Me', name: 'remember_me', desc: '', args: []);
  }

  /// `Forgot Password?`
  String get forgot_password {
    return Intl.message(
      'Forgot Password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get login {
    return Intl.message('Log In', name: 'login', desc: '', args: []);
  }

  /// `or continue with`
  String get or_continue_with {
    return Intl.message(
      'or continue with',
      name: 'or_continue_with',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get not_have_account {
    return Intl.message(
      'Don\'t have an account?',
      name: 'not_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `News`
  String get news_page_title {
    return Intl.message('News', name: 'news_page_title', desc: '', args: []);
  }

  /// `Headlines`
  String get tab_headlines {
    return Intl.message('Headlines', name: 'tab_headlines', desc: '', args: []);
  }

  /// `Search`
  String get tab_search {
    return Intl.message('Search', name: 'tab_search', desc: '', args: []);
  }

  /// `Categories`
  String get tab_categories {
    return Intl.message(
      'Categories',
      name: 'tab_categories',
      desc: '',
      args: [],
    );
  }

  /// `Top Headlines`
  String get top_headlines_label {
    return Intl.message(
      'Top Headlines',
      name: 'top_headlines_label',
      desc: '',
      args: [],
    );
  }

  /// `Search news...`
  String get hint_search_news {
    return Intl.message(
      'Search news...',
      name: 'hint_search_news',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get error_something_wrong {
    return Intl.message(
      'Something went wrong',
      name: 'error_something_wrong',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get button_retry {
    return Intl.message('Retry', name: 'button_retry', desc: '', args: []);
  }

  /// `No articles found`
  String get no_articles_found {
    return Intl.message(
      'No articles found',
      name: 'no_articles_found',
      desc: '',
      args: [],
    );
  }

  /// `Opening: {title}`
  String opening_message(Object title) {
    return Intl.message(
      'Opening: $title',
      name: 'opening_message',
      desc: '',
      args: [title],
    );
  }

  /// `Technology`
  String get category_technology {
    return Intl.message(
      'Technology',
      name: 'category_technology',
      desc: '',
      args: [],
    );
  }

  /// `Sports`
  String get category_sports {
    return Intl.message('Sports', name: 'category_sports', desc: '', args: []);
  }

  /// `Business`
  String get category_business {
    return Intl.message(
      'Business',
      name: 'category_business',
      desc: '',
      args: [],
    );
  }

  /// `Health`
  String get category_health {
    return Intl.message('Health', name: 'category_health', desc: '', args: []);
  }

  /// `Science`
  String get category_science {
    return Intl.message(
      'Science',
      name: 'category_science',
      desc: '',
      args: [],
    );
  }

  /// `Entertainment`
  String get category_entertainment {
    return Intl.message(
      'Entertainment',
      name: 'category_entertainment',
      desc: '',
      args: [],
    );
  }

  /// `Actions`
  String get actionsPageTitle {
    return Intl.message(
      'Actions',
      name: 'actionsPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Post Management`
  String get postManagementSectionTitle {
    return Intl.message(
      'Post Management',
      name: 'postManagementSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sort Posts`
  String get sortPostsCardTitle {
    return Intl.message(
      'Sort Posts',
      name: 'sortPostsCardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sort posts by date or alphabetically`
  String get sortPostsCardSubtitle {
    return Intl.message(
      'Sort posts by date or alphabetically',
      name: 'sortPostsCardSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Quick Actions`
  String get quickActionsSectionTitle {
    return Intl.message(
      'Quick Actions',
      name: 'quickActionsSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `New Post`
  String get newPostButtonTitle {
    return Intl.message(
      'New Post',
      name: 'newPostButtonTitle',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get searchButtonTitle {
    return Intl.message(
      'Search',
      name: 'searchButtonTitle',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refreshButtonTitle {
    return Intl.message(
      'Refresh',
      name: 'refreshButtonTitle',
      desc: '',
      args: [],
    );
  }

  /// `Posts are automatically refreshed in real-time`
  String get refreshSnackbarMessage {
    return Intl.message(
      'Posts are automatically refreshed in real-time',
      name: 'refreshSnackbarMessage',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsButtonTitle {
    return Intl.message(
      'Settings',
      name: 'settingsButtonTitle',
      desc: '',
      args: [],
    );
  }

  /// `Statistics`
  String get statisticsSectionTitle {
    return Intl.message(
      'Statistics',
      name: 'statisticsSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Total Posts`
  String get totalPostsLabel {
    return Intl.message(
      'Total Posts',
      name: 'totalPostsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Total Likes`
  String get totalLikesLabel {
    return Intl.message(
      'Total Likes',
      name: 'totalLikesLabel',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get commentsLabel {
    return Intl.message('Comments', name: 'commentsLabel', desc: '', args: []);
  }

  /// `Loading...`
  String get loadingText {
    return Intl.message('Loading...', name: 'loadingText', desc: '', args: []);
  }

  /// `Manage your social media experience`
  String get footerText {
    return Intl.message(
      'Manage your social media experience',
      name: 'footerText',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notificationsTitle {
    return Intl.message(
      'Notifications',
      name: 'notificationsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Mark all as read`
  String get markAllAsReadTooltip {
    return Intl.message(
      'Mark all as read',
      name: 'markAllAsReadTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Clear all`
  String get clearAllMenuItem {
    return Intl.message(
      'Clear all',
      name: 'clearAllMenuItem',
      desc: '',
      args: [],
    );
  }

  /// `Show unread only`
  String get showUnreadOnly {
    return Intl.message(
      'Show unread only',
      name: 'showUnreadOnly',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get totalNotifications {
    return Intl.message(
      'Total',
      name: 'totalNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Unread`
  String get unreadNotifications {
    return Intl.message(
      'Unread',
      name: 'unreadNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get todayNotifications {
    return Intl.message(
      'Today',
      name: 'todayNotifications',
      desc: '',
      args: [],
    );
  }

  /// `No unread notifications`
  String get noUnreadNotifications {
    return Intl.message(
      'No unread notifications',
      name: 'noUnreadNotifications',
      desc: '',
      args: [],
    );
  }

  /// `All caught up! You have no unread notifications.`
  String get allCaughtUpMessage {
    return Intl.message(
      'All caught up! You have no unread notifications.',
      name: 'allCaughtUpMessage',
      desc: '',
      args: [],
    );
  }

  /// `No notifications yet`
  String get noNotificationsYet {
    return Intl.message(
      'No notifications yet',
      name: 'noNotificationsYet',
      desc: '',
      args: [],
    );
  }

  /// `When you receive notifications, they'll appear here.`
  String get noNotificationsMessage {
    return Intl.message(
      'When you receive notifications, they\'ll appear here.',
      name: 'noNotificationsMessage',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get messageType {
    return Intl.message('Message', name: 'messageType', desc: '', args: []);
  }

  /// `System Update`
  String get systemType {
    return Intl.message(
      'System Update',
      name: 'systemType',
      desc: '',
      args: [],
    );
  }

  /// `Reminder`
  String get reminderType {
    return Intl.message('Reminder', name: 'reminderType', desc: '', args: []);
  }

  /// `Special Offer`
  String get promotionType {
    return Intl.message(
      'Special Offer',
      name: 'promotionType',
      desc: '',
      args: [],
    );
  }

  /// `Security Alert`
  String get securityType {
    return Intl.message(
      'Security Alert',
      name: 'securityType',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcomeType {
    return Intl.message('Welcome', name: 'welcomeType', desc: '', args: []);
  }

  /// `{days}d ago`
  String timeAgoDays(Object days) {
    return Intl.message(
      '${days}d ago',
      name: 'timeAgoDays',
      desc: '',
      args: [days],
    );
  }

  /// `{hours}h ago`
  String timeAgoHours(Object hours) {
    return Intl.message(
      '${hours}h ago',
      name: 'timeAgoHours',
      desc: '',
      args: [hours],
    );
  }

  /// `{minutes}m ago`
  String timeAgoMinutes(Object minutes) {
    return Intl.message(
      '${minutes}m ago',
      name: 'timeAgoMinutes',
      desc: '',
      args: [minutes],
    );
  }

  /// `Just now`
  String get justNow {
    return Intl.message('Just now', name: 'justNow', desc: '', args: []);
  }

  /// `Mark as unread`
  String get markAsUnread {
    return Intl.message(
      'Mark as unread',
      name: 'markAsUnread',
      desc: '',
      args: [],
    );
  }

  /// `Mark as read`
  String get markAsRead {
    return Intl.message('Mark as read', name: 'markAsRead', desc: '', args: []);
  }

  /// `Delete`
  String get deleteNotification {
    return Intl.message(
      'Delete',
      name: 'deleteNotification',
      desc: '',
      args: [],
    );
  }

  /// `Clear All Notifications`
  String get clearAllNotificationsTitle {
    return Intl.message(
      'Clear All Notifications',
      name: 'clearAllNotificationsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete all notifications? This action cannot be undone.`
  String get clearAllNotificationsContent {
    return Intl.message(
      'Are you sure you want to delete all notifications? This action cannot be undone.',
      name: 'clearAllNotificationsContent',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelButton {
    return Intl.message('Cancel', name: 'cancelButton', desc: '', args: []);
  }

  /// `Clear All`
  String get clearAllButton {
    return Intl.message(
      'Clear All',
      name: 'clearAllButton',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the app!`
  String get notificationWelcomeTitle {
    return Intl.message(
      'Welcome to the app!',
      name: 'notificationWelcomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Thanks for joining us. Explore all the amazing features we have to offer.`
  String get notificationWelcomeMessage {
    return Intl.message(
      'Thanks for joining us. Explore all the amazing features we have to offer.',
      name: 'notificationWelcomeMessage',
      desc: '',
      args: [],
    );
  }

  /// `New message received`
  String get notificationMessageTitle {
    return Intl.message(
      'New message received',
      name: 'notificationMessageTitle',
      desc: '',
      args: [],
    );
  }

  /// `{senderName} sent you a message: "{messageContent}"`
  String notificationMessageBody({required Object senderName, required Object messageContent}) {
    return Intl.message(
      '$senderName sent you a message: "$messageContent"',
      name: 'notificationMessageBody',
      desc: '',
      args: [senderName, messageContent],
    );
  }

  /// `System Update`
  String get notificationSystemTitle {
    return Intl.message(
      'System Update',
      name: 'notificationSystemTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your app has been updated to version {version}. Check out the new features!`
  String notificationSystemMessage({required Object version}) {
    return Intl.message(
      'Your app has been updated to version $version. Check out the new features!',
      name: 'notificationSystemMessage',
      desc: '',
      args: [version],
    );
  }

  /// `Reminder`
  String get notificationReminderTitle {
    return Intl.message(
      'Reminder',
      name: 'notificationReminderTitle',
      desc: '',
      args: [],
    );
  }

  /// `Don't forget about your meeting at {time} today.`
  String notificationReminderMessage({required Object time}) {
    return Intl.message(
      'Don\'t forget about your meeting at $time today.',
      name: 'notificationReminderMessage',
      desc: '',
      args: [time],
    );
  }

  /// `Special Offer`
  String get notificationPromotionTitle {
    return Intl.message(
      'Special Offer',
      name: 'notificationPromotionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Get {discount}% off on premium subscription. Limited time offer!`
  String notificationPromotionMessage({required Object discount}) {
    return Intl.message(
      'Get $discount% off on premium subscription. Limited time offer!',
      name: 'notificationPromotionMessage',
      desc: '',
      args: [discount],
    );
  }

  /// `Security Alert`
  String get notificationSecurityTitle {
    return Intl.message(
      'Security Alert',
      name: 'notificationSecurityTitle',
      desc: '',
      args: [],
    );
  }

  /// `New login detected from {browser} on {os}. Was this you?`
  String notificationSecurityMessage({required Object browser, required Object os}) {
    return Intl.message(
      'New login detected from $browser on $os. Was this you?',
      name: 'notificationSecurityMessage',
      desc: '',
      args: [browser, os],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'kk'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
