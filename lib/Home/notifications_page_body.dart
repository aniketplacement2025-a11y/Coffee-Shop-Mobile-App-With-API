// notifications_page_body.dart
// import 'package:flutter/material.dart';
//
// class NotificationsPageBody extends StatelessWidget {
//   const NotificationsPageBody({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.all(30.0),
//         child: Center(
//           child: Text(
//             'Your Notifications Will Appear Here',
//             style: TextStyle(color: Colors.white, fontSize: 18),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class NotificationsPageBody extends StatelessWidget {
  const NotificationsPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulate a list of notifications (replace with actual data from your app state)
    List<Map<String, dynamic>> notifications = [
      {
        'type': 'new_launch',
        'message': '🎉 New Coffee Launched! Try our "Caramel Delight" today!',
        'time': '12:30 PM, Oct 27, 2025',
      },
      {
        'type': 'recommendation',
        'message': 'Based on your love for lattes, try our new "Vanilla Latte"!',
        'time': '12:00 PM, Oct 27, 2025',
      },
      {
        'type': 'order_thankyou',
        'message': 'Thank you for your order! Enjoy your Caffe Mocha!',
        'time': '11:45 AM, Oct 27, 2025',
      },
      {
        'type': 'promo',
        'message': 'Special Offer: 20% off your next purchase this week!',
        'time': '11:30 AM, Oct 27, 2025',
      },
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F4B4E),
              ),
            ),
            const SizedBox(height: 20),
            ...notifications.map((notification) => _buildNotificationCard(notification)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              _getNotificationIcon(notification['type']),
              color: const Color(0xFFC67C4E),
              size: 24,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification['message'],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2F4B4E),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    notification['time'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'new_launch':
        return Icons.campaign;
      case 'recommendation':
        return Icons.lightbulb;
      case 'order_thankyou':
        return Icons.favorite;
      case 'promo':
        return Icons.local_offer;
      default:
        return Icons.notifications;
    }
  }
}