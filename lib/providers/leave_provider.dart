import 'package:flutter/material.dart';
import '../models/leave.dart';
import '../models/overtime.dart';
import '../services/api_service.dart';

class LeaveProvider with ChangeNotifier {
  List<Leave> _pendingLeaves = [];
  List<Overtime> _pendingOvertimes = [];
  bool _isLoading = false;

  List<Leave> get pendingLeaves => _pendingLeaves;
  List<Overtime> get pendingOvertimes => _pendingOvertimes;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> loadPendingLeaves(int userId) async {
    setLoading(true);
    _pendingLeaves = await ApiService.getPendingLeaves(userId);
    setLoading(false);
    notifyListeners();
  }

  Future<void> loadPendingOvertimes(int userId) async {
    setLoading(true);
    _pendingOvertimes = await ApiService.getPendingOvertimes(userId);
    setLoading(false);
    notifyListeners();
  }

  Future<bool> approveLeave(int leaveId, int userId, String keterangan) async {
    final result = await ApiService.approveLeave(leaveId, userId, keterangan);
    if (result) {
      _pendingLeaves.removeWhere((leave) => leave.idLeave == leaveId);
      notifyListeners();
    }
    return result;
  }

  Future<bool> rejectLeave(int leaveId, int userId, String keterangan) async {
    final result = await ApiService.rejectLeave(leaveId, userId, keterangan);
    if (result) {
      _pendingLeaves.removeWhere((leave) => leave.idLeave == leaveId);
      notifyListeners();
    }
    return result;
  }

  Future<bool> approveOvertime(
      int overtimeId, int userId, String keterangan) async {
    final result =
        await ApiService.approveOvertime(overtimeId, userId, keterangan);
    if (result) {
      _pendingOvertimes
          .removeWhere((overtime) => overtime.idOvertime == overtimeId);
      notifyListeners();
    }
    return result;
  }

  Future<bool> rejectOvertime(
      int overtimeId, int userId, String keterangan) async {
    final result =
        await ApiService.rejectOvertime(overtimeId, userId, keterangan);
    if (result) {
      _pendingOvertimes
          .removeWhere((overtime) => overtime.idOvertime == overtimeId);
      notifyListeners();
    }
    return result;
  }
}
