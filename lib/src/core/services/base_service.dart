import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client.dart';

class BaseService {
  final ApiClient _client;

  BaseService(this._client);

  // --- AUTH SERVICES ---
  Future<dynamic> login(String email, String password) {
    return _client.post('login', {
      'email': email,
      'username': email,
      'password': password,
    });
  }

  Future<dynamic> signUp({
    required String username,
    required String email,
    required String password,
    String role = 'Viewer',
    String status = 'Active',
    String description = 'Regular system user.',
  }) {
    return _client.post('sign_up', {
      'username': username,
      'email': email,
      'password': password,
      'role': role,
      'status': status,
      'description': description,
    });
  }

  // --- DASHBOARD SERVICES ---
  Future<dynamic> getDashboardData() {
    return _client.post('ADMIN_DASHBOARD_list', {});
  }

  // --- USER SERVICES ---
  Future<dynamic> listUsers({int page = 1, int limit = 10, String search = ''}) {
    return _client.post('USERS_list', {
      'page': page,
      'limit': limit,
      'search': search,
    });
  }

  Future<Map<String, dynamic>> listUsersFull({int page = 1, int limit = 10, String search = ''}) {
    return _client.postFull('USERS_list', {
      'page': page,
      'limit': limit,
      'search': search,
    });
  }

  Future<dynamic> createUser({
    required String username,
    required String email,
    required String password,
    required String role,
    required String status,
    required String description,
  }) {
    return _client.post('USERS_create', {
      'username': username,
      'email': email,
      'password': password,
      'role': role,
      'status': status,
      'description': description,
    });
  }

  Future<dynamic> updateUser({
    required int id,
    String? username,
    String? email,
    String? role,
    String? status,
    String? description,
  }) {
    final Map<String, dynamic> data = {'id': id};
    if (username != null) data['username'] = username;
    if (email != null) data['email'] = email;
    if (role != null) data['role'] = role;
    if (status != null) data['status'] = status;
    if (description != null) data['description'] = description;

    return _client.post('USERS_update', data);
  }

  Future<dynamic> deleteUser(int id) {
    return _client.post('USERS_delete', {'id': id});
  }

  Future<dynamic> getUsersCount() {
    return _client.post('USERS_count', {});
  }

  // --- ROLE SERVICES ---
  Future<dynamic> listRoles({int page = 1, int limit = 50, String search = ''}) {
    return _client.post('ROLES_list', {
      'page': page,
      'limit': limit,
      'search': search,
    });
  }

  Future<Map<String, dynamic>> listRolesFull({int page = 1, int limit = 50, String search = ''}) {
    return _client.postFull('ROLES_list', {
      'page': page,
      'limit': limit,
      'search': search,
    });
  }

  Future<dynamic> createRole({
    required String roleName,
    required String description,
    required String permissions,
  }) {
    return _client.post('ROLES_create', {
      'role_name': roleName,
      'description': description,
      'permissions': permissions,
    });
  }

  Future<dynamic> updateRole({
    required int id,
    String? roleName,
    String? description,
    String? permissions,
  }) {
    final Map<String, dynamic> data = {'id': id};
    if (roleName != null) data['role_name'] = roleName;
    if (description != null) data['description'] = description;
    if (permissions != null) data['permissions'] = permissions;

    return _client.post('ROLES_update', data);
  }

  Future<dynamic> deleteRole(int id) {
    return _client.post('ROLES_delete', {'id': id});
  }

  // --- SETTINGS SERVICES ---
  Future<dynamic> listSettings() {
    return _client.post('SETTINGS_list', {
      'limit': 100,
    });
  }

  Future<dynamic> createSetting(String key, String val) {
    return _client.post('SETTINGS_create', {
      'key': key,
      'scope': 'global',
      'value': {'value': val},
    });
  }

  Future<dynamic> updateSetting(int id, String key, String val) {
    return _client.post('SETTINGS_update', {
      'id': id,
      'key': key,
      'scope': 'global',
      'value': {'value': val},
    });
  }

  Future<dynamic> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) {
    return _client.post('change_password', {
      'email': email,
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  // --- WIDGET SERVICES ---
  Future<dynamic> listWidgets({int page = 1, int limit = 50, String search = ''}) {
    return _client.post('WIDGETS_list', {
      'page': page,
      'limit': limit,
      'search': search,
    });
  }

  Future<Map<String, dynamic>> listWidgetsFull({int page = 1, int limit = 50, String search = ''}) {
    return _client.postFull('WIDGETS_list', {
      'page': page,
      'limit': limit,
      'search': search,
    });
  }

  Future<dynamic> createWidget({
    required String key,
    required String label,
    required String category,
    bool isBuiltin = false,
    String? version,
    String? iconType,
    String? iconValue,
    Map<String, dynamic>? configSchema,
  }) {
    return _client.post('WIDGETS_create', {
      'key': key,
      'label': label,
      'category': category,
      'is_builtin': isBuiltin,
      if (version != null) 'version': version,
      if (iconType != null) 'icon_type': iconType,
      if (iconValue != null) 'icon_value': iconValue,
      'config_schema': configSchema ?? {},
    });
  }

  Future<dynamic> updateWidget({
    required int id,
    String? key,
    String? label,
    String? category,
    bool? isBuiltin,
    String? version,
    String? iconType,
    String? iconValue,
    Map<String, dynamic>? configSchema,
  }) {
    return _client.post('WIDGETS_update', {
      'id': id,
      if (key != null) 'key': key,
      if (label != null) 'label': label,
      if (category != null) 'category': category,
      if (isBuiltin != null) 'is_builtin': isBuiltin,
      if (version != null) 'version': version,
      if (iconType != null) 'icon_type': iconType,
      if (iconValue != null) 'icon_value': iconValue,
      if (configSchema != null) 'config_schema': configSchema,
    });
  }

  Future<dynamic> deleteWidget(int id) {
    return _client.post('WIDGETS_delete', {'id': id});
  }
}

final baseServiceProvider = Provider<BaseService>((ref) {
  final client = ref.watch(apiClientProvider);
  return BaseService(client);
});
