class Overtime {
  final int idOvertime;
  final int idKaryawan;
  final String alasanLembur;
  final String tglOvertime;
  final String jamStart;
  final String jamEnd;
  final String approvedStatus;
  final String keterangan;
  final String namaKaryawan;
  final String department;

  Overtime({
    required this.idOvertime,
    required this.idKaryawan,
    required this.alasanLembur,
    required this.tglOvertime,
    required this.jamStart,
    required this.jamEnd,
    required this.approvedStatus,
    required this.keterangan,
    required this.namaKaryawan,
    required this.department,
  });

  factory Overtime.fromJson(Map<String, dynamic> json) {
    return Overtime(
      idOvertime: json['id_overtime'] ?? 0,
      idKaryawan: json['id_karyawan'] ?? 0,
      alasanLembur: json['alasan_lembur'] ?? '',
      tglOvertime: json['tgl_overtime'] ?? '',
      jamStart: json['jam_start'] ?? '',
      jamEnd: json['jam_end'] ?? '',
      approvedStatus: json['approved_status'] ?? 'pending',
      keterangan: json['keterangan'] ?? '',
      namaKaryawan: json['nama_karyawan'] ?? '',
      department: json['department'] ?? '',
    );
  }
}
