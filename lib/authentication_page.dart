import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'main.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _EmailPasswordSignInState();
}

class _EmailPasswordSignInState extends State<AuthenticationPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String error = '';
  
  @override
  void initState() {
    FirebaseAuth.instanceFor(app: app).userChanges().listen((User? user) {
      error = '';
      if(user == null) {
        setState(() {});
        debugPrint('........................... SIGNED OUT');
      } else {
        // user.reload();
        setState(() {});
        debugPrint('........................... SIGNED IN (uid: ${user.uid}, isAnonymous: ${user.isAnonymous})');
      }
    });

    // FirebaseAuth.instanceFor(app: app).authStateChanges().listen((User? user) {
    //   if(user == null) {
    //     debugPrint('........................... SIGNED OUT');
    //   } else {
    //     debugPrint('........................... SIGNED IN (uid: ${user.uid}, isAnonymous: ${user.isAnonymous})');
    //   }
    // });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('uid: ${FirebaseAuth.instance.currentUser?.uid}'),
                Text('displayName: ${FirebaseAuth.instance.currentUser?.displayName}'),
                Text('photoURL: ${FirebaseAuth.instance.currentUser?.photoURL}'),
                Text('email: ${FirebaseAuth.instance.currentUser?.email}'),
                Text('emailVerified: ${FirebaseAuth.instance.currentUser?.emailVerified}'),
                Text('phoneNumber: ${FirebaseAuth.instance.currentUser?.phoneNumber}'),
                Text('isAnonymous: ${FirebaseAuth.instance.currentUser?.isAnonymous}'),
                Text('providerData: ${FirebaseAuth.instance.currentUser?.providerData.first.providerId}'),
                Text('ERROR: $error'),
                // SizedBox(height: 70,),
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text('Refresh'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter Email/Name',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: 'Enter Password',
                        ),
                      ),
                    ),
                    SizedBox(height: 70,),

                    if(FirebaseAuth.instance.currentUser == null)
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await GoogleSignIn.instance.initialize(
                            serverClientId: dotenv.env['CLIENT_ID'],
                          );

                          GoogleSignInAccount googleSignInAccount = await GoogleSignIn.instance.authenticate();

                          String? idToken = googleSignInAccount.authentication.idToken;

                          OAuthCredential googleAuthCredentials = GoogleAuthProvider.credential(idToken: idToken,);

                          // FirebaseAuth.instance.fetchSignInMethodsForEmail('email');

                          UserCredential userCredential = await FirebaseAuth.instanceFor(app: app).signInWithCredential(googleAuthCredentials);

                          User? user = userCredential.user;

                          debugPrint('..................... google sign in | uid ${user?.uid}');
                          debugPrint('..................... google sign in | displayName ${user?.displayName}');
                          debugPrint('..................... google sign in | photoURL ${user?.photoURL}');
                          debugPrint('..................... google sign in | email ${user?.email}');
                          debugPrint('..................... google sign in | emailVerified ${user?.emailVerified}');
                          debugPrint('..................... google sign in | phoneNumber ${user?.phoneNumber}');

                          error = '';
                          setState(() {});
                        } catch (e) {
                          String error = e is GoogleSignInException
                              ? '..................... GoogleSignInException ${e.code}: ${e.description}'
                              : 'Unknown error: $e';
                          this.error = error;
                          setState(() {});
                          debugPrint('........................... google sign in error: $error');
                        }
                      },
                      child: const Text('Continue With Google'),
                    ),

                    if(FirebaseAuth.instance.currentUser == null)
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                          );

                          User? user = credential.user;

                          debugPrint('..................... sign in | uid ${user?.uid}');
                          debugPrint('..................... sign in | displayName ${user?.displayName}');
                          debugPrint('..................... sign in | photoURL ${user?.photoURL}');
                          debugPrint('..................... sign in | email ${user?.email}');
                          debugPrint('..................... sign in | emailVerified ${user?.emailVerified}');
                          debugPrint('..................... sign in | phoneNumber ${user?.phoneNumber}');

                          error = '';
                          setState(() {});
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            debugPrint('..................... sign in ${e.code} : ${e.message}');
                          } else if (e.code == 'wrong-password') {
                            debugPrint('..................... sign in ${e.code} : ${e.message}');
                          } else if (e.code == 'invalid-credentials') {
                            debugPrint('..................... sign in ${e.code} : ${e.message}');
                          }

                          error = '${e.code} | ${e.message}';
                          setState(() {});
                        } catch(e) {
                          error = e.toString();
                          setState(() {});
                        }
                      },
                      child: Text('Sign In'),
                    ),

                    if(FirebaseAuth.instance.currentUser == null)
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );

                          User? user = credential.user;

                          debugPrint('..................... sign up | uid ${user?.uid}');
                          debugPrint('..................... sign up | displayName ${user?.displayName}');
                          debugPrint('..................... sign up | photoURL ${user?.photoURL}');
                          debugPrint('..................... sign up | email ${user?.email}');
                          debugPrint('..................... sign up | emailVerified ${user?.emailVerified}');
                          debugPrint('..................... sign up | phoneNumber ${user?.phoneNumber}');

                          error = '';
                          setState(() {});
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            debugPrint('..................... sign up ${e.code} : ${e.message}');
                          } else if (e.code == 'email-already-in-use') {
                            debugPrint('..................... sign up ${e.code} : ${e.message}');
                          }

                          error = '${e.code} | ${e.message}';
                          setState(() {});
                        } catch (e) {
                          error = e.toString();
                          setState(() {});
                          debugPrint(e.toString());
                        }
                      },
                      child: Text('Sign Up'),
                    ),

                    if(FirebaseAuth.instance.currentUser != null)
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        debugPrint('..................... SIGNED OUT');

                        setState(() {});

                        if(context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('SIGNED OUT'))
                        );
                        }
                      },
                      child: Text('Sign Out'),
                    ),

                    if(FirebaseAuth.instance.currentUser != null)
                      ElevatedButton(
                        onPressed: () async {
                          User? user = FirebaseAuth.instance.currentUser;

                          for (final providerProfile in user!.providerData) {
                            // ID of the provider (google.com, apple.com, etc.)
                            debugPrint('..................... providerProfile.providerId: ${providerProfile.providerId}');

                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(providerProfile.providerId))
                            );
                          }
                        },
                        child: Text('Get Provider Info'),
                      ),

                    if(FirebaseAuth.instance.currentUser != null)
                      ElevatedButton(
                        onPressed: () async {
                          User? user = FirebaseAuth.instance.currentUser;

                          await user?.updateDisplayName(emailController.text);

                          debugPrint('..................... updatedDisplayName: ${user?.displayName}');

                          setState(() {});

                          if(context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Display name updated successfully'))
                          );
                          }
                        },
                        child: Text('Update Display Name'),
                      ),

                    if(FirebaseAuth.instance.currentUser != null)
                      ElevatedButton(
                        onPressed: () async {
                          User? user = FirebaseAuth.instance.currentUser;

                          await user?.updatePhotoURL(emailController.text);

                          debugPrint('..................... updatedPhotoURL: ${user?.photoURL}');

                          setState(() {});

                          if(context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Photo URL updated successfully'))
                          );
                          }
                        },
                        child: Text('Update Photo URL'),
                      ),

                    if(FirebaseAuth.instance.currentUser != null)
                      ElevatedButton(
                        onPressed: () async {
                          User? user = FirebaseAuth.instance.currentUser;

                          await user?.verifyBeforeUpdateEmail(emailController.text);

                          debugPrint('..................... updatedEmail: ${user?.email}');

                          setState(() {});

                          if(context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Email updated successfully'))
                          );
                          }
                        },
                        child: Text('Update Email'),
                      ),

                    if(FirebaseAuth.instance.currentUser != null)
                      ElevatedButton(
                        onPressed: () async {
                          User? user = FirebaseAuth.instance.currentUser;

                          await FirebaseAuth.instance.setLanguageCode('en');
                          await user?.sendEmailVerification();

                          debugPrint('..................... sendEmailVerification | isEmailVerified: ${user?.emailVerified}');

                          if(context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Verification Email sent successfully'))
                          );
                          }
                        },
                        child: Text('Send Verification Email'),
                      ),

                    if(FirebaseAuth.instance.currentUser != null)
                      ElevatedButton(
                        onPressed: () async {
                          User? user = FirebaseAuth.instance.currentUser;

                          await user?.updatePassword(passwordController.text);

                          debugPrint('..................... Password updated successfully');

                          if(context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Password updated successfully'))
                          );
                          }
                        },
                        child: Text('Update Password'),
                      ),

                    if(FirebaseAuth.instance.currentUser != null)
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.setLanguageCode('en');
                          await FirebaseAuth.instance.sendPasswordResetEmail(email: FirebaseAuth.instance.currentUser!.email!);

                          debugPrint('..................... Password reset email sent successfully');

                          if(context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Password reset email sent successfully'))
                          );
                          }
                        },
                        child: Text('Send Password Reset Email'),
                      ),

                    if(FirebaseAuth.instance.currentUser != null)
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.currentUser!.delete();

                          debugPrint('..................... User deleted successfully');

                          setState(() {});

                          if(context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('User deleted successfully'))
                          );
                          }
                        },
                        child: Text('Delete User'),
                      ),

                    if(FirebaseAuth.instance.currentUser != null)
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await GoogleSignIn.instance.initialize(
                              // clientId: '21321383900-vik2q86s5p3iqhsuvdk77e1jbebp2rkj.apps.googleusercontent.com',
                              // serverClientId: '21321383900-vik2q86s5p3iqhsuvdk77e1jbebp2rkj.apps.googleusercontent.com',
                              serverClientId: dotenv.env['CLIENT_ID'],
                            );

                            GoogleSignInAccount googleSignInAccount = await GoogleSignIn.instance.authenticate();

                            String? idToken = googleSignInAccount.authentication.idToken;

                            OAuthCredential googleAuthCredentials = GoogleAuthProvider.credential(idToken: idToken,);

                            // Prompt the user to re-provide their sign-in credentials.
                            // Then, use the credentials to re-authenticate:
                            UserCredential? userCredential = await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(googleAuthCredentials);

                            User? user = userCredential?.user;

                            debugPrint('..................... google sign in | re-authenticate | uid ${user?.uid}');
                            debugPrint('..................... google sign in | re-authenticate | displayName ${user?.displayName}');
                            debugPrint('..................... google sign in | re-authenticate | photoURL ${user?.photoURL}');
                            debugPrint('..................... google sign in | re-authenticate | email ${user?.email}');
                            debugPrint('..................... google sign in | re-authenticate | emailVerified ${user?.emailVerified}');
                            debugPrint('..................... google sign in | re-authenticate | phoneNumber ${user?.phoneNumber}');

                            error = '';
                            setState(() {});

                            if(context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Google User re-authenticated successfully'))
                            );
                            }
                          } catch (e) {
                            String error = e is GoogleSignInException
                                ? '..................... GoogleSignInException  | re-authenticate | ${e.code}: ${e.description}'
                                : 'Unknown error: $e';

                            error = e.toString();
                            setState(() {});
                            debugPrint('........................... google sign in error  | re-authenticate: $error');
                          }
                        },
                        child: Text('Re-authenticate Google User'),
                      ),

                    if(FirebaseAuth.instance.currentUser != null)
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            AuthCredential credential = EmailAuthProvider.credential(
                              email: emailController.text,
                              password: passwordController.text,
                            );

                            // Prompt the user to re-provide their sign-in credentials.
                            // Then, use the credentials to re-authenticate:
                            UserCredential? userCredential = await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(credential);

                            User? user = userCredential?.user;

                            debugPrint('..................... sign in | re-authenticate | uid ${user?.uid}');
                            debugPrint('..................... sign in | re-authenticate | displayName ${user?.displayName}');
                            debugPrint('..................... sign in | re-authenticate | photoURL ${user?.photoURL}');
                            debugPrint('..................... sign in | re-authenticate | email ${user?.email}');
                            debugPrint('..................... sign in | re-authenticate | emailVerified ${user?.emailVerified}');
                            debugPrint('..................... sign in | re-authenticate | phoneNumber ${user?.phoneNumber}');

                            error = '';
                            setState(() {});

                            if(context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Email User re-authenticated successfully'))
                            );
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              debugPrint('..................... sign in | re-authenticate ${e.code} : ${e.message}');
                            } else if (e.code == 'wrong-password') {
                              debugPrint('..................... sign in | re-authenticate ${e.code} : ${e.message}');
                            } else if (e.code == 'invalid-credentials') {
                              debugPrint('..................... sign in | re-authenticate ${e.code} : ${e.message}');
                            }

                            error = '${e.code} | ${e.message}';

                            setState(() {});
                          } catch(e) {
                            error = e.toString();
                            setState(() {});
                          }
                        },
                        child: Text('Re-authenticate Email User'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
