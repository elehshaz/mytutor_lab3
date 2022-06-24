import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/tutor.dart';
import '../constants.dart';

class TutorPage extends StatefulWidget {
  const TutorPage({Key? key}) : super(key: key);

  @override
  State<TutorPage> createState() => _TutorPageState();
}

class _TutorPageState extends State<TutorPage> {
  List<Tutor>? tutoList = <Tutor>[];
  String titlecenter = "No Tutors Available";
  late double screenHeight, screenWidth, ctrWidth;
  var pageNum , color, curPage = 1;

  @override
  void initState() {
    super.initState();
    _loadTutors();
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
        title: const Text('Tutors'),
      ),
      body: tutoList!.isEmpty
      ? Center(
        child: Text(titlecenter,
          style: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold,)))
      : Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0,10,0,0),
            child: Text("Tutors Available",
              style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          )),
            Expanded(
              child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(tutoList!.length,(index){
                    return InkWell(
                      onTap: ()=>{loadTutorDetails(index)},
                      child: Column(
                        children: [
                          Flexible(flex: 6,
                          child: CachedNetworkImage(
                            imageUrl: CONSTANTS.server + "/mytutor2/mobile/assets/tutors/"+
                            tutoList![index].tutorId.toString() +
                            '.jpg',
                            placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),  
                            
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: Column(
                              children: [
                                const Text("Name:",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 14)),
                          
                                const SizedBox(height: 10),   
                                const Text("Email:",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 14)),   
                                Text(
                                  tutoList![index]
                                  .tutorEmail
                                  .toString(),
                                style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),

                                const SizedBox(height: 10),   
                                const Text("Phone: ",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 14)),   
                                Text(
                                  tutoList![index]
                                  .tutorPhone
                                  .toString(),
                                  style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],       
                                ),
                              ),
                            ],
                          )
                        );
                }))),
                    SizedBox(
                  height: 30,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: pageNum,
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
                            onPressed: () => {_loadTutors()},
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: color),
                            )),
                      );
                    },
                  ),
            
      )]));
  }

  void _loadTutors() {
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor2/mobile/php/load_tutors.php"),
        body: {}).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        if (extractdata['tutors'] != null) {
          tutoList = <Tutor>[];
          extractdata['tutors'].forEach((v) {
            tutoList!.add(Tutor.fromJson(v));
          });
        }
      }
    });
  }
  
  loadTutorDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Tutor Details",
              textAlign: TextAlign.center,
              style: TextStyle(),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: CONSTANTS.server +
                      "/mytutor2/mobile/assets/tutors/" +
                      tutoList![index].tutorId.toString() +
                      '.jpg',
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                
                Column(crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  const Text("Name:",
                          style: TextStyle(fontSize: 14)),
                          Text(tutoList![index].tutorName.toString(),
                          style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
 
                  const Text("Email:", 
                        style: TextStyle(fontSize: 14)),
                        Text(tutoList![index].tutorEmail.toString(),
                        style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                  
                  const Text("Phone:", 
                        style: TextStyle(fontSize: 14)),
                        Text(tutoList![index].tutorPhone.toString(),
                        style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                  
                  const Text("Subject:", 
                        style: TextStyle(fontSize: 14)),
                        Text(tutoList![index].subjectName.toString(),
                        style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                ])
              ],
            )),
            actions: [
              TextButton(
                child: const Text(
                  "Close",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
      



