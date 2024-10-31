class GoldenUser {
  var _uid;
  var _name;
  var _email;
  var _password;
  var _genre;
  var _expertise;
  var _objetive;
  var _bornDate;
  int _weight;
  

  GoldenUser(this._uid, this._name, this._email, this._password, this._genre,
      this._expertise, this._objetive, this._bornDate, this._weight);

  get uid => _uid;

  set uid(value) {
    _uid = value;
  }

  get name => _name;

  set name(value) {
    _name = value;
  }

  get genre => _genre;

  set genre(value) {
    _genre = value;
  }

  get password => _password;

  set password(value) {
    _password = value;
  }

  get email => _email;

  set email(value) {
    _email = value;
  }

  get expertise => _expertise;

  set expertise(value) {
    _expertise = value;
  }

  get target => _objetive;

  set target(value) {
    _objetive = value;
  }

  get bornDate => _bornDate;

  set bornDate(value) {
    _bornDate = value;
  }

  get weight => _weight;

  set weight(value) {
    _weight= value;
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': _uid,
      'name': _name,
      'email': _email,
      'password': _password,
      'genre': _genre,
      'expertise': _expertise,
      'objetive':_objetive,
      'bornDate':_bornDate,
      'progress': getProgress()
    };
  }

  Map<String, dynamic> getProgress(){
    return{
      'weight':_weight,
      'benchPressRM':0,
      'squatRM':0,
      'deadliftRM':0,
    };
  }
}
