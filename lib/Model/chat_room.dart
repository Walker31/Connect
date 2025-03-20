import 'package:flutter/foundation.dart';

@immutable
class ChatRoom {
  final int id;
  final Participant participant1;
  final Participant participant2;
  final String? lastMessage; // Optional last message field
  final DateTime? lastUpdated; // Timestamp for sorting or tracking

  const ChatRoom({
    required this.id,
    required this.participant1,
    required this.participant2,
    this.lastMessage,
    this.lastUpdated,
  });

  /// Factory method to create a `ChatRoom` from JSON
  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'] as int,
      participant1:
          Participant.fromJson(json['participant1'] as Map<String, dynamic>),
      participant2:
          Participant.fromJson(json['participant2'] as Map<String, dynamic>),
      lastMessage: json['last_message'] as String?,
      lastUpdated: json['last_updated'] != null
          ? DateTime.tryParse(json['last_updated'] as String)
          : null,
    );
  }

  /// Convert `ChatRoom` to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'participant1': participant1.toJson(),
        'participant2': participant2.toJson(),
        'last_message': lastMessage,
        'last_updated': lastUpdated?.toIso8601String(),
      };

  /// Create a modified copy of the `ChatRoom`
  ChatRoom copyWith({
    int? id,
    Participant? participant1,
    Participant? participant2,
    String? lastMessage,
    DateTime? lastUpdated,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      participant1: participant1 ?? this.participant1,
      participant2: participant2 ?? this.participant2,
      lastMessage: lastMessage ?? this.lastMessage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatRoom &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          participant1 == other.participant1 &&
          participant2 == other.participant2 &&
          lastMessage == other.lastMessage &&
          lastUpdated == other.lastUpdated);

  @override
  int get hashCode =>
      id.hashCode ^
      participant1.hashCode ^
      participant2.hashCode ^
      lastMessage.hashCode ^
      lastUpdated.hashCode;
}

@immutable
class Participant {
  final int id;
  final String name;
  final String profilePicture;

  const Participant({
    required this.id,
    required this.name,
    required this.profilePicture,
  });

  /// Factory method to create a `Participant` from JSON
  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Unknown',
      profilePicture: json['profile_picture'] as String? ?? '',
    );
  }

  /// Convert `Participant` to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'profile_picture': profilePicture,
      };

  /// Create a modified copy of the `Participant`
  Participant copyWith({
    int? id,
    String? name,
    String? profilePicture,
  }) {
    return Participant(
      id: id ?? this.id,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Participant &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          profilePicture == other.profilePicture);

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ profilePicture.hashCode;
}
