class Consumption {
  final int? id;
  final String consumptionType;
  final double amount;
  final String date;
  final int homeId;

  Consumption({
    this.id,
    required this.consumptionType,
    required this.amount,
    required this.date,
    required this.homeId,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'consumption_type': consumptionType,
      'amount': amount,
      'date': date,
      'home_id': homeId,
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
      homeId: map['home_id'],
    );
  }

  DateTime get time => DateTime.parse(date);
}