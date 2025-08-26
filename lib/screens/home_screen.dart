import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../providers/auth_provider.dart';
import '../providers/leave_provider.dart';
import 'login_screen.dart';
import 'leave_list_screen.dart';
import 'overtime_list_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pendingLeaveCount = 0;
  int _pendingOvertimeCount = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() async {
    // Gunakan addPostFrameCallback untuk menghindari masalah context
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final leaveProvider =
            Provider.of<LeaveProvider>(context, listen: false);

        if (authProvider.user != null) {
          setState(() {
            _isLoading = true;
          });

          await leaveProvider.loadPendingLeaves(authProvider.user!.idUser);
          await leaveProvider.loadPendingOvertimes(authProvider.user!.idUser);

          if (mounted) {
            setState(() {
              _pendingLeaveCount = leaveProvider.pendingLeaves.length;
              _pendingOvertimeCount = leaveProvider.pendingOvertimes.length;
              _isLoading = false;
            });
          }
        }
      }
    });
  }

  void _logout() {
    Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Consumer2<AuthProvider, LeaveProvider>(
        builder: (context, authProvider, leaveProvider, child) {
          if (_isLoading || authProvider.isLoading || leaveProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (authProvider.user == null) {
            return Center(child: Text('User not found'));
          }

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authProvider.user?.nama ?? 'User',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              authProvider.employee?.namaJabatan ?? 'Jabatan',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildDashboardCard(
                        context,
                        'Pengajuan Cuti',
                        Icons.calendar_today,
                        Colors.orange,
                        _pendingLeaveCount,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LeaveListScreen(),
                            ),
                          );
                        },
                      ),
                      _buildDashboardCard(
                        context,
                        'Lembur',
                        Icons.access_time,
                        Colors.green,
                        _pendingOvertimeCount,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OvertimeListScreen(),
                            ),
                          );
                        },
                      ),
                      _buildDashboardCard(
                        context,
                        'Profil',
                        Icons.person,
                        Colors.blue,
                        0,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
                            ),
                          );
                        },
                      ),
                      _buildDashboardCard(
                        context,
                        'Notifikasi',
                        Icons.notifications,
                        Colors.purple,
                        _pendingLeaveCount + _pendingOvertimeCount,
                        () {
                          // Navigate to notification screen
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {},
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Cuti',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Lembur',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    int count,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              badges.Badge(
                showBadge: count > 0,
                badgeContent: Text(
                  '$count',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: color,
                ),
              ),
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
