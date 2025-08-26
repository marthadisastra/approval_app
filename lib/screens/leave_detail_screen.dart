import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/leave.dart';
import '../providers/auth_provider.dart';
import '../providers/leave_provider.dart';

class LeaveDetailScreen extends StatefulWidget {
  final Leave leave;

  LeaveDetailScreen({required this.leave});

  @override
  _LeaveDetailScreenState createState() => _LeaveDetailScreenState();
}

class _LeaveDetailScreenState extends State<LeaveDetailScreen> {
  final _keteranganController = TextEditingController();

  @override
  void dispose() {
    _keteranganController.dispose();
    super.dispose();
  }

  void _approveLeave() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);

    if (authProvider.user != null) {
      final success = await leaveProvider.approveLeave(
        widget.leave.idLeave,
        authProvider.user!.idUser,
        _keteranganController.text,
      );

      if (success) {
        Fluttertoast.showToast(
          msg: "Pengajuan cuti disetujui",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: "Gagal menyetujui pengajuan cuti",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  void _rejectLeave() async {
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
      final success = await leaveProvider.rejectLeave(
        widget.leave.idLeave,
        authProvider.user!.idUser,
        _keteranganController.text,
      );

      if (success) {
        Fluttertoast.showToast(
          msg: "Pengajuan cuti ditolak",
          backgroundColor: Colors.orange,
          textColor: Colors.white,
        );
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: "Gagal menolak pengajuan cuti",
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
        title: Text('Detail Pengajuan Cuti'),
        backgroundColor: Colors.orange,
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
                    _buildInfoRow('Nama', widget.leave.namaKaryawan),
                    _buildInfoRow('Departemen', widget.leave.department),
                    _buildInfoRow('NIK', widget.leave.idKaryawan.toString()),
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
                    _buildInfoRow('Jenis Cuti', widget.leave.jenisLeave),
                    _buildInfoRow('Tanggal', widget.leave.tglLeave),
                    _buildInfoRow('Jam',
                        '${widget.leave.jamStart} - ${widget.leave.jamEnd}'),
                    _buildInfoRow('Status', widget.leave.approvedStatus),
                    SizedBox(height: 8),
                    Text(
                      'Alasan:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.leave.alasanLeave),
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
                    onPressed: _rejectLeave,
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
                    onPressed: _approveLeave,
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
