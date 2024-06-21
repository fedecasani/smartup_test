import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      await _uploadImageToFirebase();
    }
  }

  Future<void> _uploadImageToFirebase() async {
    if (_imageFile == null) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${user.uid}.jpg');

        final uploadTask = storageRef.putFile(_imageFile!);

        // Monitor the upload progress
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          print('Task state: ${snapshot.state}'); // paused, running, complete
          print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
        }, onError: (e) {
          print(uploadTask.snapshot);
          print('Error: $e');
        });

        await uploadTask.whenComplete(() => null);

        final downloadUrl = await storageRef.getDownloadURL();

        await user.updatePhotoURL(downloadUrl);
        await user.reload();
        setState(() {}); // Update UI with new photo URL
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pushNamed(context, "/home");
          },
        ),
        title: Text('Profile', style: TextStyle(color: Colors.blue)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(user?.photoURL ?? 'https://via.placeholder.com/150'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.camera_alt, color: Colors.blue),
                      onPressed: _pickImage,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                user?.displayName ?? 'N/A',
                style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(
                user?.email ?? 'No email',
                style: TextStyle(color: Colors.white70, fontSize: 16.0),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, "/register");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text('Logout', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
