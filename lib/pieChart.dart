// ignore_for_file: prefer_const_constructors, unused_field, camel_case_types, non_constant_identifier_names, file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:myapplication/Model/UserDetailsModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pie_chart/pie_chart.dart';

class pieChartScreen extends StatefulWidget {
  const pieChartScreen({super.key});

  @override
  State<pieChartScreen> createState() => _pieChartScreenState();
}

class _pieChartScreenState extends State<pieChartScreen> {
  List<UserDetailsModel>? _DisplayList = <UserDetailsModel>[];

  bool? network;
  ConnectivityResult? _connectivityResult;
  @override
  void initState() {
    super.initState();
    _checkConnectivityState();
    _firstLoad();
    setState(() {
      network = false;
    });
  }

  Future<void> _checkConnectivityState() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      setState(() {
        network = true;
      });
    } else {
      setState(() {
        network = false;
      });
    }

    setState(() {
      _connectivityResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pie Chart'),
          actions: [
            IconButton(
                onPressed: () {
                  _firstLoad();
                },
                icon: Icon(Icons.refresh))
          ],
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Card(
                    elevation: 5,
                    child: PieChart(
                      dataMap: {
                        'Male': _DisplayList!
                            .where((element) => element.gender == 'male')
                            .length
                            .toDouble(),
                        'Female': _DisplayList!
                            .where((element) => element.gender == 'female')
                            .length
                            .toDouble()
                      },
                      animationDuration: Duration(milliseconds: 800),
                      chartLegendSpacing: 32,
                      chartRadius: MediaQuery.of(context).size.width / 3.2,
                      colorList: [Colors.blue.shade300, Colors.pink.shade300],
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 20,
                      // centerText: "HYBRID",
                      legendOptions: LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: true,
                        // legendShape: _BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: false,
                        decimalPlaces: 1,
                      ),
                      // gradientList: ---To add gradient colors---
                      // emptyColorGradient: ---Empty Color gradient---
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Card(
                    elevation: 5,
                    child: PieChart(
                      dataMap: {
                        'Active': _DisplayList!
                            .where((element) => element.status == 'active')
                            .length
                            .toDouble(),
                        'In-Active': _DisplayList!
                            .where((element) => element.status == 'inactive')
                            .length
                            .toDouble()
                      },
                      animationDuration: Duration(milliseconds: 800),
                      chartLegendSpacing: 32,
                      chartRadius: MediaQuery.of(context).size.width / 3.2,
                      colorList: [Colors.green.shade300, Colors.red.shade300],
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 20,
                      // centerText: "HYBRID",
                      legendOptions: LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: true,
                        // legendShape: _BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: false,
                        decimalPlaces: 1,
                      ),
                      // gradientList: ---To add gradient colors---
                      // emptyColorGradient: ---Empty Color gradient---
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Future _firstLoad() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      dynamic json;
      if (network == true) {
        final res =
            await http.get(Uri.parse('https://gorest.co.in/public-api/users'));
        json = jsonDecode(res.body);
        preferences.setString('Jsonbody', res.body);
      } else {
        String? jsonData = preferences.getString('Jsonbody');
        json = jsonDecode(jsonData!);
      }
      List<UserDetailsModel> fetchedData = <UserDetailsModel>[];
      json['data']
          .forEach((e) => fetchedData.add(UserDetailsModel.fromJson(e)));
      _DisplayList = [];
      setState(() {
        _DisplayList = fetchedData;
      });

      return fetchedData;
    } catch (err) {
      throw Exception("Something went wrong while fetching data");
    }
  }
}
