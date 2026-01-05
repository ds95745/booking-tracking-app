import 'dart:convert';
import '../../domain/entities/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.pickupLocation,
    required super.pickupLatitude,
    required super.pickupLongitude,
    required super.dropLocation,
    required super.dropLatitude,
    required super.dropLongitude,
    required super.dateTime,
    super.notes,
    required super.status,
    required super.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      pickupLocation: json['pickupLocation'] as String,
      pickupLatitude: (json['pickupLatitude'] as num).toDouble(),
      pickupLongitude: (json['pickupLongitude'] as num).toDouble(),
      dropLocation: json['dropLocation'] as String,
      dropLatitude: (json['dropLatitude'] as num).toDouble(),
      dropLongitude: (json['dropLongitude'] as num).toDouble(),
      dateTime: DateTime.parse(json['dateTime'] as String),
      notes: json['notes'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pickupLocation': pickupLocation,
      'pickupLatitude': pickupLatitude,
      'pickupLongitude': pickupLongitude,
      'dropLocation': dropLocation,
      'dropLatitude': dropLatitude,
      'dropLongitude': dropLongitude,
      'dateTime': dateTime.toIso8601String(),
      'notes': notes,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory BookingModel.fromJsonString(String jsonString) {
    return BookingModel.fromJson(jsonDecode(jsonString));
  }
}

