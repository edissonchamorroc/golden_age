class User {
  var _uid;
  var _name;
  var _email;
  var _password;
  var _genre;
  var _expertise;
  var _target;
  var _bornDate;

  User(this._uid, this._name, this._email, this._password, this._genre,
      this._expertise, this._target);

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

  get target => _target;

  set target(value) {
    _target = value;
  }

  get bornDate => _bornDate;

  set bornDate(value) {
    _bornDate = value;
  }
}
