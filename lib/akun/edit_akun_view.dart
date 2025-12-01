import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gojek/constans.dart';

class EditAkunView extends StatefulWidget {
  const EditAkunView({super.key});

  @override
  State<EditAkunView> createState() => _EditAkunViewState();
}

class _EditAkunViewState extends State<EditAkunView> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiPasswordController = TextEditingController();

  bool _isLoading = false;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    if (_currentUser == null) return;
    
    _emailController.text = _currentUser!.email ?? '';
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).get();
      if (userDoc.exists && mounted) {
        setState(() {
          _namaController.text = userDoc.get('nama');
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _updateProfil() async {
    if (!_formKey.currentState!.validate() || _currentUser == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Update nama di Firestore (operasi tidak sensitif)
      await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).update({
        'nama': _namaController.text,
      });

      // 2. Update email jika berubah (operasi sensitif)
      if (_emailController.text != _currentUser!.email) {
        await _currentUser!.updateEmail(_emailController.text);
      }

      // 3. Update password jika diisi (operasi sensitif)
      if (_passwordController.text.isNotEmpty) {
        await _currentUser!.updatePassword(_passwordController.text);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui!'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      }

    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Terjadi kesalahan.';
      if (e.code == 'requires-recent-login') {
        errorMessage = 'Sesi Anda telah berakhir. Silakan login kembali untuk mengubah email atau password demi keamanan.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Email ini sudah digunakan oleh akun lain.';
      } else {
        errorMessage = 'Gagal memperbarui profil: ${e.message}';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan umum: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Akun'),
        backgroundColor: GoNesaPalette.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Masukkan email yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password Baru (opsional)'),
                obscureText: true,
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _konfirmasiPasswordController,
                decoration: const InputDecoration(labelText: 'Konfirmasi Password Baru'),
                obscureText: true,
                validator: (value) {
                  if (_passwordController.text.isNotEmpty && value != _passwordController.text) {
                    return 'Konfirmasi password tidak cocok';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _updateProfil,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GoNesaPalette.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
