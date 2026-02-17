class Consumption {
  final int? id;
  final String consumptionType;
  final double amount;
  final String date;
  final String homeName;

  Consumption({
    this.id,
    required this.consumptionType,
    required this.amount,
    required this.date,
    required this.homeName,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'consumption_type': consumptionType,
      'amount': amount,
      'date': date,
      'home_name': homeName,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Consumption.fromMap(Map<String, dynamic> map) {
    return Consumption(
      id: map['id'],
      consumptionType: map['consumption_type'],
      amount: map['amount'],
      date: map['date'],
      homeName: map['home_name'],
    );
  }

  DateTime get time => DateTime.parse(date);
}