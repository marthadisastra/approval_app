import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/leave_provider.dart';
import '../widgets/overtime_item.dart';
import 'overtime_detail_screen.dart';

class OvertimeListScreen extends StatefulWidget {
  @override
  _OvertimeListScreenState createState() => _OvertimeListScreenState();
}

class _OvertimeListScreenState extends State<OvertimeListScreen> {
  @override
  void initState() {
    super.initState();
    _loadPendingOvertimes();
  }

  void _loadPendingOvertimes() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);

    if (authProvider.user != null) {
      leaveProvider.loadPendingOvertimes(authProvider.user!.idUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengajuan Lembur'),
        backgroundColor: Colors.green,
      ),
      body: Consumer<LeaveProvider>(
        builder: (context, leaveProvider, child) {
          if (leaveProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (leaveProvider.pendingOvertimes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 64,
                    color: Colors.green,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tidak ada pengajuan lembur yang menunggu approval',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadPendingOvertimes();
            },
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: leaveProvider.pendingOvertimes.length,
              itemBuilder: (context, index) {
                final overtime = leaveProvider.pendingOvertimes[index];
                return OvertimeItem(
                  overtime: overtime,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OvertimeDetailScreen(overtime: overtime),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
