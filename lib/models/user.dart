class User {
  final int idUser;
  final int idTenant;
  final int? idModule;
  final String? accessTenant;
  final String email;
  final String username;
  final String nama;
  final String password;
  final int verified;
  final int status;
  final DateTime? created;
  final String? avatar;
  final DateTime? tglEdit;
  final int? idUserEdit;
  final int isDeleted;
  final int? idLog;

  User({
    required this.idUser,
    required this.idTenant,
    this.idModule,
    this.accessTenant,
    required this.email,
    required this.username,
    required this.nama,
    required this.password,
    required this.verified,
    required this.status,
    this.created,
    this.avatar,
    this.tglEdit,
    this.idUserEdit,
    required this.isDeleted,
    this.idLog,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing user data: $json');

      return User(
        idUser: _parseInt(json['id_user']),
        idTenant: _parseInt(json['id_tenant']),
        idModule: _parseInt(json['id_module']),
        accessTenant: json['access_tenant'] as String?,
        email: json['email'] as String? ?? '',
        username: json['username'] as String? ?? '',
        nama: json['nama'] as String? ?? '',
        password: json['password'] as String? ?? '',
        verified: _parseInt(json['verified']),
        status: _parseInt(json['status']),
        created: _parseDateTime(json['created']),
        avatar: json['avatar'] as String?,
        tglEdit: _parseDateTime(json['tgl_edit']),
        idUserEdit: _parseInt(json['id_user_edit']),
        isDeleted: _parseInt(json['isDeleted']),
        idLog: _parseInt(json['id_log']),
      );
    } catch (e) {
      print('Error parsing user: $e');
      rethrow;
    }
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'id_tenant': idTenant,
      'id_module': idModule,
      'access_tenant': accessTenant,
      'email': email,
      'username': username,
      'nama': nama,
      'password': password,
      'verified': verified,
      'status': status,
      'created': created?.toUtc().toString(),
      'avatar': avatar,
      'tgl_edit': tglEdit?.toUtc().toString(),
      'id_user_edit': idUserEdit,
      'isDeleted': isDeleted,
      'id_log': idLog,
    };
  }
}
