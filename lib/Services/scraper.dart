import 'dart:convert';

import 'package:http/http.dart' as http;

class scrape{

  static Future<Map<String,dynamic>> scrapeProducts(var prod_name) async
  {
    var url = Uri.parse("");
    http.Response response = await http.get(url);
    Map<String,dynamic> results=json.decode(response.body);
    return results;
  }
}