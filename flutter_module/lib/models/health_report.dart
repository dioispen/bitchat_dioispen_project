import 'dart:convert';
import 'dart:typed_data';

class HealthReport {
  final String reporterId;   // 回報者 ID
  final String name;         // 回報者姓名
  final String phone;        // 聯絡電話
  final String? bloodType;   // 血型（可選）
  final String status;       // 健康狀態：'安全' / '輕傷' / '重傷'
  final String? description; // 補充說明（可選）
  final double? lat;         // 緯度（可選）
  final double? lng;         // 經度（可選）
  final DateTime reportTime; // 回報時間

  HealthReport({
    required this.reporterId,
    required this.name,
    required this.phone,
    this.bloodType,
    required this.status,
    this.description,
    this.lat,
    this.lng,
    required this.reportTime,
  });

  Map<String, dynamic> toJson() => {
        'reporterId': reporterId,
        'name': name,
        'phone': phone,
        'bloodType': bloodType,
        'status': status,
        'description': description,
        'lat': lat,
        'lng': lng,
        'reportTime': reportTime.toIso8601String(),
      };

  factory HealthReport.fromJson(Map<String, dynamic> json) => HealthReport(
        reporterId: json['reporterId'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        bloodType: json['bloodType'] as String?,
        status: json['status'] as String,
        description: json['description'] as String?,
        lat: (json['lat'] as num?)?.toDouble(),
        lng: (json['lng'] as num?)?.toDouble(),
        reportTime: DateTime.parse(json['reportTime'] as String),
      );

  /// 二進制編碼 - 與 Kotlin HealthReportPayload 格式對應
  /// 所有字段統一為：(長度 + UTF-8 內容) 或原始二進制格式
  List<int> encodeToBytes() {
    final reporterIdBytes = utf8.encode(reporterId);
    final nameBytes = utf8.encode(name);
    final phoneBytes = utf8.encode(phone);
    final bloodTypeBytes = bloodType != null ? utf8.encode(bloodType!) : <int>[];
    final statusBytes = utf8.encode(status);
    final descriptionBytes = description != null ? utf8.encode(description!) : <int>[];
    final reportTimeBytes = utf8.encode(reportTime.toIso8601String());

    final bytes = <int>[];

    // 寫入報告者 ID（1字節長度 + 內容）
    bytes.add(reporterIdBytes.length & 0xFF);
    bytes.addAll(reporterIdBytes);

    // 寫入姓名
    bytes.add(nameBytes.length & 0xFF);
    bytes.addAll(nameBytes);

    // 寫入電話
    bytes.add(phoneBytes.length & 0xFF);
    bytes.addAll(phoneBytes);

    // 寫入血型
    bytes.add(bloodTypeBytes.length & 0xFF);
    bytes.addAll(bloodTypeBytes);

    // 寫入狀態
    bytes.add(statusBytes.length & 0xFF);
    bytes.addAll(statusBytes);

    // 寫入補充說明（2字節大端序長度 + 內容）
    bytes.add((descriptionBytes.length >> 8) & 0xFF);
    bytes.add(descriptionBytes.length & 0xFF);
    bytes.addAll(descriptionBytes);

    // 寫入緯度和經度（8 字節 IEEE 754 double，大端序）
    bytes.addAll(_encodeDoubleToBytes(lat ?? 0.0));
    bytes.addAll(_encodeDoubleToBytes(lng ?? 0.0));

    // 寫入回報時間（1字節長度 + UTF-8 內容）
    bytes.add(reportTimeBytes.length & 0xFF);
    bytes.addAll(reportTimeBytes);

    return bytes;
  }

  /// 二進制解碼 - 與 Kotlin HealthReportPayload.decode() 對應
  static HealthReport? decodeFromBytes(List<int> data) {
    try {
      int pos = 0;

      // 讀取報告者 ID
      int ridLen = data[pos] & 0xFF;
      pos++;
      if (pos + ridLen > data.length) return null;
      String reporterId = utf8.decode(data.sublist(pos, pos + ridLen));
      pos += ridLen;

      // 讀取姓名
      int nLen = data[pos] & 0xFF;
      pos++;
      if (pos + nLen > data.length) return null;
      String name = utf8.decode(data.sublist(pos, pos + nLen));
      pos += nLen;

      // 讀取電話
      int pLen = data[pos] & 0xFF;
      pos++;
      if (pos + pLen > data.length) return null;
      String phone = utf8.decode(data.sublist(pos, pos + pLen));
      pos += pLen;

      // 讀取血型
      int btLen = data[pos] & 0xFF;
      pos++;
      String? bloodType;
      if (btLen > 0) {
        if (pos + btLen > data.length) return null;
        bloodType = utf8.decode(data.sublist(pos, pos + btLen));
      }
      pos += btLen;

      // 讀取狀態
      int sLen = data[pos] & 0xFF;
      pos++;
      if (pos + sLen > data.length) return null;
      String status = utf8.decode(data.sublist(pos, pos + sLen));
      pos += sLen;

      // 讀取補充說明（2字節大端序長度）
      if (pos + 2 > data.length) return null;
      int dLen = ((data[pos] & 0xFF) << 8) | (data[pos + 1] & 0xFF);
      pos += 2;
      String? description;
      if (dLen > 0) {
        if (pos + dLen > data.length) return null;
        description = utf8.decode(data.sublist(pos, pos + dLen));
      }
      pos += dLen;

      // 讀取緯度（8 字節 double）
      if (pos + 8 > data.length) return null;
      double lat = _decodeDouble(data.sublist(pos, pos + 8));
      pos += 8;

      // 讀取經度（8 字節 double）
      if (pos + 8 > data.length) return null;
      double lng = _decodeDouble(data.sublist(pos, pos + 8));
      pos += 8;

      // 讀取回報時間
      if (pos >= data.length) return null;
      int tLen = data[pos] & 0xFF;
      pos++;
      if (pos + tLen > data.length) return null;
      String reportTime = utf8.decode(data.sublist(pos, pos + tLen));

      return HealthReport(
        reporterId: reporterId,
        name: name,
        phone: phone,
        bloodType: bloodType,
        status: status,
        description: description,
        lat: lat != 0.0 ? lat : null,
        lng: lng != 0.0 ? lng : null,
        reportTime: DateTime.parse(reportTime),
      );
    } catch (e) {
      print('❌ Failed to decode HealthReport: $e');
      return null;
    }
  }

  // 輔助方法：編碼 double 為 8 字節大端序字節數組
  static List<int> _encodeDoubleToBytes(double value) {
    final buffer = ByteData(8);
    buffer.setFloat64(0, value, Endian.big);
    return buffer.buffer.asUint8List();
  }

  // 輔助方法：解碼 8 字節為 double
  static double _decodeDouble(List<int> bytes) {
    final buffer = ByteData(8);
    for (int i = 0; i < 8; i++) {
      buffer.setUint8(i, bytes[i] & 0xFF);
    }
    return buffer.getFloat64(0, Endian.big);
  }
}
