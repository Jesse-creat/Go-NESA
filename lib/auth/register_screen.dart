import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';
import 'package:gojek/auth/auth_service.dart';
import 'package:gojek/auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
    
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade600 : const Color(0xFF00AA13),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_acceptTerms) {
      _showSnackbar('Harap setujui syarat dan ketentuan', isError: true);
      return;
    }
    
    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackbar('Password tidak cocok', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    try {
      final success = await AuthService.registerUser(
        email,
        password,
        name: name.isNotEmpty ? name : null,
        phone: phone.isNotEmpty ? phone : null,
      );

      setState(() => _isLoading = false);

      if (success) {
        _showSnackbar('Pendaftaran berhasil! Silakan masuk dengan akun Anda.');
        if (mounted) {
          // Kembali ke LoginScreen setelah registrasi berhasil
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
        }
      } else {
        _showSnackbar('Email mungkin sudah terdaftar', isError: true);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackbar('Terjadi kesalahan. Silakan coba lagi.', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Container(
        height: screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF00AA13),
              const Color(0xFF00C91D),
              const Color(0xFF00AA13),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -120,
              left: -120,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -100,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.4,
              right: -60,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFF400).withOpacity(0.1),
                ),
              ),
            ),
            
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          
                          // Back button
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Logo section
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/Go.png',
                              height: 50,
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Title
                          const Text(
                            'Buat Akun Baru',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Bergabunglah dengan jutaan pengguna',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withOpacity(0.9),
                              height: 1.5,
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Progress indicator
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                _buildStepIndicator(0, 'Info'),
                                Expanded(
                                  child: Container(
                                    height: 2,
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                ),
                                _buildStepIndicator(1, 'Akun'),
                                Expanded(
                                  child: Container(
                                    height: 2,
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                ),
                                _buildStepIndicator(2, 'Selesai'),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Form card
                          Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Name field
                                  _buildTextField(
                                    controller: _nameController,
                                    label: 'Nama Lengkap',
                                    hint: 'Masukkan nama lengkap Anda',
                                    icon: Icons.person_outline,
                                    validator: (value) {
                                      if (value!.isEmpty) return 'Nama tidak boleh kosong';
                                      if (value.length < 2) return 'Nama minimal 2 karakter';
                                      return null;
                                    },
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Phone field
                                  _buildTextField(
                                    controller: _phoneController,
                                    label: 'Nomor Telepon',
                                    hint: '08xxxxxxxxxx',
                                    icon: Icons.phone_outlined,
                                    keyboardType: TextInputType.phone,
                                    validator: (value) {
                                      if (value!.isEmpty) return 'Nomor telepon tidak boleh kosong';
                                      if (value.length < 10) return 'Nomor telepon minimal 10 digit';
                                      return null;
                                    },
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Email field
                                  _buildTextField(
                                    controller: _emailController,
                                    label: 'Email',
                                    hint: 'nama@email.com',
                                    icon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value!.isEmpty) return 'Email tidak boleh kosong';
                                      if (!value.contains('@')) return 'Email tidak valid';
                                      return null;
                                    },
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Password field
                                  _buildTextField(
                                    controller: _passwordController,
                                    label: 'Password',
                                    hint: 'Minimal 6 karakter',
                                    icon: Icons.lock_outlined,
                                    obscureText: _obscurePassword,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: Colors.grey[600],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) return 'Password tidak boleh kosong';
                                      if (value.length < 6) return 'Password minimal 6 karakter';
                                      return null;
                                    },
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Confirm password field
                                  _buildTextField(
                                    controller: _confirmPasswordController,
                                    label: 'Konfirmasi Password',
                                    hint: 'Masukkan ulang password',
                                    icon: Icons.lock_outlined,
                                    obscureText: _obscureConfirmPassword,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: Colors.grey[600],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword = !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) return 'Konfirmasi password tidak boleh kosong';
                                      if (value != _passwordController.text) {
                                        return 'Password tidak cocok';
                                      }
                                      return null;
                                    },
                                  ),
                                  
                                  const SizedBox(height: 20),
                                  
                                  // Terms checkbox
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _acceptTerms = !_acceptTerms;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: _acceptTerms
                                              ? const Color(0xFF00AA13)
                                              : Colors.grey.withOpacity(0.2),
                                          width: _acceptTerms ? 2 : 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: _acceptTerms
                                                  ? const Color(0xFF00AA13)
                                                  : Colors.transparent,
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(
                                                color: _acceptTerms
                                                    ? const Color(0xFF00AA13)
                                                    : Colors.grey[400]!,
                                                width: 2,
                                              ),
                                            ),
                                            child: _acceptTerms
                                                ? const Icon(
                                                    Icons.check,
                                                    size: 16,
                                                    color: Colors.white,
                                                  )
                                                : null,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[700],
                                                ),
                                                children: const [
                                                  TextSpan(text: 'Saya menyetujui '),
                                                  TextSpan(
                                                    text: 'Syarat & Ketentuan',
                                                    style: TextStyle(
                                                      color: Color(0xFF00AA13),
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  TextSpan(text: ' dan '),
                                                  TextSpan(
                                                    text: 'Kebijakan Privasi',
                                                    style: TextStyle(
                                                      color: Color(0xFF00AA13),
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 24),
                                  
                                  // Register button
                                  ElevatedButton(
                                    onPressed: _isLoading ? null : _register,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF00AA13),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 18),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      disabledBackgroundColor: Colors.grey[300],
                                    ),
                                    child: _isLoading
                                        ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                height: 22,
                                                width: 22,
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2.5,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                'Mendaftarkan...',
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.9),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          )
                                        : const Text(
                                            'Daftar Sekarang',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                  ),
                                  
                                  const SizedBox(height: 24),
                                  
                                  // Divider
                                  Row(
                                    children: [
                                      Expanded(child: Divider(color: Colors.grey[300])),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Text(
                                          'atau',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      Expanded(child: Divider(color: Colors.grey[300])),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 20),
                                  
                                  // Login link
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Sudah punya akun? ',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 14,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation, secondaryAnimation) =>
                                                  const LoginScreen(),
                                              transitionsBuilder:
                                                  (context, animation, secondaryAnimation, child) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                );
                                              },
                                              transitionDuration: const Duration(milliseconds: 300),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Masuk di sini',
                                          style: TextStyle(
                                            color: Color(0xFF00AA13),
                                            fontSize: 14,
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
                          
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = step <= _currentStep;
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              '${step + 1}',
              style: TextStyle(
                color: isActive ? const Color(0xFF00AA13) : Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF00AA13),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: 2,
          ),
        ),
      ),
      validator: validator,
    );
  }
}