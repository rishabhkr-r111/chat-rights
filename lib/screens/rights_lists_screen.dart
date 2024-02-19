import 'package:flutter/material.dart';

// Dummy data for Indian laws
final List<Map<String, String>> indianLawsList = [
  {"name": "Union of India-Act", "year": "1947"},
  {"name": "Constitution and Amendments", "year": "1950"},
  {"name": "United Nations Conventions", "year": "1945"},
  {"name": "International Treaty- Act", "year": "1969"},
];

// Dummy data for state laws
final List<Map<String, String>> stateLawsList = [
  {"name": "State of Andhra Pradesh - Act", "year": "1956"},
  // Add more state laws as needed
];

// Dummy data for British laws
final List<Map<String, String>> britishLawsList = [
  {"name": "British India - Act", "year": "1858"},
  // Add more British laws as needed
];

class RightsListsScreen extends StatelessWidget {
  const RightsListsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text('Rights List', style: TextStyle(color: Colors.white)),
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
            style: TextStyle(
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
          _showYearDialog(context, law["name"]!, law["year"]!);
        },
      ),
    );
  }

  void _showYearDialog(BuildContext context, String lawName, String year) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedYear = year;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.blueGrey[900],
              title: Text(
                lawName,
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Year:',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    dropdownColor: Colors.blueGrey[800],
                    value: selectedYear,
                    style: TextStyle(color: Colors.white),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedYear = newValue!;
                      });
                    },
                    items: List.generate(
                      100,
                      (index) => DropdownMenuItem(
                        value: (1900 + index).toString(),
                        child: Text((1900 + index).toString()),
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
