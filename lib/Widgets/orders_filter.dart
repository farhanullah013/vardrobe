class orderfilter{
  List<String> _choices=['Processing','Delivered'];

  int get choicesize{
    return _choices.length;
  }
  List get choices{
    return [..._choices];
  }
}