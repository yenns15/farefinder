import 'dart:async';
import 'dart:io';
import 'package:farefinder/src/providers/client_provider.dart';
import 'package:farefinder/src/providers/conductor_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

    print('Configuraciones para iOS fueron registradas ${await _firebaseMessaging.getNotificationSettings()}');
  }
    
 void saveToken(String idUser, String typeUser) async {
    String? token = await _firebaseMessaging.getToken();
    Map<String, dynamic> data = {
      'token': token
    };

    if (typeUser == 'Clients') {
      ClientProvider clientProvider = new ClientProvider();
      clientProvider.update(data, idUser);
    }
    else {
      ConductorProvider conductorProvider = new ConductorProvider();
      conductorProvider.update(data, idUser);
    }

  }
    
  Future<void> dispose() async {
    await _streamController.close();
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('OnLaunch: ${message.data}');
    _streamController.sink.add(message.data);
  }
}

