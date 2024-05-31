import 'package:chat_app_assignment/screens/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_assignment/resources/auth_methods.dart';
import 'package:chat_app_assignment/responsive/mobile_screen_layout.dart';
import 'package:chat_app_assignment/responsive/responsive_layout.dart';
import 'package:chat_app_assignment/utils/colors.dart';
import 'package:chat_app_assignment/utils/utils.dart';
import 'package:chat_app_assignment/widgets/text_field_input.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        file: _image!,
        bio: _bioController.text,
    );
    
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
            ),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        showSnackBar(context, res);
      }
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  Future<String> validateForm() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String username = _usernameController.text;
    String res  = 'Some error Occurred';
    if (_image != null) {
      if(email.isNotEmpty){
        if(username.isNotEmpty){
          if(password.isNotEmpty){
            signUpUser();
          }else{
            showSnackBar(context, 'Enter password');
          }
        }else{
          showSnackBar(context, 'Enter username');
        }
      }else{
        showSnackBar(context, 'Enter email');
      }
    }
    else{
      if(mounted) {
        // ignore: use_build_context_synchronously
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Upload Profile Photo', style: appbarFont,),
            backgroundColor: mobileBackgroundColor,
            actions: [
              TextButton(onPressed: () {
                Navigator.pop(context);
              },
                  child: const Text('OK',
                    style: TextStyle(color: greenColor, fontSize: 12),)),
            ],
          );
        });
      }
    }
    return res;
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100,),
                const Text('STEMM Chat', style: TextStyle(fontSize: 44),),
                const SizedBox(
                  height: 64,
                ),
                Stack(
                  children: [
                    _image != null
                        ? GestureDetector(
                      onTap: selectImage,
                      child: CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                        backgroundColor: Colors.grey,
                      ),
                    )
                        : GestureDetector(
                      onTap: selectImage,
                      child: const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage('https://icons-for-free.com/iff/png/256/person-1324760545186718018.png'),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage, //selectImage,
                        icon: const Icon(Icons.add_a_photo, color: primaryColor,),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  hintText: 'Enter your username',
                  textInputType: TextInputType.text,
                  textEditingController: _usernameController,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  hintText: 'Enter your bio',
                  textInputType: TextInputType.text,
                  textEditingController: _bioController,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  hintText: 'Enter your password',
                  textInputType: TextInputType.text,
                  textEditingController: _passwordController,
                  isPass: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: validateForm,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: greenColor,
                    ),
                    child: !_isLoading
                        ? const Text(
                            'Sign up',
                          )
                        : const CircularProgressIndicator(
                            color: primaryColor,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Already have an account?',
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          ' Login.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
