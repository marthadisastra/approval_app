import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/leave_provider.dart';
import '../widgets/leave_item.dart';
import 'leave_detail_screen.dart';

class LeaveListScreen extends StatefulWidget {
  @override
  _LeaveListScreenState createState() => _LeaveListScreenState();
}

class _LeaveListScreenState extends State<LeaveListScreen> {
  @override
  void initState() {
    super.initState();
    _loadPendingLeaves();
  }

  void _loadPendingLeaves() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);

    if (authProvider.user != null) {
      leaveProvider.loadPendingLeaves(authProvider.user!.idUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengajuan Cuti'),
        backgroundColor: Colors.orange,
      ),
      body: Consumer<LeaveProvider>(
        builder: (context, leaveProvider, child) {
          if (leaveProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (leaveProvider.pendingLeaves.isEmpty) {
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
                    'Tidak ada pengajuan cuti yang menunggu approval',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadPendingLeaves();
            },
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: leaveProvider.pendingLeaves.length,
              itemBuilder: (context, index) {
                final leave = leaveProvider.pendingLeaves[index];
                return LeaveItem(
                  leave: leave,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeaveDetailScreen(leave: leave),
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
