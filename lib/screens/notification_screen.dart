// lib/screens/notification_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifProvider = Provider.of<NotificationProvider>(context);
    final notifications = notifProvider.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi Saya'),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: () {
                notifProvider.clearAll();
              },
              child: Text('Hapus Semua', style: TextStyle(color: Colors.red.shade700)),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text('Tidak ada notifikasi baru.', style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (ctx, i) {
                
                return Dismissible(
                  key: ValueKey(notifications[i]),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                      // Tandai sebagai sudah dibaca (hapus)
                      final id = notifications[i].id;
                      notifProvider.markAsRead(id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Notifikasi ditandai sudah dibaca.')),
                      );
                    },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    elevation: 1,
                    child: ListTile(
                      leading: Icon(Icons.discount, color: Colors.green.shade700),
                      title: Text(notifications[i].title, style: const TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text('${notifications[i].date}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    ),
                  ),
                );
              },
            ),
    );
  }
}