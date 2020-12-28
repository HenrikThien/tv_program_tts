import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class RssClient {
  final String currentTvProgram = "https://www.tvspielfilm.de/tv-programm/rss/jetzt.xml";

  Future<List<TvProgram>> getCurrentProgram() async {
    var response = await http.get(currentTvProgram);
    var tvList = new List<TvProgram>();

    if (response.statusCode == 200) {
      var rssFeed = RssFeed.parse(utf8.decode(response.bodyBytes));

      for (var item in rssFeed.items) {
        var split = item.title.trim().split('|');

        tvList.add(TvProgram(
          time: _getSplitItem(split, 0),
          sender: _getSplitItem(split, 1),
          title: _getSplitItem(split, 2),
          link: item.link,
          description: item.description,
          imageUrl: (item.enclosure != null) ? item.enclosure.url : "",
        ));
      }
    } else {
      tvList.add(TvProgram(status: false));
    }

    return tvList;
  }

  String _getSplitItem(List<String> split, int index) => split.length > index - 1 ? split[index] : "NULL";
}

class TvProgram {
  final String sender;
  final String title;
  final String time;
  final String link;
  final String description;
  final String imageUrl;

  final bool status;

  const TvProgram({this.sender, this.title, this.time, this.link, this.description, this.imageUrl, this.status});
}
