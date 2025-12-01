import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Contoh: Tambah data ke collection 'users'
  Future<void> addUser(String userId, Map<String, dynamic> data) async {
    await _db.collection('users').doc(userId).set(data);
  }

  // Contoh: Ambil data user
  Future<DocumentSnapshot> getUser(String userId) async {
    return await _db.collection('users').doc(userId).get();
  }

  // Contoh: Update data user
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _db.collection('users').doc(userId).update(data);
  }

  // Contoh: Hapus user
  Future<void> deleteUser(String userId) async {
    await _db.collection('users').doc(userId).delete();
  }

  // Contoh: Ambil semua data dari collection
  Stream<QuerySnapshot> getUsers() {
    return _db.collection('users').snapshots();
  }

  // Tambah method lain sesuai kebutuhan, misal untuk pesanan, dll.
  // Contoh untuk pesanan
  Future<void> addOrder(String orderId, Map<String, dynamic> data) async {
    await _db.collection('orders').doc(orderId).set(data);
  }

  Stream<QuerySnapshot> getOrders() {
    return _db.collection('orders').snapshots();
  }

  // Method untuk auth (integrasi dengan auth_service.dart) - sudah dihandle di auth_service
  // Future<void> createUserProfile(String uid, Map<String, dynamic> userData) async {
  //   await _db.collection('users').doc(uid).set(userData);
  // }

  Future<DocumentSnapshot> getUserProfile(String uid) async {
    return await _db.collection('users').doc(uid).get();
  }

  // Method untuk beranda (promo, dll)
  Stream<QuerySnapshot> getPromos() {
    return _db.collection('promos').snapshots();
  }

  // Method untuk pesanan
  Future<void> createOrder(Map<String, dynamic> orderData) async {
    await _db.collection('orders').add(orderData);
  }

  Stream<QuerySnapshot> getUserOrders(String userId) {
    return _db.collection('orders').where('userId', isEqualTo: userId).snapshots();
  }
}
