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
    try {
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
        
        List<Ticket> tickets;
        int count;
        dynamic next;
        dynamic previous;
        
        // La API puede devolver un array directo o un objeto con 'results'
        if (data is List) {
          // Array directo
          tickets = data.map((json) => Ticket.fromJson(json)).toList();
          count = tickets.length;
          next = null;
          previous = null;
        } else if (data is Map<String, dynamic> && data.containsKey('results')) {
          // Objeto con results (paginado)
          tickets = (data['results'] as List)
              .map((json) => Ticket.fromJson(json))
              .toList();
          count = data['count'] ?? tickets.length;
          next = data['next'];
          previous = data['previous'];
        } else {
          return {
            'success': false,
            'message': 'Formato de respuesta inválido',
          };
        }
        
        return {
          'success': true,
          'tickets': tickets,
          'count': count,
          'next': next,
          'previous': previous,
        };
      } else {
        return {
          'success': false,
          'message': 'Error al cargar tickets: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error en getTickets: $e');
      return {
        'success': false,
        'message': 'Error de conexión: $e',
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
    try {
      final url = Uri.parse('${baseUrl}api/tickets/');
      final body = <String, dynamic>{
        'title': title,
        'description': description,
        'priority': priority,
        'ticket_type': ticketType,
      };

      if (hours != null) body['hours'] = hours;
      if (categoryId != null) body['category_id'] = categoryId;
      if (companyId != null) body['company_id'] = companyId;
      if (projectId != null) body['project_id'] = projectId;

      print('Creating ticket with body: $body');
      
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode(body),
      );

      print('Create ticket response status: ${response.statusCode}');
      print('Create ticket response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        // El ticket se creó exitosamente
        // La API no devuelve el ticket completo, así que solo retornamos éxito
        return {
          'success': true,
          'message': 'Ticket creado exitosamente',
        };
      } else {
        return {
          'success': false,
          'message': 'Error al crear el ticket: ${response.statusCode} - ${response.body}',
        };
      }
    } catch (e, stackTrace) {
      print('Error en createTicket: $e');
      print('StackTrace: $stackTrace');
      return {
        'success': false,
        'message': 'Error al crear el ticket: $e',
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
    try {
      final url = Uri.parse('${baseUrl}api/categories/');
      final response = await http.get(
        url,
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // La API puede devolver un array directo o un objeto con 'results'
        if (data is List) {
          return data.map((json) => Category.fromJson(json)).toList();
        } else if (data is Map && data.containsKey('results')) {
          final results = data['results'] as List;
          return results.map((json) => Category.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error al cargar categorías: $e');
      return [];
    }
  }

  // Empresas
  Future<List<Company>> getCompanies() async {
    try {
      final url = Uri.parse('${baseUrl}api/companies/');
      final response = await http.get(
        url,
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // La API puede devolver un array directo o un objeto con 'results'
        if (data is List) {
          return data.map((json) => Company.fromJson(json)).toList();
        } else if (data is Map && data.containsKey('results')) {
          final results = data['results'] as List;
          return results.map((json) => Company.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error al cargar empresas: $e');
      return [];
    }
  }
}
