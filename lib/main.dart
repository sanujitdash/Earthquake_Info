// ignore_for_file: unnecessary_new, deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

late Map _data;
late List _attributes;
void main() async {
  _data = await getEarthquake();

  //print(_data['features'][0]['properties']);
  _attributes = _data['features'];

  runApp(const MaterialApp(
    title: 'Earthquakes',
    home: Earthquake(),
  ));
}

class Earthquake extends StatelessWidget {
  const Earthquake({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Earthquakes'),
        backgroundColor: Colors.amber,
      ),
      body: new Center(
        child: new ListView.builder(
            itemCount: _attributes.length,
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (BuildContext context, int position) {
              if (position.isOdd) return const Divider();
              final index = position ~/ 2;
              //we are dividing the postion by 2 and returning an integer result

              var format = new DateFormat.yMMMMd("en_US").add_jm();
              //var dateString = format.format(date);
              var date = format.format(DateTime.fromMicrosecondsSinceEpoch(
                  _attributes[index]['properties']['time'] * 1000,
                  isUtc: true));

              return ListTile(
                title: new Text(
                  "On: $date",
                  style: const TextStyle(
                      fontSize: 13,
                      color: Colors.green,
                      fontWeight: FontWeight.w600),
                ),
                subtitle: new Text(
                  "${_attributes[index]['properties']['place']}",
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.blueGrey,
                      fontStyle: FontStyle.italic),
                ),
                leading: new CircleAvatar(
                  backgroundColor: Colors.yellowAccent,
                  child: new Text(
                    "${_attributes[index]['properties']['mag']}",
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                onTap: () {
                  _showMessage(context,
                      "Find out more at: ${_attributes[index]['properties']['detail']}");
                },
              );
            }),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    var alert = new AlertDialog(
      title: const Text('Earthquake'),
      content: new Text(message),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'))
      ],
    );
    showDialog(builder: (context) => alert, context: context);
    //some changes were made
  }
}

Future<Map> getEarthquake() async {
  var url = Uri.parse(
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson');
  http.Response response = await http.get(url);
  return json.decode(response.body);
}
