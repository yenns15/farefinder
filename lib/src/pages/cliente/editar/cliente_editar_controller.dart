import 'dart:io';
import 'package:farefinder/src/providers/auth_provider.dart';
import 'package:farefinder/src/providers/client_provider.dart';
import 'package:farefinder/src/providers/storage_provider.dart';
import 'package:farefinder/src/utils/my_progress_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:farefinder/src/utils/snackbar.dart' as utils;
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';


class ClienteEditarController {
  late BuildContext context;
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  late Function refresh;

  final TextEditingController usernameController = TextEditingController();

  late AuthProvider _authProvider;
  late ClientProvider _clientProvider;
  late ProgressDialog _progressDialog;
  late StorageProvider _storageProvider;

  ImagePicker picker = ImagePicker();
  // late XFile image;
  File? imageFile;
  late PickedFile pickedFile;

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _authProvider = new AuthProvider();
    _clientProvider = new ClientProvider();
    _storageProvider = new StorageProvider();
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, 'Espere un momento');
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

  void update() async {
    final String username = usernameController.text;

    if (username.isEmpty) {
      print('Debe ingresar todos los campos');
      utils.Snackbar.showSnackbar(
          context, key, 'Debe ingresar todos los campos');
      return;
    }

    _progressDialog.show();
    TaskSnapshot snapshot = await _storageProvider.uploadFile(pickedFile);
    String imageUrl = await snapshot.ref.getDownloadURL();

    Map<String, dynamic> data = {'image': imageUrl};
    await _clientProvider.update(data, _authProvider.getUser()!.uid);
    _progressDialog.hide();
    utils.Snackbar.showSnackbar(context, key, 'Los datos se actualizaron');
  }

  Future<void> getImageFromGallery(ImageSource imageSource) async {
    pickedFile = (await picker.getImage(source: imageSource))!;

    if (pickedFile != null && pickedFile.path.isNotEmpty) {
      imageFile = File(pickedFile.path);
    } else {
      print('No se seleccionó ninguna imagen');
    }
    Navigator.pop(context);
    refresh();
  }
}
