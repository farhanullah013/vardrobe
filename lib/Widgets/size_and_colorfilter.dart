class sizefilter{
  List<String> _choices=['S','M','L','XL','XXL'];

  int get choicesize{
    return _choices.length;
  }
  List get choices{
    return [..._choices];
  }
}

class colorfilter{
  List<String> _colorchoices=['blue','red','black','yellow','green','white','grey'];

  int get colorchoicesize{
    return _colorchoices.length;
  }
  List get colorchoices{
    return [..._colorchoices];
  }
}
