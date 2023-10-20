import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileWidget extends StatelessWidget {
  final String? imagePath;
  final bool isEdit;
  final Function(File pickedImage)? onClicked;

  const ProfileWidget({
    Key? key,
    this.imagePath,
    this.onClicked,
    this.isEdit = false,
  }) : super(key: key);

  Future<void> _uploadImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null && onClicked != null) {
      // Convert XFile to File before calling the onClicked callback
      onClicked!(File(pickedImage.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isEdit == true) {
      return Center(
        child: Stack(
          children: [
            buildImage(),
            Positioned(
              bottom: 0,
              right: 4,
              child: InkWell(
                onTap: _uploadImage, // Call the image upload function
                child: buildEditIcon(),
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Stack(
          children: [
            buildImage(),
          ],
        ),
      );
    }
  }

  Widget buildImage() {
    if (imagePath == null || imagePath!.isEmpty) {
      return Container(
        width: 128,
        height: 128,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.orange,
            width: 3.0,
          ),
        ),
        child: ClipOval(
          child: Material(
            color: Colors.transparent,
            child: Image.network(
              'https://static.vecteezy.com/system/resources/previews/020/765/399/non_2x/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg',
              fit: BoxFit.cover,
              width: 128,
              height: 128,
            ),
          ),
        ),
      );
    } else if (imagePath!.startsWith('http')) {
      return ClipOval(
        child: Image.network(
          imagePath!,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
        ),
      );
    } else {
      return ClipOval(
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: FileImage(File(imagePath!)), // Use FileImage for local files
            fit: BoxFit.cover,
            width: 128,
            height: 128,
          ),
        ),
      );
    }
  }

  Widget buildEditIcon() => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: Colors.orange,
          all: 8,
          child: const Icon(
            Icons.add_a_photo,
            color: Colors.black,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
