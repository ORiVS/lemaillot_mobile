import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';

import '../../blocs/notifications/notification_cubit.dart';
import '../../blocs/notifications/notification_state.dart';
import '../../models/notification.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoaded) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      LucideIcons.bell,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Pas de notifications",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return NotificationCard(notification: notif);
              },
            );
          } else {
            return const Center(child: Text("Erreur lors du chargement."));
          }
        },
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  String _formatDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy à HH:mm', 'fr_FR').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!notification.isRead) {
          context.read<NotificationCubit>().markAsRead(notification.id);
        }
        // TODO: Ajouter redirection selon le type si nécessaire
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                const Icon(LucideIcons.bell, size: 28),
                if (!notification.isRead)
                  const Positioned(
                    top: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: Colors.red,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatDate(notification.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
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
}
