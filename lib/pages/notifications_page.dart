import 'package:flutter/material.dart';
import '../generated/l10n.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  
  
  
  List<NotificationItem> notifications = [];

  bool showUnreadOnly = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    _initializeNotifications();
  }

  void _initializeNotifications() {
    notifications = [
      NotificationItem(
        id: '1',
        title: S.of(context).notificationWelcomeTitle,
        message: S.of(context).notificationWelcomeMessage,
        timestamp: DateTime.now().subtract(Duration(minutes: 5)),
        type: NotificationType.welcome,
        isRead: false,
      ),
      NotificationItem(
        id: '2',
        title: S.of(context).notificationMessageTitle,
        message: S.of(context).notificationMessageBody(senderName: 'John Doe', messageContent: 'Hey, how are you doing?'),
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        type: NotificationType.message,
        isRead: false,
      ),
      NotificationItem(
        id: '3',
        title: S.of(context).notificationSystemTitle,
        message: S.of(context).notificationSystemMessage(version: '2.1.0'),
        timestamp: DateTime.now().subtract(Duration(hours: 6)),
        type: NotificationType.system,
        isRead: true,
      ),
      NotificationItem(
        id: '4',
        title: S.of(context).notificationReminderTitle,
        message: S.of(context).notificationReminderMessage(time: '3:00 PM'),
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        type: NotificationType.reminder,
        isRead: false,
      ),
      NotificationItem(
        id: '5',
        title: S.of(context).notificationPromotionTitle,
        message: S.of(context).notificationPromotionMessage(discount: 50),
        timestamp: DateTime.now().subtract(Duration(days: 2)),
        type: NotificationType.promotion,
        isRead: true,
      ),
      NotificationItem(
        id: '6',
        title: S.of(context).notificationSecurityTitle,
        message: S.of(context).notificationSecurityMessage(browser: 'Chrome', os: 'Windows'),
        timestamp: DateTime.now().subtract(Duration(days: 3)),
        type: NotificationType.security,
        isRead: false,
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {

    List<NotificationItem> filteredNotifications = showUnreadOnly
        ? notifications.where((n) => !n.isRead).toList()
        : notifications;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: Text(
          S.of(context).notificationsTitle, 
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.done_all),
            onPressed: _markAllAsRead,
            tooltip: S.of(context).markAllAsReadTooltip, 
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear_all') {
                _clearAllNotifications();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.clear_all, size: 20),
                    SizedBox(width: 8),
                    Text(S.of(context).clearAllMenuItem), 
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          
          Container(
            margin: EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  S.of(context).showUnreadOnly, 
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Switch(
                  value: showUnreadOnly,
                  onChanged: (value) {
                    setState(() {
                      showUnreadOnly = value;
                    });
                  },
                  activeColor: Colors.blue,
                ),
              ],
            ),
          ),

          
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      S.of(context).totalNotifications, 
                      notifications.length.toString(),
                      Colors.blue,
                      Icons.notifications,
                    ),
                    _buildStatItem(
                      S.of(context).unreadNotifications, 
                      notifications.where((n) => !n.isRead).length.toString(),
                      Colors.orange,
                      Icons.notifications_active,
                    ),
                    _buildStatItem(
                      S.of(context).todayNotifications, 
                      notifications.where((n) =>
                      DateTime.now().difference(n.timestamp).inDays == 0
                      ).length.toString(),
                      Colors.green,
                      Icons.today,
                    ),
                  ],
                ),
              ),
            ),
          ),

          
          Expanded(
            child: filteredNotifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredNotifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationItem(filteredNotifications[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: notification.isRead ? 1 : 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _markAsRead(notification.id),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: notification.isRead
                  ? null
                  : Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getNotificationColor(notification.type).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    color: _getNotificationColor(notification.type),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),

                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: notification.isRead
                                    ? FontWeight.w500
                                    : FontWeight.bold,
                                color: notification.isRead
                                    ? Colors.grey[700]
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        _getTimeAgo(notification.timestamp), 
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),

                
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      _deleteNotification(notification.id);
                    } else if (value == 'toggle_read') {
                      _toggleReadStatus(notification.id);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'toggle_read',
                      child: Row(
                        children: [
                          Icon(
                            notification.isRead ? Icons.mark_as_unread : Icons.done,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(notification.isRead ? S.of(context).markAsUnread : S.of(context).markAsRead), 
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text(S.of(context).deleteNotification, style: TextStyle(color: Colors.red)), 
                        ],
                      ),
                    ),
                  ],
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.grey[500],
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            showUnreadOnly ? Icons.notifications_off : Icons.notifications_none,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            showUnreadOnly ? S.of(context).noUnreadNotifications : S.of(context).noNotificationsYet, 
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            showUnreadOnly
                ? S.of(context).allCaughtUpMessage
                : S.of(context).noNotificationsMessage, 
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return Icons.message;
      case NotificationType.system:
        return Icons.system_update;
      case NotificationType.reminder:
        return Icons.schedule;
      case NotificationType.promotion:
        return Icons.local_offer;
      case NotificationType.security:
        return Icons.security;
      case NotificationType.welcome:
        return Icons.celebration;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return Colors.blue;
      case NotificationType.system:
        return Colors.purple;
      case NotificationType.reminder:
        return Colors.orange;
      case NotificationType.promotion:
        return Colors.green;
      case NotificationType.security:
        return Colors.red;
      case NotificationType.welcome:
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  String _getTimeAgo(DateTime timestamp) { 
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return S.of(context).timeAgoDays(difference.inDays); 
    } else if (difference.inHours > 0) {
      return S.of(context).timeAgoHours(difference.inHours); 
    } else if (difference.inMinutes > 0) {
      return S.of(context).timeAgoMinutes(difference.inMinutes); 
    } else {
      return S.of(context).justNow; 
    }
  }

  void _markAsRead(String id) {
    setState(() {
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        notifications[index].isRead = true;
      }
    });
  }

  void _toggleReadStatus(String id) {
    setState(() {
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        notifications[index].isRead = !notifications[index].isRead;
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
      }
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      notifications.removeWhere((n) => n.id == id);
    });
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).clearAllNotificationsTitle), 
          content: Text(S.of(context).clearAllNotificationsContent), 
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).cancelButton), 
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  notifications.clear();
                });
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).clearAllButton, style: TextStyle(color: Colors.red)), 
            ),
          ],
        );
      },
    );
  }
}


class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
}

enum NotificationType {
  message,
  system,
  reminder,
  promotion,
  security,
  welcome,
}