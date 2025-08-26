class Employee {
  final int idKaryawan;
  final int idUser;
  final String nik;
  final String namaKtp;
  final String phone;
  final String namaJabatan;
  final String statusKaryawan;
  final String department;

  Employee({
    required this.idKaryawan,
    required this.idUser,
    required this.nik,
    required this.namaKtp,
    required this.phone,
    required this.namaJabatan,
    required this.statusKaryawan,
    required this.department,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      idKaryawan: json['id_karyawan'] ?? 0,
      idUser: json['id_user'] ?? 0,
      nik: json['nik'] ?? '',
      namaKtp: json['nama_ktp'] ?? '',
      phone: json['phone'] ?? '',
      namaJabatan: json['nama_jabatan'] ?? '',
      statusKaryawan: json['status_karyawan'] ?? '',
      department: json['department'] ?? '',
    );
  }
}
