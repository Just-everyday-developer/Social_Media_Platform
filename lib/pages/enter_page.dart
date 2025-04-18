import 'package:flutter/material.dart';
import 'package:social_media_platform/models/register_menu.dart';
import 'package:social_media_platform/utils/animations.dart';
import 'package:social_media_platform/data/bg_data.dart';
import 'package:social_media_platform/utils/text_utils.dart';
import 'package:social_media_platform/models/checkboxes.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int selected_index = 0;
  bool showOption = false;
  Widget checkbox = EmptyCheckbox();
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 49,
        width: double.infinity,

        child: Row(
          children: [
            Expanded(child: showOption ? ShowUpAnimation(
              delay: 100,
              child: SizedBox(
                height: 70,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: bgList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_index = index;
                        });
                      },
                      child: CircleAvatar(
                        radius: 30,

                        backgroundColor: selected_index == index ? Colors.white : Colors.transparent,
                        child: Padding(
                            padding: const EdgeInsets.all(1),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(bgList[index]),
                            ),
                        ),
                      ),
                    );
                  }),
              )) : const SizedBox()),
              const SizedBox(width: 20),
              showOption ? GestureDetector(
                onTap: () {
                  setState(() {
                    showOption = false;
                  });
                },
                child: const Icon(
                  Icons.close, color: Colors.white, size: 30
                )
      ) : GestureDetector(
              onTap: () {
                setState(() {
                  showOption = true;
                });
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(1),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(bgList[selected_index]),
                  ),
                ),
              ),
            )

          ],
        ),
      ),

      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration:  BoxDecoration(
          image: DecorationImage(
              image: AssetImage(bgList[selected_index]),fit: BoxFit.fill
          ),

        ),
        alignment: Alignment.center,
        child: Container(
          height: 400,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withOpacity(0.1),
          ),
          child: ClipRRect(

            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(filter: ImageFilter.blur(sigmaY: 5,sigmaX: 5),
                child:Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const   Spacer(),
                      Center(child: TextUtil(text: "Login",weight: true,size: 30,)),
                      const   Spacer(),
                      TextUtil(text: "Email"),
                      Container(
                        height: 35,
                        decoration:const  BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.white))
                        ),
                        child:TextFormField(
                          style: const TextStyle(color: Colors.white),
                          decoration:const InputDecoration(
                            suffixIcon: Icon(Icons.mail,color: Colors.white),
                            fillColor: Colors.white,
                            border: InputBorder.none),
                        ),
                      ),
                      const   Spacer(),
                      TextUtil(text: "Password"),
                      Container(
                        height: 35,
                        decoration:const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.white))
                        ),
                        child:TextFormField(
                          style: const TextStyle(color: Colors.white),
                          obscureText: _obscurePassword,
                          decoration:InputDecoration(
                            suffixIcon: IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                            }, icon: const Icon(Icons.lock),),
                            fillColor: Colors.white,
                            border: InputBorder.none,),
                        ),
                      ),
                      const   Spacer(),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                checkbox = checkbox is EmptyCheckbox
                                    ? FilledCheckbox()
                                    : EmptyCheckbox();
                              });
                            },
                            child: checkbox
                          ),
                          const  SizedBox(width: 10,),
                          Expanded(child: TextUtil(text: "Remember Me",size: 12,weight: true,)),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 200,
                                      color: Colors.blue,
                                    );
                                  },
                                );
                              },
                              child: TextUtil(
                                text: "FOLLOW PASSWORD",
                                color: Colors.blue,
                                style: TextStyle(decoration: TextDecoration.underline),
                                size: 12,
                                weight: true,
                              ),
                            ),
                          )
                        ],
                      ), const   Spacer(),
                      GestureDetector(
                        onTap: () {
                          context.go('/home');
                        },
                      child: Container(
                          height: 40,
                          width: double.infinity,
                          decoration:  BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30)
                          ),
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              context.go('/home');
                            },
                            child: TextUtil(text: "Log In", color: Colors.black)
                          )
                        )
            ),
                      const   Spacer(),

                      Center(
                          child: Row(
                              children: [
                                Expanded(
                                    child: TextUtil(
                                        text: "Don't have a account?",
                                        size: 12,
                                        weight: true
                                    )
                                ),
                                Expanded(
                                    child: Align(alignment: Alignment.centerRight, child:
                                    GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor: Colors.transparent,
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Container(
                                                    height: 500,
                                                    decoration: BoxDecoration(
                                                      border: Border(top: BorderSide(color: Colors.white)),
                                                      borderRadius: BorderRadius.circular(20),
                                                      color: Colors.black.withOpacity(0.1),

                                                    ),
                                                  child: RegisterMenu(),
                                                  );
                                                },
                                              );
                                            },
                                            child: TextUtil(
                                                text: "REGISTER",
                                                size: 12,
                                                weight: true,
                                                color: Colors.blue,
                                                style: TextStyle(
                                                    decoration: TextDecoration.underline
                                                )
                                            )
                                        )
                                )
                                )
                              ]
                          )
                      ),

                      const Spacer(),
                    ],
                  ),
                )
            ),
          ),
        ),


      ),



    );
  }
}