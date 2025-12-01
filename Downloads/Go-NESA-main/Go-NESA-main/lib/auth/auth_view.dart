import 'package:flutter/material.dart';
import 'package:gojek/auth/auth_service.dart';
import 'package:gojek/landingpage/landingpage_view.dart';
import 'package:gojek/constans.dart';

class AuthView extends StatefulWidget {
  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool _isLoginMode = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      bool success = false;
      String message = '';

      try {
        if (_isLoginMode) {
          success = await AuthService.loginUser(_emailController.text, _passwordController.text);
          message = 'Email atau password salah.';
        } else {
          success = await AuthService.registerUser(_emailController.text, _passwordController.text);
          message = 'Email sudah terdaftar. Silakan login.';
        }
      } catch (e) {
        message = 'Terjadi kesalahan. Coba lagi.';
      }

      setState(() => _isLoading = false);

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LandingPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/Go.png',
                height: 100,
              ),
              SizedBox(height: 48),
              Text(
                _isLoginMode ? 'Selamat Datang Kembali' : 'Buat Akun Baru',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 24),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                          validator: (value) => (value == null || !value.contains('@')) ? 'Email tidak valid' : null,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                          validator: (value) => (value == null || value.length < 6) ? 'Password minimal 6 karakter' : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              _isLoading
                  ? Center(child: CircularProgressIndicator(color: GoNesaPalette.menuRide))
                  : ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GoNesaPalette.menuRide,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(_isLoginMode ? 'Login' : 'Daftar', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () => setState(() => _isLoginMode = !_isLoginMode),
                child: Text(
                  _isLoginMode ? 'Belum punya akun? Daftar di sini' : 'Sudah punya akun? Login di sini',
                  style: TextStyle(color: GoNesaPalette.menuRide, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
