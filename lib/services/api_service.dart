import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/ticket.dart';
import '../models/category.dart';
import '../models/company.dart';

class ApiService {
  String baseUrl;
  String? token;

  ApiService({required this.baseUrl});

  void setToken(String newToken) {
    token = newToken;
  }

  void setBaseUrl(String newBaseUrl) {
    baseUrl = newBaseUrl.endsWith('/') ? newBaseUrl : '$newBaseUrl/';
  }

  Map<String, String> _getHeaders({bool includeAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (includeAuth && token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Autenticación
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('${baseUrl}api/auth/login/');
    final response = await http.post(
      url,
      headers: _getHeaders(includeAuth: false),
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'success': true,
        'token': data['token'],
        'user': User.fromJson(data['user']),
        'message': data['message'],
      };
    } else {
      final error = jsonDecode(response.body);
      return {
        'success': false,
        'message': error['error'] ?? 'Error al iniciar sesión',
      };
    }
  }

  // Tickets
  Future<Map<String, dynamic>> getTickets({
    String? status,
    String? priority,
    String? search,
    int page = 1,
  }) async {
    var url = '${baseUrl}api/tickets/?page=$page';
    if (status != null) url += '&status=$status';
    if (priority != null) url += '&priority=$priority';
    if (search != null && search.isNotEmpty) url += '&search=$search';

    final response = await http.get(
      Uri.parse(url),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final tickets = (data['results'] as List)
          .map((json) => Ticket.fromJson(json))
          .toList();
      return {
        'success': true,
        'tickets': tickets,
        'count': data['count'],
        'next': data['next'],
        'previous': data['previous'],
      };
    } else {
      return {
        'success': false,
        'message': 'Error al cargar tickets',
      };
    }
  }

  Future<Map<String, dynamic>> getTicket(int id) async {
    final url = Uri.parse('${baseUrl}api/tickets/$id/');
    final response = await http.get(
      url,
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'success': true,
        'ticket': Ticket.fromJson(data),
      };
    } else {
      return {
        'success': false,
        'message': 'Error al cargar el ticket',
      };
    }
  }

  Future<Map<String, dynamic>> createTicket({
    required String title,
    required String description,
    String priority = 'medium',
    String ticketType = 'desarrollo',
    double? hours,
    int? categoryId,
    int? companyId,
    int? projectId,
  }) async {
    final url = Uri.parse('${baseUrl}api/tickets/');
    final body = {
      'title': title,
      'description': description,
      'priority': priority,
      'ticket_type': ticketType,
    };

    if (hours != null) body['hours'] = hours;
    if (categoryId != null) body['category_id'] = categoryId;
    if (companyId != null) body['company_id'] = companyId;
    if (projectId != null) body['project_id'] = projectId;

    final response = await http.post(
      url,
      headers: _getHeaders(),
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return {
        'success': true,
        'ticket': Ticket.fromJson(data),
        'message': 'Ticket creado exitosamente',
      };
    } else {
      return {
        'success': false,
        'message': 'Error al crear el ticket',
      };
    }
  }

  Future<Map<String, dynamic>> updateTicket(int id, Map<String, dynamic> updates) async {
    final url = Uri.parse('${baseUrl}api/tickets/$id/');
    final response = await http.patch(
      url,
      headers: _getHeaders(),
      body: jsonEncode(updates),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'success': true,
        'ticket': Ticket.fromJson(data),
        'message': 'Ticket actualizado exitosamente',
      };
    } else {
      return {
        'success': false,
        'message': 'Error al actualizar el ticket',
      };
    }
  }

  Future<Map<String, dynamic>> deleteTicket(int id) async {
    final url = Uri.parse('${baseUrl}api/tickets/$id/');
    final response = await http.delete(
      url,
      headers: _getHeaders(),
    );

    if (response.statusCode == 204) {
      return {
        'success': true,
        'message': 'Ticket eliminado exitosamente',
      };
    } else {
      return {
        'success': false,
        'message': 'Error al eliminar el ticket',
      };
    }
  }

  // Categorías
  Future<List<Category>> getCategories() async {
    final url = Uri.parse('${baseUrl}api/categories/');
    final response = await http.get(
      url,
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  // Empresas
  Future<List<Company>> getCompanies() async {
    final url = Uri.parse('${baseUrl}api/companies/');
    final response = await http.get(
      url,
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;
      return results.map((json) => Company.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
