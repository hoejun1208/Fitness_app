import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health/config/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health/screens/health_main.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);

  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final _authentication = FirebaseAuth.instance;
  bool isSignupScreen = false;
  final _formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  void _tryvalidation(){
    final isvalid = _formkey.currentState!.validate();
    if(isvalid){
      _formkey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
        child: Column(
          children: [
            Positioned(
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('image/fitness.png'),
                      fit: BoxFit.fill
                  ),
                ),
              ),),
            //배경 화면
            SizedBox(
              height: 15,
            ),
            Positioned(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          GestureDetector(
                            onTap: (){
                              setState(() {
                                isSignupScreen = false;
                              });
                            },

                            child: Column(
                              children: [
                                Text(
                                  'Log in',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color:!isSignupScreen ? Palette.activeColor : Palette.textColor1
                                  ),
                                ),
                                if(!isSignupScreen)
                                  Container(
                                    margin: EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: Colors.grey[700],
                                  )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                isSignupScreen = true;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  'Sign up',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color:isSignupScreen ? Palette.activeColor : Palette.textColor1
                                  ),
                                ),
                                if(isSignupScreen)
                                  Container(
                                    margin: EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: Colors.grey[700],
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          if(isSignupScreen)
                            Container(
                              padding: EdgeInsets.all(40.0),
                              child: Form(
                                key: _formkey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      key: ValueKey(1),
                                      validator: (value){
                                        if (value!.isEmpty) {
                                          return '이메일 형식으로 입력해 주세요';
                                        } else if (!RegExp(
                                            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                            .hasMatch(value)) {
                                          return '이메일 형식으로 입력해 주세요';
                                        }
                                        return null;
                                      },
                                      onSaved: (value){
                                        email = value!;
                                      },
                                      onChanged: (value){
                                        email = value;
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.email,
                                            color: Palette.iconColor,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Palette.textColor1
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(35.0),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Palette.textColor1
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(35.0),
                                            ),
                                          ),
                                          hintText: 'Email',
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Palette.textColor1
                                          ),
                                          contentPadding: EdgeInsets.all(10)
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      obscureText: true,
                                      key: ValueKey(2),
                                      validator: (value){
                                        if(value!.isEmpty || value.length<6){
                                          return '비밀번호를 6글자 이상 입력해주세요';
                                        }
                                        return null;
                                      },
                                      onSaved: (value){
                                        password = value!;
                                      },
                                      onChanged: (value){
                                        password = value;
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color: Palette.iconColor,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Palette.textColor1
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(35.0),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Palette.textColor1
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(35.0),
                                            ),
                                          ),
                                          hintText: 'Password',
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Palette.textColor1
                                          ),
                                          contentPadding: EdgeInsets.all(10)
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if(!isSignupScreen)
                            Container(
                              padding: EdgeInsets.all(40.0),
                              child: Form(
                                key: _formkey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      key: ValueKey(3),
                                      validator: (value){
                                        if (value!.isEmpty) {
                                          return '이메일 형식으로 입력해 주세요';
                                        } else if (!RegExp(
                                            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                            .hasMatch(value)) {
                                          return '이메일 형식으로 입력해 주세요';
                                        }
                                        return null;
                                      },
                                      onSaved: (value){
                                        email = value!;
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.email,
                                            color: Palette.iconColor,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Palette.textColor1
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(35.0),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Palette.textColor1
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(35.0),
                                            ),
                                          ),
                                          hintText: 'Email',
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Palette.textColor1
                                          ),
                                          contentPadding: EdgeInsets.all(10)
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    TextFormField(
                                      obscureText: true,
                                      key: ValueKey(4),
                                      validator: (value){
                                        if(value!.isEmpty || value.length<6){
                                          return '비밀번호를 6글자 이상 입력해주세요';
                                        }
                                        return null;
                                      },
                                      onSaved: (value){
                                        password = value!;
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color: Palette.iconColor,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Palette.textColor1
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(35.0),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Palette.textColor1
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(35.0),
                                            ),
                                          ),
                                          hintText: 'Password',
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Palette.textColor1
                                          ),
                                          contentPadding: EdgeInsets.all(10)
                                      ),
                                    ),
                                    //텍스트 화면

                                  ],
                                ),
                              ),
                            ),
                          Container(
                              padding: EdgeInsets.all(20.0),
                              child: Center(
                                child: GestureDetector(
                                  onTap: ()async{
                                    if(isSignupScreen){
                                      _tryvalidation();
                                      try {
                                        final newuser = await _authentication
                                            .createUserWithEmailAndPassword(
                                          email: email,
                                          password: password,
                                        );
                                        if(newuser.user != null){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) {
                                              return HealthScreen();
                                            }),
                                          );
                                        }
                                      }catch(e){
                                        print(e);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('가입정보를 확인하세요'),
                                            backgroundColor: Colors.blue,
                                          ),
                                        );
                                      }
                                    }
                                    if(!isSignupScreen) {
                                      _tryvalidation();
                                      try {
                                        final newuser = await _authentication
                                            .signInWithEmailAndPassword(
                                          email: email,
                                          password: password,
                                        );
                                        if (newuser.user != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) {
                                              return HealthScreen();
                                            }),
                                          );
                                        }
                                      }catch(e){
                                        print(e);
                                      }
                                    }
                                  },

                                  child: Container(
                                    padding: EdgeInsets.all(15.0),
                                    decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(50)
                                    ),
                                    child: Center(
                                      child: Text(
                                        
                                        isSignupScreen ? '회원가입' : '로그인',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),

                                      ),
                                    ),
                                  ),
                                ),

                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),

          ],
        ),
      ),
    ));
  }
}



