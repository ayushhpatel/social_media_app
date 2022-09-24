import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/user_provider.dart';
import 'package:social_media_app/responsive/mobile_screen_layout.dart';
import 'package:social_media_app/responsive/web_screen_layout.dart';
import 'package:social_media_app/screens/login_screen.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'responsive/responsive_layout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}):super(key:key);

  @override
  Widget build(BuildContext context){
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>UserProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Social Media App',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home:StreamBuilder(
          stream:FirebaseAuth.instance.authStateChanges() ,
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.active){
              if(snapshot.hasData){
                return const ResponsiveLayout(
                  mobileScreenLayout:MobileScreenLayout(),
                  webScreenLayout:WebScreenLayout());
              }else if(snapshot.hasError){
                return Center(child: Text('${snapshot.error}'));
              }
            }
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(
                  color: primaryColor
                ),
              );
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
