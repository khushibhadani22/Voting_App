import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../modal/global.dart';

class VotePage extends StatefulWidget {
  const VotePage({Key? key}) : super(key: key);

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leaderboard",
          style: TextStyle(color: Colors.cyan.shade900),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.cyan.shade900,
          ),
        ),
      ),
      body:
          // Column(
          //   children: [
          //     Text(
          //       "bjhdshfjkesf",
          //       style: TextStyle(fontSize: 53, color: Colors.blue),
          //     )
          //   ],
          // )

          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('leaderboard')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: SelectableText("${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  QuerySnapshot? data = snapshot.data;
                  List<QueryDocumentSnapshot> documents = data!.docs;
                  return (documents.isNotEmpty)
                      ? ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, i) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 140,
                                    width: 350,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Colors.cyan.shade900,
                                          width: 4),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "https://upload.wikimedia.org/wikipedia/commons/c/c0/Official_Photograph_of_Prime_Minister_Narendra_Modi_Potrait.png")),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "${documents[i]['cName']}",
                                              style: TextStyle(
                                                color: Colors.cyan.shade900,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                              ),
                                            ),
                                            Text(
                                              "${documents[i]['primeName']}",
                                              style: TextStyle(
                                                color: Colors.cyan.shade900,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              "1  ${documents[i]['vote']}",
                                              style: TextStyle(
                                                color: Colors.cyan.shade900,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "${documents[i]['image']}"
                                                    // "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Bharatiya_Janata_Party_logo.svg/1200px-Bharatiya_Janata_Party_logo.svg.png"
                                                    ),
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        )
                      : Container();
                } else {
                  return Center(
                    child:
                        CircularProgressIndicator(color: Colors.cyan.shade900),
                  );
                }
              }),
    );
  }
}
