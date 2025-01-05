class Note {
  int? _id; // Made nullable to align with database auto-increment IDs.
  String _title;
  String _description;
  String _date;
  int _priority;

  // Main constructor
  Note(this._title, this._description,this._priority, this._date);

  // Named constructor for objects with ID
  Note.withId(this._id, this._title, this._description, this._date, this._priority);

  // Getters
  int? get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  int get priority => _priority;

  // Setters with validation
  set title(String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      _description = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      _priority = newPriority;
    }
  }

  set date(String newDate) {
    _date = newDate;
  }

  // Convert a Note object to a Map
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (_id != null) {
      map["id"] = _id;
    }
    map["title"] = _title;
    map["description"] = _description;
    map["priority"] = _priority;
    map["date"] = _date;
    return map;
  }

  // Extract a Note object from a Map
  Note.fromMapObject(Map<String, dynamic> map)
      : _id = map["id"],
        _title = map["title"],
        _description = map["description"],
        _date = map["date"],
        _priority = map["priority"];
}
