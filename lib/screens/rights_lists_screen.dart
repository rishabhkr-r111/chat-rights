import 'package:flutter/material.dart';
import 'package:chat_rights/utils/colors.dart';
import 'package:chat_rights/utils/global_variable.dart';
import 'package:chat_rights/screens/results_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final List<Map<String, String>> indianLawsList = [
  {"name": "Union of India-Act", "url": "union-act"},
  {"name": "Constitution and Amendments", "url": "constitution-amendments"},
  {"name": "United Nations Conventions", "url": "un-convention"},
  {"name": "International Treaty- Act", "url": "treaty-act"},
];

final List<Map<String, String>> stateLawsList = [
  {"name": "State of Andhra Pradesh - Act", "url": "andhra-act"},
  // Add more state laws as needed
];

final List<Map<String, String>> britishLawsList = [
  {"name": "British India - Act", "url": "british-act"},
  // Add more British laws as needed
];

class RightsListsScreen extends StatelessWidget {
  const RightsListsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: const Text('Browse Rights'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection('Indian Laws', indianLawsList),
            _buildSection('State Laws', stateLawsList),
            _buildSection('British Laws', britishLawsList),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, String>> laws) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12.0),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: laws.length,
            itemBuilder: (context, index) {
              return _buildRightCard(context, laws[index], index + 1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRightCard(
      BuildContext context, Map<String, String> law, int index) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.blueGrey[800],
      child: ListTile(
        title: Text(
          law["name"]!,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey[900],
          child: Text(
            '$index',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
        ),
        onTap: () {
          _showYearPopup(context, law["url"]!);
        },
      ),
    );
  }

  void _showYearPopup(BuildContext context, String lawName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: http.get(Uri.parse(
              'https://api-chat-rights-35jloclotq-el.a.run.app/years/$lawName')),
          builder:
              (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('${snapshot.error}'),
                );
              } else {
                List<String> years =
                    (jsonDecode(snapshot.data!.body) as List<dynamic>)
                        .cast<String>();
                return AlertDialog(
                  title: Text(lawName),
                  content: Container(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: years.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(years[index]),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResultsPage(
                                    lawName: lawName,
                                    year: "1-1-" + years[index]),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              }
            } else {
              return AlertDialog(
                title: Text('Loading ...'),
              );
            }
          },
        );
      },
    );
  }
}
