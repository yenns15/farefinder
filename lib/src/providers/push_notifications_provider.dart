import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:farefinder/src/providers/client_provider.dart';
import 'package:farefinder/src/providers/conductor_provider.dart';
import 'package:farefinder/src/utils/shared_pref.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class PushNotificationsProvider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  StreamController<Map<String, dynamic>> _streamController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get message => _streamController.stream;

  Future<void> initPushNotifications() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Cuando estamos en primer plano');
      print('OnMessage: ${message.data}');
      _streamController.sink.add(message.data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('OnResume $message');
      _streamController.sink.add(message.data);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );

    print(
        'Configuraciones para iOS fueron registradas ${await _firebaseMessaging.getNotificationSettings()}');
  }

  void saveToken(String idUser, String typeUser) async {
    String? token = await _firebaseMessaging.getToken();
    Map<String, dynamic> data = {'token': token};

    if (typeUser == 'Clients') {
      ClientProvider clientProvider = new ClientProvider();
      clientProvider.update(data, idUser);
    } else {
      ConductorProvider conductorProvider = new ConductorProvider();
      conductorProvider.update(data, idUser);
    }
  }

  Future<void> sendMessage(
      String to, Map<String, dynamic> data, String title, String body) async {
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAA00RPKpU:APA91bE5GhPETrywnvLBgru6sndJ0pJ812c355xFkgcQ_APTmRYVoOGIEyG4RnsCyfvjhRyld-IctAItUGXa1mwGnaF_RjjCL_YBRAROwNmmWfBju3iDzBRzWTWh9Y8pIiuBVjceIGya'
        },
        body: jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'ttl': '4500s',
          'data': data,
          'to': to
        }));
  }

  Future<void> dispose() async {
    await _streamController.close();
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('OnLaunch: ${message.data}');
    _streamController.sink.add(message.data);
    SharedPref sharedPref = new SharedPref();
    sharedPref.save('isNotification', 'true');
  }
}
