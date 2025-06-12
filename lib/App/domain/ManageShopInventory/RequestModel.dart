import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String requestId;
  final String itemName;
  final String imageUrl;
  final String workshopName;
  final int quantityRequested;
  final String requestStatus;
  final String requestedBy;
  final DateTime? timestamp;

  RequestModel({
    required this.requestId,
    required this.itemName,
    required this.imageUrl,
    required this.workshopName,
    required this.quantityRequested,
    required this.requestStatus,
    required this.requestedBy,
    this.timestamp,
  });

  factory RequestModel.fromMap(Map<String, dynamic> data, String docId) {
    return RequestModel(
      requestId: docId,
      itemName: data['item_name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      workshopName: data['workshop_name'] ?? '',
      quantityRequested: data['quantity_requested'] ?? 0,
      requestStatus: data['request_status'] ?? 'PENDING',
      requestedBy: data['requested_by'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item_name': itemName,
      'imageUrl': imageUrl,
      'workshop_name': workshopName,
      'quantity_requested': quantityRequested,
      'request_status': requestStatus,
      'requested_by': requestedBy,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
