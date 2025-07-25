import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_state.dart';
import '../../models/notification.dart';
import '../../repositories/notification_repository.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;

  NotificationCubit(this.repository) : super(NotificationLoading());

  Future<void> fetchNotifications() async {
    try {
      emit(NotificationLoading());
      final notifs = await repository.fetchNotifications();
      emit(NotificationLoaded(notifs));
    } catch (e) {
      emit(NotificationError('Erreur lors du chargement.'));
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await repository.markAsRead(id);

      // Mise à jour locale de l'état
      if (state is NotificationLoaded) {
        final current = (state as NotificationLoaded).notifications;
        final updated = current.map((notif) {
          if (notif.id == id) {
            return NotificationModel(
              id: notif.id,
              title: notif.title,
              message: notif.message,
              type: notif.type,
              isRead: true,
              createdAt: notif.createdAt,
            );
          }
          return notif;
        }).toList();

        emit(NotificationLoaded(updated));
      }
    } catch (e) {
      // Erreur silencieuse (ou log si tu veux)
    }
  }

  void deleteNotification(int id) {
    if (state is NotificationLoaded) {
      final current = (state as NotificationLoaded).notifications;
      final updated = current.where((notif) => notif.id != id).toList();
      emit(NotificationLoaded(updated));
    }
  }
}
