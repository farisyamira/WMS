import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wms/App/Domain/ManageShopInventory/RequestModel.dart';
import 'package:wms/App/Domain/ManageShopInventory/RequestModel.dart';

class RequestController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = "requests";

  Future<void> createRequest(RequestModel request) async {
    await _firestore.collection(_collection).add(request.toMap());
  }

  Future<List<RequestModel>> getRequestsByUser(String userId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('requested_by', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => RequestModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<RequestModel>> getIncomingRequests(String workshopName) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('workshop_name', isEqualTo: workshopName)
        .where('request_status', isEqualTo: 'PENDING')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => RequestModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> updateRequestStatus(String docId, String status) async {
    await _firestore.collection(_collection).doc(docId).update({
      'request_status': status,
    });
  }
}
