class GoldenUser {
  String _uid;
  String _name;
  String _genre;
  String _expertise;
  String _objective;
  String _bornDate;
  String _weight;
  String _email="";
  String _password="";

  GoldenUser(
    this._uid,
    this._name,
    this._genre,
    this._expertise,
    this._objective,
    this._bornDate,
    this._weight,
  );

  String get uid => _uid;
  set uid(String value) => _uid = value;

  String get name => _name;
  set name(String value) => _name = value;

  String get genre => _genre;
  set genre(String value) => _genre = value;

  String get expertise => _expertise;
  set expertise(String value) => _expertise = value;

  String get objective => _objective;
  set objective(String value) => _objective = value;

  String get bornDate => _bornDate;
  set bornDate(String value) => _bornDate = value;

  String get weight => _weight;
  set weight(String value) => _weight = value;

  String get email => _email;
  set email(String value) => _email = value;

  String get password => _password;
  set password(String value) => _password = value;

  Map<String, dynamic> toMap() {
    return {
      'uid': _uid,
      'name': _name,
      'genre': _genre,
      'expertise': _expertise,
      'objective': _objective,
      'bornDate': _bornDate,
      'weight': _weight,
    };
  }

  factory GoldenUser.fromMap(Map<String, dynamic> data) {
    return GoldenUser(
      data['uid'] as String,
      data['name'] as String,
      data['genre'] as String,
      data['expertise'] as String,
      data['objective'] as String,
      data['bornDate'] as String,
      data['weight'] as String,
    );
  }
}
