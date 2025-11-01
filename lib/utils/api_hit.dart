import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = "https://api.jikan.moe/v4";

Future<dynamic> fetchDataAnime({int page = 1, String filter = "", String rating = ""}) async {
  if(filter != ""){
    filter = "&filter=${filter.toLowerCase()}";
  }

  if(rating != ""){
    rating = "&rating=${rating.toLowerCase()}";
  }
  try {
    final response = await http.get(Uri.parse('$baseUrl/top/anime?page=$page$filter$rating'));
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body)["data"];
      return res;
    } else {
      throw Exception('Failed to load data from API');
    }
  } catch (e) {
    throw Exception('Error occurred while fetching data: $e');
  }
}

Future<dynamic> fetchDataManga({int page = 1}) async {

  try {
    final response = await http.get(Uri.parse('$baseUrl/top/manga?page=$page'));

    if (response.statusCode == 200) {
      var res = jsonDecode(response.body)["data"];
      return res;
    } else {
      throw Exception('Failed to load data from API');
    }
  } catch (e) {
    throw Exception('Error occurred while fetching data: $e');
  }
}