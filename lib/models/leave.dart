class Leave {
  final int idLeave;
  final int idKaryawan;
  final String jenisLeave;
  final String alasanLeave;
  final String tglLeave;
  final String jamStart;
  final String jamEnd;
  final String approvedStatus;
  final String keterangan;
  final String namaKaryawan;
  final String department;

  Leave({
    required this.idLeave,
    required this.idKaryawan,
    required this.jenisLeave,
    required this.alasanLeave,
    required this.tglLeave,
    required this.jamStart,
    required this.jamEnd,
    required this.approvedStatus,
    required this.keterangan,
    required this.namaKaryawan,
    required this.department,
  });

  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
      idLeave: json['id_leave'] ?? 0,
      idKaryawan: json['id_karyawan'] ?? 0,
      jenisLeave: json['jenis_leave'] ?? '',
      alasanLeave: json['alasan_leave'] ?? '',
      tglLeave: json['tgl_leave'] ?? '',
      jamStart: json['jam_start'] ?? '',
      jamEnd: json['jam_end'] ?? '',
      approvedStatus: json['approved_status'] ?? 'pending',
      keterangan: json['keterangan'] ?? '',
      namaKaryawan: json['nama_karyawan'] ?? '',
      department: json['department'] ?? '',
    );
  }
}
