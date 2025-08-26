import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/overtime.dart';
import '../providers/auth_provider.dart';
import '../providers/leave_provider.dart';

class OvertimeDetailScreen extends StatefulWidget {
  final Overtime overtime;

  OvertimeDetailScreen({required this.overtime});

  @override
  _OvertimeDetailScreenState createState() => _OvertimeDetailScreenState();
}

class _OvertimeDetailScreenState extends State<OvertimeDetailScreen> {
  final _keteranganController = TextEditingController();

  @override
  void dispose() {
    _keteranganController.dispose();
    super.dispose();
  }

  void _approveOvertime() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);

    if (authProvider.user != null) {
      final success = await leaveProvider.approveOvertime(
        widget.overtime.idOvertime,
        authProvider.user!.idUser,
        _keteranganController.text,
      );

      if (success) {
        Fluttertoast.showToast(
          msg: "Pengajuan lembur disetujui",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: "Gagal menyetujui pengajuan lembur",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  void _rejectOvertime() async {
    if (_keteranganController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Alasan penolakan harus diisi",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);

    if (authProvider.user != null) {
      final success = await leaveProvider.rejectOvertime(
        widget.overtime.idOvertime,
        authProvider.user!.idUser,
        _keteranganController.text,
      );

      if (success) {
        Fluttertoast.showToast(
          msg: "Pengajuan lembur ditolak",
          backgroundColor: Colors.orange,
          textColor: Colors.white,
        );
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: "Gagal menolak pengajuan lembur",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pengajuan Lembur'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informasi Karyawan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    _buildInfoRow('Nama', widget.overtime.namaKaryawan),
                    _buildInfoRow('Departemen', widget.overtime.department),
                    _buildInfoRow('NIK', widget.overtime.idKaryawan.toString()),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail Pengajuan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    _buildInfoRow('Tanggal', widget.overtime.tglOvertime),
                    _buildInfoRow('Jam',
                        '${widget.overtime.jamStart} - ${widget.overtime.jamEnd}'),
                    _buildInfoRow('Status', widget.overtime.approvedStatus),
                    SizedBox(height: 8),
                    Text(
                      'Alasan:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.overtime.alasanLembur),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Keterangan Approval',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    TextFormField(
                      controller: _keteranganController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Masukkan keterangan approval',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _rejectOvertime,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.all(16),
                    ),
                    child: Text(
                      'TOLAK',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _approveOvertime,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.all(16),
                    ),
                    child: Text(
                      'SETUJUI',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
