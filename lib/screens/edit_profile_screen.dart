// lib/screens/edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<UserProvider>(context, listen: false);
    // Mengambil nama depan dan belakang dari nama lengkap saat ini
    final names = user.username.split(' ');
    _firstNameController.text = names.isNotEmpty ? names[0] : ''; 
    _lastNameController.text = names.length > 1 ? names.sublist(1).join(' ') : '';
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    Provider.of<UserProvider>(context, listen: false).updateProfile(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil Berhasil Diperbarui!'), backgroundColor: Colors.green));
    Navigator.of(context).pop();
  }
  
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Input Nama Depan
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Nama Depan', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Nama depan tidak boleh kosong.' : null,
              ),
              const SizedBox(height: 15),

              // Input Nama Belakang
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Nama Belakang', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 30),

              // Tombol Simpan
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('SIMPAN PERUBAHAN', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}