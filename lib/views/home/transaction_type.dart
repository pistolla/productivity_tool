enum TransactionType { Recharge, Payment, Withdraw, All }

enum TransactionStatus { Pending, Successful, Failed }

enum ChronoMeter { Custom, Daily, Weekly, Monthly, yearly }

class DataItem {
  int x;
  Map<String, double> y;

  DataItem({required this.x, required this.y});

  @override
  String toString() {
    return {"x": x, "y": y}.toString();
  }
}
