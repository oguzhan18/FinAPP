class Breakdown {
  String _id;
  int _cost;
  String _type;
  String _category;

  int _year;
  int _month;
  int _day;
  int _hour;
  int _minute;

  String get id => _id;

  Breakdown(this._type, this._cost, this._category) {
    DateTime date = new DateTime.now();
    _id = date.toString();
    _year = date.year;
    _month = date.month;
    _day = date.day;
    _hour = date.hour;
    _minute = date.minute;
  }

  int get cost => _cost;
  String get type => _type;
  String get category => _category;
  int get year => _year;
  int get month => _month;
  int get day => _day;
  int get hour => _hour;
  int get minute => _minute;

  Map<String, dynamic>toMap() {
    return <String, dynamic> {
      '_id': _id,
      'cost': _cost,
      'type': _type,
      'category': _category,
      'year': _year,
      'month': _month,
      'day': _day,
      'hour': _hour,
      'minute':_minute
    };
  }
  Breakdown.fromMap(Map<String, dynamic> map) {
    this._id = map['_id'];
    this._cost = map['cost'];
    this._type = map['type'];
    this._category = map['category'];
    this._year = map['year'];
    this._month = map['month'];
    this._day = map['day'];
    this._hour = map['hour'];
    this._minute = map['minute'];
  }



  set type(String value) {
    _type = value;
  }

  set category(String value) {
    _category = value;
  }

  set cost(int value) {
    _cost = value;
  }

}