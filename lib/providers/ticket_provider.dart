import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import '../models/ticket.dart';
import '../models/category.dart';
import '../models/company.dart';
import '../services/api_service.dart';

class TicketProvider with ChangeNotifier {
  List<Ticket> _tickets = [];
  List<Category> _categories = [];
  List<Company> _companies = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _totalCount = 0;
  
  // Filtros
  String? _statusFilter;
  String? _priorityFilter;
  String? _searchQuery;

  List<Ticket> get tickets => _tickets;
  List<Category> get categories => _categories;
  List<Company> get companies => _companies;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get totalCount => _totalCount;
  String? get statusFilter => _statusFilter;
  String? get priorityFilter => _priorityFilter;

  void setStatusFilter(String? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void setPriorityFilter(String? priority) {
    _priorityFilter = priority;
    notifyListeners();
  }

  void setSearchQuery(String? query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadTickets(ApiService apiService, {bool refresh = false}) async {
    if (_isLoading) return;
    
    _isLoading = true;
    _errorMessage = null;
    if (refresh) _tickets = [];
    notifyListeners();

    try {
      final result = await apiService.getTickets(
        status: _statusFilter,
        priority: _priorityFilter,
        search: _searchQuery,
      );

      if (result['success']) {
        _tickets = result['tickets'];
        _totalCount = result['count'];
        
        // Actualizar el badge con el número de tickets abiertos
        await _updateAppBadge();
      } else {
        _errorMessage = result['message'];
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _updateAppBadge() async {
    try {
      // Contar tickets abiertos (open o in_progress)
      final openTicketsCount = _tickets.where((ticket) => 
        ticket.status == 'open' || ticket.status == 'in_progress'
      ).length;
      
      if (openTicketsCount > 0) {
        await FlutterAppBadger.updateBadgeCount(openTicketsCount);
      } else {
        await FlutterAppBadger.removeBadge();
      }
    } catch (e) {
      // Si el dispositivo no soporta badges, ignorar el error
      print('No se pudo actualizar el badge: $e');
    }
  }

  Future<void> loadCategories(ApiService apiService) async {
    try {
      _categories = await apiService.getCategories();
      notifyListeners();
    } catch (e) {
      // Error silencioso
    }
  }

  Future<void> loadCompanies(ApiService apiService) async {
    try {
      _companies = await apiService.getCompanies();
      notifyListeners();
    } catch (e) {
      // Error silencioso
    }
  }

  Future<Map<String, dynamic>> createTicket(
    ApiService apiService, {
    required String title,
    required String description,
    String priority = 'medium',
    String ticketType = 'desarrollo',
    double? hours,
    int? categoryId,
    int? companyId,
  }) async {
    final result = await apiService.createTicket(
      title: title,
      description: description,
      priority: priority,
      ticketType: ticketType,
      hours: hours,
      categoryId: categoryId,
      companyId: companyId,
    );

    if (result['success']) {
      await loadTickets(apiService, refresh: true);
    }

    return result;
  }

  Future<Map<String, dynamic>> updateTicket(
    ApiService apiService,
    int ticketId,
    Map<String, dynamic> updates,
  ) async {
    final result = await apiService.updateTicket(ticketId, updates);

    if (result['success']) {
      await loadTickets(apiService, refresh: true);
    }

    return result;
  }

  void clearFilters() {
    _statusFilter = null;
    _priorityFilter = null;
    _searchQuery = null;
    notifyListeners();
  }

  void clear() {
    _tickets = [];
    _categories = [];
    _companies = [];
    _errorMessage = null;
    _totalCount = 0;
    clearFilters();
    
    // Limpiar el badge cuando se cierra sesión
    FlutterAppBadger.removeBadge();
    
    notifyListeners();
  }
}
