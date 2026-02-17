enum ConsumptionType {
  electricity('kWh'),
  gas('m3'),
  water('liters');

  final String unit;
  
  const ConsumptionType(this.unit);
}