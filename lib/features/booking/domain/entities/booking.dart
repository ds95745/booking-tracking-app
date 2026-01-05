import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  final String id;
  final String pickupLocation;
  final double pickupLatitude;
  final double pickupLongitude;
  final String dropLocation;
  final double dropLatitude;
  final double dropLongitude;
  final DateTime dateTime;
  final String? notes;
  final String status;
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.pickupLocation,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropLocation,
    required this.dropLatitude,
    required this.dropLongitude,
    required this.dateTime,
    this.notes,
    required this.status,
    required this.createdAt,
  });

  Booking copyWith({
    String? id,
    String? pickupLocation,
    double? pickupLatitude,
    double? pickupLongitude,
    String? dropLocation,
    double? dropLatitude,
    double? dropLongitude,
    DateTime? dateTime,
    String? notes,
    String? status,
    DateTime? createdAt,
  }) {
    return Booking(
      id: id ?? this.id,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      pickupLatitude: pickupLatitude ?? this.pickupLatitude,
      pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      dropLocation: dropLocation ?? this.dropLocation,
      dropLatitude: dropLatitude ?? this.dropLatitude,
      dropLongitude: dropLongitude ?? this.dropLongitude,
      dateTime: dateTime ?? this.dateTime,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        pickupLocation,
        pickupLatitude,
        pickupLongitude,
        dropLocation,
        dropLatitude,
        dropLongitude,
        dateTime,
        notes,
        status,
        createdAt,
      ];
}

