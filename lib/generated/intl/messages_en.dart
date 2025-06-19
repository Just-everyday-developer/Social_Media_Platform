// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(senderName, messageContent) =>
      "${senderName} sent you a message: \"${messageContent}\"";

  static String m1(discount) =>
      "Get ${discount}% off on premium subscription. Limited time offer!";

  static String m2(time) =>
      "Don\'t forget about your meeting at ${time} today.";

  static String m3(browser, os) =>
      "New login detected from ${browser} on ${os}. Was this you?";

  static String m4(version) =>
      "Your app has been updated to version ${version}. Check out the new features!";

  static String m5(title) => "Opening: ${title}";

  static String m6(days) => "${days}d ago";

  static String m7(hours) => "${hours}h ago";

  static String m8(minutes) => "${minutes}m ago";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "actions": MessageLookupByLibrary.simpleMessage("Actions"),
    "actionsPageTitle": MessageLookupByLibrary.simpleMessage("Actions"),
    "added_by_tapping": MessageLookupByLibrary.simpleMessage(
      "Added by tapping",
    ),
    "additional_info": MessageLookupByLibrary.simpleMessage(
      "This is additional information about this location",
    ),
    "address_hint_text": MessageLookupByLibrary.simpleMessage(
      "Enter address to search",
    ),
    "allCaughtUpMessage": MessageLookupByLibrary.simpleMessage(
      "All caught up! You have no unread notifications.",
    ),
    "answers": MessageLookupByLibrary.simpleMessage("Answers"),
    "button_retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelButton": MessageLookupByLibrary.simpleMessage("Cancel"),
    "category_business": MessageLookupByLibrary.simpleMessage("Business"),
    "category_entertainment": MessageLookupByLibrary.simpleMessage(
      "Entertainment",
    ),
    "category_health": MessageLookupByLibrary.simpleMessage("Health"),
    "category_science": MessageLookupByLibrary.simpleMessage("Science"),
    "category_sports": MessageLookupByLibrary.simpleMessage("Sports"),
    "category_technology": MessageLookupByLibrary.simpleMessage("Technology"),
    "clearAllButton": MessageLookupByLibrary.simpleMessage("Clear All"),
    "clearAllMenuItem": MessageLookupByLibrary.simpleMessage("Clear all"),
    "clearAllNotificationsContent": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete all notifications? This action cannot be undone.",
    ),
    "clearAllNotificationsTitle": MessageLookupByLibrary.simpleMessage(
      "Clear All Notifications",
    ),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "commentsLabel": MessageLookupByLibrary.simpleMessage("Comments"),
    "current_address": MessageLookupByLibrary.simpleMessage("Current Address"),
    "dark_theme": MessageLookupByLibrary.simpleMessage("Dark Theme"),
    "deleteNotification": MessageLookupByLibrary.simpleMessage("Delete"),
    "denied_permissions": MessageLookupByLibrary.simpleMessage(
      "Location permissions are denied",
    ),
    "enter_address_to_search": MessageLookupByLibrary.simpleMessage(
      "Enter address to search",
    ),
    "enter_page_error_message": MessageLookupByLibrary.simpleMessage(
      "Invalid email or password",
    ),
    "enter_page_github_sign_in_error": MessageLookupByLibrary.simpleMessage(
      "Github sign-in failed",
    ),
    "enter_page_google_sign_in_error": MessageLookupByLibrary.simpleMessage(
      "Google sign-in failed",
    ),
    "error_getting_location": MessageLookupByLibrary.simpleMessage(
      "Error getting location",
    ),
    "error_something_wrong": MessageLookupByLibrary.simpleMessage(
      "Something went wrong",
    ),
    "font_size": MessageLookupByLibrary.simpleMessage("The font size"),
    "footerText": MessageLookupByLibrary.simpleMessage(
      "Manage your social media experience",
    ),
    "forgot_password": MessageLookupByLibrary.simpleMessage("Forgot Password?"),
    "greeting": MessageLookupByLibrary.simpleMessage("Hello"),
    "hint_search_news": MessageLookupByLibrary.simpleMessage("Search news..."),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "justNow": MessageLookupByLibrary.simpleMessage("Just now"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "loadingText": MessageLookupByLibrary.simpleMessage("Loading..."),
    "login": MessageLookupByLibrary.simpleMessage("Log In"),
    "login_signup": MessageLookupByLibrary.simpleMessage("Login / Sign up"),
    "main_screen_snackbar": MessageLookupByLibrary.simpleMessage(
      "Search functionality for posts is not yet integrated with Firebase",
    ),
    "map": MessageLookupByLibrary.simpleMessage("Map"),
    "markAllAsReadTooltip": MessageLookupByLibrary.simpleMessage(
      "Mark all as read",
    ),
    "markAsRead": MessageLookupByLibrary.simpleMessage("Mark as read"),
    "markAsUnread": MessageLookupByLibrary.simpleMessage("Mark as unread"),
    "messageType": MessageLookupByLibrary.simpleMessage("Message"),
    "messages": MessageLookupByLibrary.simpleMessage("Messages"),
    "more_info": MessageLookupByLibrary.simpleMessage("Tap for more info"),
    "msg_enter_email": MessageLookupByLibrary.simpleMessage(
      "Please enter your email",
    ),
    "msg_enter_long_password": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 6 characters",
    ),
    "msg_enter_password": MessageLookupByLibrary.simpleMessage(
      "Please enter your password",
    ),
    "msg_enter_valid_email": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email",
    ),
    "newPostButtonTitle": MessageLookupByLibrary.simpleMessage("New Post"),
    "new_location": MessageLookupByLibrary.simpleMessage("New Location"),
    "news": MessageLookupByLibrary.simpleMessage("News"),
    "news_page_title": MessageLookupByLibrary.simpleMessage("News"),
    "noNotificationsMessage": MessageLookupByLibrary.simpleMessage(
      "When you receive notifications, they\'ll appear here.",
    ),
    "noNotificationsYet": MessageLookupByLibrary.simpleMessage(
      "No notifications yet",
    ),
    "noUnreadNotifications": MessageLookupByLibrary.simpleMessage(
      "No unread notifications",
    ),
    "no_articles_found": MessageLookupByLibrary.simpleMessage(
      "No articles found",
    ),
    "not_find_location": MessageLookupByLibrary.simpleMessage(
      "Could not find location",
    ),
    "not_have_account": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account?",
    ),
    "notificationMessageBody": m0,
    "notificationMessageTitle": MessageLookupByLibrary.simpleMessage(
      "New message received",
    ),
    "notificationPromotionMessage": m1,
    "notificationPromotionTitle": MessageLookupByLibrary.simpleMessage(
      "Special Offer",
    ),
    "notificationReminderMessage": m2,
    "notificationReminderTitle": MessageLookupByLibrary.simpleMessage(
      "Reminder",
    ),
    "notificationSecurityMessage": m3,
    "notificationSecurityTitle": MessageLookupByLibrary.simpleMessage(
      "Security Alert",
    ),
    "notificationSystemMessage": m4,
    "notificationSystemTitle": MessageLookupByLibrary.simpleMessage(
      "System Update",
    ),
    "notificationWelcomeMessage": MessageLookupByLibrary.simpleMessage(
      "Thanks for joining us. Explore all the amazing features we have to offer.",
    ),
    "notificationWelcomeTitle": MessageLookupByLibrary.simpleMessage(
      "Welcome to the app!",
    ),
    "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
    "notificationsTitle": MessageLookupByLibrary.simpleMessage("Notifications"),
    "opening_message": m5,
    "or_continue_with": MessageLookupByLibrary.simpleMessage(
      "or continue with",
    ),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "permanently_denied_permissions": MessageLookupByLibrary.simpleMessage(
      "Location permissions are permanently denied, please enable them in settings",
    ),
    "postManagementSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Post Management",
    ),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "promotionType": MessageLookupByLibrary.simpleMessage("Special Offer"),
    "quickActionsSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Quick Actions",
    ),
    "refreshButtonTitle": MessageLookupByLibrary.simpleMessage("Refresh"),
    "refreshSnackbarMessage": MessageLookupByLibrary.simpleMessage(
      "Posts are automatically refreshed in real-time",
    ),
    "register": MessageLookupByLibrary.simpleMessage("Register"),
    "remember_me": MessageLookupByLibrary.simpleMessage("Remember Me"),
    "reminderType": MessageLookupByLibrary.simpleMessage("Reminder"),
    "reposts": MessageLookupByLibrary.simpleMessage("Reposts"),
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "searchButtonTitle": MessageLookupByLibrary.simpleMessage("Search"),
    "search_for_location": MessageLookupByLibrary.simpleMessage(
      "Search for a location",
    ),
    "search_location": MessageLookupByLibrary.simpleMessage("Search Location"),
    "searched_location": MessageLookupByLibrary.simpleMessage(
      "Searched location",
    ),
    "securityType": MessageLookupByLibrary.simpleMessage("Security Alert"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "settingsButtonTitle": MessageLookupByLibrary.simpleMessage("Settings"),
    "showUnreadOnly": MessageLookupByLibrary.simpleMessage("Show unread only"),
    "showing": MessageLookupByLibrary.simpleMessage("Showing"),
    "sortPostsCardSubtitle": MessageLookupByLibrary.simpleMessage(
      "Sort posts by date or alphabetically",
    ),
    "sortPostsCardTitle": MessageLookupByLibrary.simpleMessage("Sort Posts"),
    "statisticsSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Statistics",
    ),
    "subscribers": MessageLookupByLibrary.simpleMessage("Subscribers"),
    "successful_login": MessageLookupByLibrary.simpleMessage(
      "Login Successful!",
    ),
    "systemType": MessageLookupByLibrary.simpleMessage("System Update"),
    "tab_categories": MessageLookupByLibrary.simpleMessage("Categories"),
    "tab_headlines": MessageLookupByLibrary.simpleMessage("Headlines"),
    "tab_search": MessageLookupByLibrary.simpleMessage("Search"),
    "timeAgoDays": m6,
    "timeAgoHours": m7,
    "timeAgoMinutes": m8,
    "title": MessageLookupByLibrary.simpleMessage("My Social Media Platform"),
    "todayNotifications": MessageLookupByLibrary.simpleMessage("Today"),
    "top_headlines_label": MessageLookupByLibrary.simpleMessage(
      "Top Headlines",
    ),
    "totalLikesLabel": MessageLookupByLibrary.simpleMessage("Total Likes"),
    "totalNotifications": MessageLookupByLibrary.simpleMessage("Total"),
    "totalPostsLabel": MessageLookupByLibrary.simpleMessage("Total Posts"),
    "unreadNotifications": MessageLookupByLibrary.simpleMessage("Unread"),
    "user": MessageLookupByLibrary.simpleMessage("User"),
    "videos": MessageLookupByLibrary.simpleMessage("Videos"),
    "welcomeType": MessageLookupByLibrary.simpleMessage("Welcome"),
    "welcome_back": MessageLookupByLibrary.simpleMessage("Welcome Back"),
    "you_are_here": MessageLookupByLibrary.simpleMessage("You are here"),
    "your_location": MessageLookupByLibrary.simpleMessage("Your Location"),
  };
}
