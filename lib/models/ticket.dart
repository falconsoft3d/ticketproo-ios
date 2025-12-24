import 'user.dart';
import 'category.dart';
import 'company.dart';

class Ticket {
  final int id;
  final String ticketNumber;
  final String title;
  final String? description;
  final String priority;
  final String status;
  final String ticketType;
  final double? hours;
  final bool isApproved;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? createdBy;
  final User? assignedTo;
  final Category? category;
  final Company? company;
  final int? ageInHours;
  final String? ageDisplay;
  final String? priorityDisplay;
  final String? statusDisplay;
  final String? typeDisplay;

  Ticket({
    required this.id,
    required this.ticketNumber,
    required this.title,
    this.description,
    required this.priority,
    required this.status,
    required this.ticketType,
    this.hours,
    required this.isApproved,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.assignedTo,
    this.category,
    this.company,
    this.ageInHours,
    this.ageDisplay,
    this.priorityDisplay,
    this.statusDisplay,
    this.typeDisplay,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      ticketNumber: json['ticket_number'],
      title: json['title'],
      description: json['description'],
      priority: json['priority'],
      status: json['status'],
      ticketType: json['ticket_type'],
      hours: json['hours']?.toDouble(),
      isApproved: json['is_approved'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      createdBy: json['created_by'] != null ? User.fromJson(json['created_by']) : null,
      assignedTo: json['assigned_to'] != null ? User.fromJson(json['assigned_to']) : null,
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      company: json['company'] != null ? Company.fromJson(json['company']) : null,
      ageInHours: json['age_in_hours'],
      ageDisplay: json['age_display'],
      priorityDisplay: json['priority_display'],
      statusDisplay: json['status_display'],
      typeDisplay: json['type_display'],
    );
  }
}
