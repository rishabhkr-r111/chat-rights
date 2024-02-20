import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class Law {
  final String title;
  final String href;

  Law({required this.title, required this.href});

  factory Law.fromJson(Map<String, dynamic> json) {
    return Law(
      title: json['title'],
      href: json['href'],
    );
  }
}

class ResultsPage extends StatefulWidget {
  final String lawName;
  final String year;

  ResultsPage({required this.lawName, required this.year});

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late Future<http.Response> futureResponse;

  @override
  void initState() {
    super.initState();
    futureResponse = http.get(Uri.parse(
        'https://api-chat-rights-35jloclotq-el.a.run.app/advsearch/?query=${widget.lawName}&fromdate=${widget.year}'));
  }

  @override
  Widget build(BuildContext context) {
    void launchURL(String urll) async {
      Uri url = Uri.parse(urll);
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.lawName} - ${widget.year}'),
      ),
      body: FutureBuilder<http.Response>(
        future: futureResponse,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Law> laws = (jsonDecode(snapshot.data!.body) as List)
                .map((data) => Law.fromJson(data))
                .toList();
            return ListView.builder(
              itemCount: laws.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2.0,
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Color.fromRGBO(50, 65, 85, 0.9)),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      leading: Container(
                        padding: EdgeInsets.only(right: 12.0),
                        decoration: BoxDecoration(
                          border: Border(
                            right:
                                BorderSide(width: 1.0, color: Colors.white24),
                          ),
                        ),
                        child: Icon(Icons.donut_large, color: Colors.white),
                      ),
                      title: Text(
                        laws[index].title,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      trailing: Icon(Icons.arrow_forward,
                          color: Colors.white, size: 30.0),
                      onTap: () {
                        launchURL(
                            'https://indiankanoon.org' + laws[index].href);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
