import 'package:app/api/TaskGet.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotification() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> mostrarNotificacionTareaCercana(List<Task> tasks) async {
  // Filtrar las tareas para encontrar la más cercana
  Task? tareaCercana;
 tasks.forEach((task) {
  if (task.fecha != null) {
    DateTime fechaActual = DateTime.parse(task.fecha!);
    if (tareaCercana == null || fechaActual.isBefore(DateTime.parse(tareaCercana!.fecha!))) {
      tareaCercana = task;
    }
  }
});


  // Si se encontró una tarea cercana, mostrar la notificación
  if (tareaCercana != null) {
    // Configurar la notificación
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('chanelID', 'you');

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    // Construir el cuerpo de la notificación
    String titulo = 'Tarea más cercana';
    String mensaje =
        'Tarea: ${tareaCercana!.title}\nFecha: ${tareaCercana!.fecha.toString()}';

    // Mostrar la notificación
    await flutterLocalNotificationsPlugin.show(
      1, // ID de la notificación
      titulo, // Título de la notificación
      mensaje, // Cuerpo de la notificación
      notificationDetails, // Detalles de la notificación según la plataforma
    );
  }
}
