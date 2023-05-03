import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../controller/FireBaseAuth.dart';
import '../../controller/FireStoreHelper.dart';
import '../../modal/global.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Voting App",
          style: TextStyle(color: Colors.cyan.shade900),
        ),
        centerTitle: true,
        leading: Icon(
          Icons.where_to_vote,
          color: Colors.cyan.shade900,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('result_page');
            },
            icon: Icon(
              Icons.leaderboard,
              color: Colors.cyan.shade900,
            ),
          ),
          IconButton(
            onPressed: () async {
              await FireBaseAuthHelper.fireBaseAuthHelper.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('login_page', (route) => false);
            },
            icon: Icon(
              Icons.logout,
              color: Colors.cyan.shade900,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: CloudFireStoreHelper.cloudFireStoreHelper.selectPartyRecord(),
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
                              child: InkWell(
                                onTap: () {
                                  if (Global.user!['vote'] == false) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            "Are You Sure To Vote?",
                                            style: TextStyle(
                                                color: Colors.cyan.shade900,
                                                fontSize: 20),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.cyan.shade900,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                "No",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.cyan.shade900,
                                              ),
                                              onPressed: () async {
                                                int vote = documents[i]['vote'];
                                                vote++;
                                                Map<String, dynamic>
                                                    voteNumber = {
                                                  'vote': vote,
                                                };
                                                await CloudFireStoreHelper
                                                    .cloudFireStoreHelper
                                                    .updateVoteNumber(
                                                  voteNumber: voteNumber,
                                                  id: documents[i].id,
                                                );

                                                Map<String, dynamic>
                                                    updatedData = {
                                                  'vote': true,
                                                };
                                                await CloudFireStoreHelper
                                                    .cloudFireStoreHelper
                                                    .updateVote(
                                                        voteData: updatedData,
                                                        email: Global
                                                            .user!['email']);
                                                Global.user!['vote'] = true;
                                                setState(() {
                                                  Global.voteP
                                                      .add(documents[i]);
                                                  print(Global.user!['vote']);
                                                });
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                        'vote_page');
                                              },
                                              child: const Text(
                                                "Yes",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.cyan,
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(
                                            "You have already voted......"),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 120,
                                  width: 350,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Colors.cyan.shade900, width: 4),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                "${documents[i]['cImage']}"
                                                //  "https://upload.wikimedia.org/wikipedia/commons/c/c0/Official_Photograph_of_Prime_Minister_Narendra_Modi_Potrait.png"
                                                ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${documents[i]['cName']}",
                                            style: TextStyle(
                                              color: Colors.cyan.shade900,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                            ),
                                          ),
                                          Text(
                                            "${documents[i]['primeName']}",
                                            style: TextStyle(
                                              color: Colors.cyan.shade900,
                                              // fontWeight: FontWeight.bold,
                                              fontSize: 15,
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
                            ),
                          ],
                        );
                      },
                    )
                  : Container();
            } else {
              return Center(
                child: CircularProgressIndicator(color: Colors.cyan.shade900),
              );
            }
          }),
    );
  }
}
