import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';
import 'package:gojek/landingpage/landingpage_view.dart';

// Dummy user data store
final List<Map<String, String>> _users = [];

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoginMode = true;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _toggleAuthMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
      _formKey.currentState?.reset();
    });
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : GoNesaPalette.green,
      ),
    );
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text;
    if (_users.any((user) => user['email'] == email)) {
      _showSnackbar('Email sudah terdaftar. Silakan masuk.', isError: true);
      return;
    }

    _users.add({
      'name': _nameController.text,
      'email': email,
      'password': _passwordController.text,
    });

    _showSnackbar('Pendaftaran berhasil! Silakan masuk.');
    _toggleAuthMode(); // Switch back to login mode
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final user = _users.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
      );

      // If user is found, navigate to home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LandingPage()),
      );
    } catch (e) {
      // If user is not found, show error
      _showSnackbar('Email atau password salah.', isError: true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 80),
              Image.asset('assets/Go.png', height: 120),
              Text(
                _isLoginMode ? 'Selamat Datang!' : 'Buat Akun Baru',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isLoginMode
                    ? 'Silakan masuk untuk melanjutkan'
                    : 'Isi data dirimu untuk mendaftar',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              if (!_isLoginMode) ...[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email atau nomor ponsel',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Email tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Password tidak boleh kosong' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoginMode ? _login : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor:GoNesaPalette.menuRide,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  _isLoginMode ? 'Masuk' : 'Daftar',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_isLoginMode ? 'Belum punya akun?' : 'Sudah punya akun?'),
                  TextButton(
                    onPressed: _toggleAuthMode,
                    child: Text(
                      _isLoginMode ? 'Daftar' : 'Masuk',
                      style:  TextStyle(
                        color: GoNesaPalette.menuRide,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
