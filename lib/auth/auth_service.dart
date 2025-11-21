import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Mendaftarkan pengguna baru dengan Firebase Auth dan buat profil di Firestore
  static Future<bool> registerUser(String email, String password, {String? name, String? phone}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Buat profil user di Firestore secara paralel dengan operasi lainnya
      _db.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'name': name ?? '',
        'phone': phone ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      }).catchError((error) {
        print('Error saving user profile: $error');
        // Tidak throw error agar registrasi tetap berhasil meski Firestore gagal
      });

      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  // Login pengguna dengan Firebase Auth
  static Future<bool> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      print('Error logging in: $e');
      return false;
    }
  }

  // Logout pengguna
  static Future<void> logoutUser() async {
    await _auth.signOut();
  }

  // Cek status login
  static Future<bool> isLoggedIn() async {
    return _auth.currentUser != null;
  }

  // Get current user
  static User? getCurrentUser() {
    return _auth.currentUser;
  }
}
