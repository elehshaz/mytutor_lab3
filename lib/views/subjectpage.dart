import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/subject.dart';
import '../constants.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({Key? key}) : super(key: key);

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  List<Subject>? subjectList = <Subject>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth,ctrWidth;
  var pageNum , color, curPage = 1;
  TextEditingController searchController = TextEditingController();
  String search = "";

  @override
  void initState() {
    super.initState();
    _loadSubject(1,search);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      ctrWidth = screenWidth;
    } else {
      ctrWidth = screenWidth * 0.75;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Subjects'),
        actions: [
          IconButton(icon: const Icon(Icons.search),
          onPressed: () { 
            loadSearchDialog();
           },
          )
        ],
      ),
      body: subjectList!.isEmpty
      ? Center(
        child: Text(titlecenter,
          style: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold)))
      
      : Column(
          children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0,10,0,0),
            child: Text("Subjects Available",
              style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
               Expanded(
                    child: GridView.count(
                        crossAxisCount: 1,
                        childAspectRatio: (1 / 1),
                        children: List.generate(subjectList!.length, (index) {
                          return Card(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                  imageUrl: CONSTANTS.server +
                                      "/mytutor2/mobile/assets/courses/" +
                                      subjectList![index].subjectId.toString() +
                                      '.jpg',
                                  fit: BoxFit.cover,
                                  width: ctrWidth,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Flexible(
                                  flex: 4,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                            subjectList![index]
                                                .subjectName
                                                .toString(),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                fontSize: 20)),
                                        Text(
                                            subjectList![index]
                                                .subjectSessions
                                                .toString() +
                                                "Sessions ",
                                                style: const TextStyle(
                                                fontSize: 20)),
                                        
                                        Text(
                                            "RM " +
                                                double.parse(subjectList![index]
                                                .subjectPrice
                                                .toString())
                                                .toStringAsFixed(2),
                                                 style: const TextStyle(
                                                 fontSize: 25,
                                                 fontWeight: FontWeight.bold)),
                                        
                                        Text(
                                            "Rating: " +
                                                subjectList![index]
                                                .subjectRating
                                                .toString(),
                                                style: const TextStyle(
                                                fontSize: 20)),
                                      ],
                                    ),
                                  ))
                            ],
                          ));
                        }))),
                SizedBox(
                  height: 30,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if ((curPage - 1) == index) {
                        color = Colors.amber;
                      } else {
                        color = Colors.black;
                      }
                      return SizedBox(
                        width: 40,
                        child: TextButton(
                            onPressed: () => {_loadSubject(index + 1 ,search)},
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: color),
                            )),
                      );
                    },
                  ),
          )]));       
  }

   void _loadSubject(int pageno, String search) {
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor2/mobile/php/load_subjects.php"),
        body: {
          'pageno': pageno.toString(),
          'search': search,
        }).then((response) {
      var jsondata = jsonDecode(response.body);

      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
          if (extractdata['subjects'] != null) {
          subjectList = <Subject>[];
          extractdata['subjects'].forEach((v) {
            subjectList!.add(Subject.fromJson(v));
          });
          setState((){});
        } else{
          titlecenter = "No Subject Available";
          setState((){});
        }
      }
    });
  }
  
  void loadSearchDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  "Search Subject",
                ),
                content: SizedBox(
                  height: screenHeight/2,
                  child: Column(
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                                labelText: 'Enter Subject',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                      ),
                      ElevatedButton(
                        onPressed: (){
                          search: searchController.text;
                          Navigator.of(context).pop();
                          _loadSubject(1,search);
                      },
                      child: const Text("Search"),
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      "Close",
                      style: TextStyle(),
                    ),
                    onPressed: (){
                      Navigator.of(context).pop();
                    }
                  )
                ]
              );
            },
          );
        }
  }

      

 