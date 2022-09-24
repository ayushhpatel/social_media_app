import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/resources/auth_methods.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/utils.dart';
import 'package:social_media_app/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  final TextEditingController _bioController=TextEditingController();
  final TextEditingController _usernameController=TextEditingController();
  Uint8List? _image;
  bool _isLoading=false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }
  void selectImage() async{
    Uint8List im=await pickImage(ImageSource.gallery);
    setState(() {
      _image=im;
    });
  }

  void signUpUser() async{
     setState(() {
       _isLoading=true;
     });
     String res=await AuthMethods().signUpUser(email: _emailController.text,
     password: _passwordController.text,
     username: _usernameController.text,
     bio: _bioController.text,
     file: _image!);
     setState(() {
       _isLoading=false;
     });
     if(res !='success'){
       showSnackBar(res,context);
     }else{
       Navigator.of(context).push(MaterialPageRoute(builder:(context)=>const SignupScreen()));
     }
  }

  void navigateToLogin(){
    Navigator.of(context).push(MaterialPageRoute(builder:(context)=>const ResponsiveLayout(
        mobileScreenLayout:MobileScreenLayout(),
        webScreenLayout:WebScreenLayout())));
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(),flex: 2),
              // svg image
              SvgPicture.asset('assets/ic_instagram.svg',color: primaryColor,height: 64,),
              const SizedBox(height: 64),
              //circular widget for file
              Stack(
                children: [
                  _image!=null?CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                  )
                  : const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage('https://thumbs.dreamstime.com/b/default-profile-picture-avatar-photo-placeholder-vector-illustration-default-profile-picture-avatar-photo-placeholder-vector-189495158.jpg'),
                  ),
                  Positioned(
                    bottom:-10,
                    left:80,
                    child: IconButton(onPressed: selectImage, icon: const Icon(Icons.add_a_photo),),)
                ],
              ),
              const SizedBox(height: 24),
              //text field input for user name
              TextFieldInput(
                hintText: 'Enter your username',
                textInputType: TextInputType.text,
                textEditingController:_usernameController
              ),
              const SizedBox(height: 24),
              // text field input for email
              TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController:_emailController ,
              ),
              const SizedBox(height: 24),
              // text field input for password
              TextFieldInput(
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                textEditingController:_passwordController ,
                isPass: true,
              ),
              const SizedBox(height: 24),
              // text field for bio
              TextFieldInput(
                  hintText: 'Enter your bio',
                  textInputType: TextInputType.text,
                  textEditingController:_bioController
              ),
              const SizedBox(height: 24),
              // button login
              InkWell(
                onTap: signUpUser,
                child: Container(
                  child: _isLoading? const Center(child: CircularProgressIndicator(
                    color: primaryColor
                  )) :const Text('Sign Up'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                      color: blueColor
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(child: Container(),flex: 2),
              // to sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text("Don't have an account?"),
                      padding: const EdgeInsets.symmetric(
                         vertical: 8,
                      ),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      child: const Text("Sign up",style: TextStyle(fontWeight: FontWeight.bold)),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                    ),
                  )
                ],
          ),
         ]
        ),
      ),
    )
    );
  }
}