import 'package:flutter/material.dart';
import 'package:kang_nime/utils/api_hit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("KangNime", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.account_box, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 30,
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.orange, width: 5)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(width: 30),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Search',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                SizedBox(width: 30),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 200,
              color: Colors.blue,
              child: Center(child: Text("tes Area")),
            ),
            Column(
              children: [
                ElevatedButton(onPressed: (){
                  fetchDataFromApi();
                }, child: Text("Test API"))
              ]
            ),
          ],
        ),
      ),
    );
  }
}
