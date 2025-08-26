import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/employee.dart';
import '../models/leave.dart';
import '../models/overtime.dart';

class ApiService {
  static final String baseUrl = 'http://192.168.50.21/api_laundry/';

  // Login dengan debugging
  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    try {
      print('Attempting login with email: $email');

      final response = await http.post(
        Uri.parse('${baseUrl}auth/login'),
        body: {
          'email': email,
          'password': password,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        print('Login result: $result');
        return result;
      }
      return null;
    } catch (e) {
      print('Error login: $e');
      return null;
    }
  }

  // Get User Profile
  static Future<User?> getUserProfile(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}user/profile/$userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error get user profile: $e');
      return null;
    }
  }

  // Get Employee Detail
  static Future<Employee?> getEmployeeDetail(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}employee/detail/$userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Employee.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error get employee detail: $e');
      return null;
    }
  }

  // Get Dashboard Stats
  static Future<Map<String, dynamic>?> getDashboardStats(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}dashboard/stats/$userId'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error get dashboard stats: $e');
      return null;
    }
  }

  // Get Pending Leaves
  static Future<List<Leave>> getPendingLeaves(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}leave/pending/$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Leave.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error get pending leaves: $e');
      return [];
    }
  }

  // Get Pending Overtimes
  static Future<List<Overtime>> getPendingOvertimes(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}overtime/pending/$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Overtime.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error get pending overtimes: $e');
      return [];
    }
  }

  // Approve Leave
  static Future<bool> approveLeave(
      int leaveId, int userId, String keterangan) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}leave/approve'),
        body: {
          'leave_id': leaveId.toString(),
          'user_id': userId.toString(),
          'keterangan': keterangan,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error approve leave: $e');
      return false;
    }
  }

  // Reject Leave
  static Future<bool> rejectLeave(
      int leaveId, int userId, String keterangan) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}leave/reject'),
        body: {
          'leave_id': leaveId.toString(),
          'user_id': userId.toString(),
          'keterangan': keterangan,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error reject leave: $e');
      return false;
    }
  }

  // Approve Overtime
  static Future<bool> approveOvertime(
      int overtimeId, int userId, String keterangan) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}overtime/approve'),
        body: {
          'overtime_id': overtimeId.toString(),
          'user_id': userId.toString(),
          'keterangan': keterangan,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error approve overtime: $e');
      return false;
    }
  }

  // Reject Overtime
  static Future<bool> rejectOvertime(
      int overtimeId, int userId, String keterangan) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}overtime/reject'),
        body: {
          'overtime_id': overtimeId.toString(),
          'user_id': userId.toString(),
          'keterangan': keterangan,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error reject overtime: $e');
      return false;
    }
  }
}
