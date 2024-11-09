class Company {
  final int? id;
  final String symbol;
  final String name;
  final String region;
  final String open;
  final String close;

  Company({
    required this.symbol,
    required this.name,
    required this.region,
    required this.open,
    required this.close,
    this.id,
  });

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      symbol: map["1. symbol"] ?? '',
      name: map["2. name"] ?? '',
      region: map["4. region"] ?? '',
      open: map['1. open'] ?? '',
      close: map["4. close"] ?? '',
    );
  }
  factory Company.databaseFromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id'],
      symbol: map["symbol"] ?? '',
      name: map["name"] ?? '',
      region: map["region"] ?? '',
      open: map['open'] ?? '',
      close: map["close"] ?? '',
    );
  }
}
