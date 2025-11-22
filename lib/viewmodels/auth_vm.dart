import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_homework/models/app_user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthVm{
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<dynamic> createAccountbyemailandpassword({required AppUser user})async{
    try{
      UserCredential firebaseUser = await _firebaseAuth.createUserWithEmailAndPassword(email: user.email!, password: user.password!);
      firebaseUser.user!.updateDisplayName(user.name);
      user.id = firebaseUser.user!.uid;
      _db.collection("users").doc(user.id).set(user.toJSON());
      return true;
    }
    catch (e){
      return e.toString();
    }

  }

  Future<UserCredential?>createaccountbygoogle() async{
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if(googleUser != null){

      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      OAuthCredential credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken,accessToken:googleAuth.accessToken );
      return await _firebaseAuth.signInWithCredential(credential);
      //firebaseAuth.s
      //firebaseAuth.si
    }

    ///firebaseAuth.signInWithCredential(credential)
  }
    Stream<QuerySnapshot<Map<String,dynamic>>>readData(){
      FirebaseFirestore db = FirebaseFirestore.instance;
      return db.collection("users").snapshots();
    }

    Future<dynamic> login({required String email, required String password}) async {
      try {
        UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // هنا المستخدم موجود وتم تسجيل دخوله بنجاح
        return AppUser(
          email: userCredential.user!.email!,
          name: userCredential.user!.displayName ?? "",
          phone: userCredential.user!.phoneNumber ?? "",
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return "User does not exist";
        } else if (e.code == 'wrong-password') {
          return "Incorrect password";
        } else {
          return e.message ?? "Login failed";
        }
      } catch (e) {
        return "Error: $e";
      }
    }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
  logout(){
    _firebaseAuth.authStateChanges();
  }
}

