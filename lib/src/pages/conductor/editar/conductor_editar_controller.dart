import 'dart:io';

import 'package:farefinder/src/models/conductor.dart';
import 'package:farefinder/src/providers/auth_provider.dart';
import 'package:farefinder/src/providers/conductor_provider.dart';
import 'package:farefinder/src/providers/storage_provider.dart';
import 'package:farefinder/src/utils/my_progress_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:farefinder/src/utils/snackbar.dart' as utils;
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class ConductorEditarController {
  late BuildContext context;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  final TextEditingController usernameController = TextEditingController();

  TextEditingController pin1Controller = TextEditingController();
  TextEditingController pin2Controller = TextEditingController();
  TextEditingController pin3Controller = TextEditingController();
  TextEditingController pin4Controller = TextEditingController();
  TextEditingController pin5Controller = TextEditingController();
  TextEditingController pin6Controller = TextEditingController();

  late AuthProvider _authProvider;
  late ConductorProvider _conductorProvider;
  late StorageProvider _storageProvider;
  late ProgressDialog _progressDialog;

  ImagePicker picker = ImagePicker();
  File? imageFile;
  PickedFile? pickedFile;

  Conductor? conductor;

  late Function refresh;

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _authProvider = new AuthProvider();
    _conductorProvider = new ConductorProvider();
    _storageProvider = new StorageProvider();
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, 'Espere un momento');
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    conductor = await _conductorProvider.getById(_authProvider.getUser()!.uid);
    usernameController.text = conductor!.username;

    pin1Controller.text = conductor!.plate[0];
    pin2Controller.text = conductor!.plate[1];
    pin3Controller.text = conductor!.plate[2];
    pin4Controller.text = conductor!.plate[4];
    pin5Controller.text = conductor!.plate[5];
    pin6Controller.text = conductor!.plate[6];

    refresh();
  }

  void showAlertDialog() {
    Widget galleryButton = TextButton(
        onPressed: () {
          getImageFromGallery(ImageSource.gallery);
        },
        child: Text('GALERIA'));

    Widget cameraButton = TextButton(
        onPressed: () {
          getImageFromGallery(ImageSource.camera);
        },
        child: Text('CAMARA'));

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona tu imagen'),
      actions: [galleryButton, cameraButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  Future<void> getImageFromGallery(ImageSource imageSource) async {
    pickedFile = await picker.getImage(source: imageSource);

    if (pickedFile != null && pickedFile!.path.isNotEmpty) {
      imageFile = File(pickedFile!.path);
    } else {
      print('No se seleccionó ninguna imagen');
    }
    Navigator.pop(context);
    refresh();
  }

  void update() async {
    String username = usernameController.text;

    String pin1 = pin1Controller.text.trim();
    String pin2 = pin2Controller.text.trim();
    String pin3 = pin3Controller.text.trim();
    String pin4 = pin4Controller.text.trim();
    String pin5 = pin5Controller.text.trim();
    String pin6 = pin6Controller.text.trim();

    String plate = '$pin1$pin2$pin3-$pin4$pin5$pin6';

    if (username.isEmpty) {
      print('Debe ingresar todos los campos');
      utils.Snackbar.showSnackbar(
          context, key, 'Debe ingresar todos los campos');
      return;
    }

    _progressDialog.show();

    if (pickedFile == null) {
      Map<String, dynamic> data = {
        'username': username,
         'plate': plate,
      };

      await _conductorProvider.update(data, _authProvider.getUser()!.uid);
      _progressDialog.hide();
      refresh();
    } else {
      TaskSnapshot snapshot = await _storageProvider.uploadFile(pickedFile!);
      String imageUrl = await snapshot.ref.getDownloadURL();
      Map<String, dynamic> data = {
        'image': imageUrl,
        'username': username,
         'plate': plate,
      };

      await _conductorProvider.update(data, _authProvider.getUser()!.uid);
    }

    _progressDialog.hide();

    utils.Snackbar.showSnackbar(context, key, 'Los datos se actualizaron');
    refresh();
  }
}
