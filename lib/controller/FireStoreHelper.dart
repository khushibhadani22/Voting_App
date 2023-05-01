import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFireStoreHelper {
  CloudFireStoreHelper._();

  static final CloudFireStoreHelper cloudFireStoreHelper =
      CloudFireStoreHelper._();

  CollectionReference leaderboard =
      FirebaseFirestore.instance.collection('leaderboard');

  static final FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
  late CollectionReference partyRef;
  late CollectionReference userRef;

  void connectWithPartyCollection() {
    partyRef = firebaseFireStore.collection('party');
  }

  void connectWithUserCollection() {
    userRef = firebaseFireStore.collection('user');
  }

  Future<void> insertRecord({
    required String email,
    required bool vote,
  }) async {
    connectWithUserCollection();
    Map<String, dynamic> data = {
      'email': email,
      'vote': vote,
    };
    await userRef.doc(email).set(data);
  }

  Stream<QuerySnapshot> selectPartyRecord() {
    connectWithPartyCollection();
    return partyRef.snapshots();
  }

  Stream<QuerySnapshot> selectUserRecord() {
    connectWithUserCollection();
    return userRef.snapshots();
  }

  Future<void> updateVote(
      {required Map<String, dynamic> voteData, required String email}) async {
    connectWithUserCollection();
    await userRef.doc(email).update(voteData);
  }

  Future<void> updateVoteNumber(
      {required Map<String, dynamic> voteNumber, required String id}) async {
    connectWithPartyCollection();
    await partyRef.doc(id).update(voteNumber);
  }
}
