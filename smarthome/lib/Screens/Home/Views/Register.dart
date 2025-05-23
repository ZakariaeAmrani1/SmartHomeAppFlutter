import 'package:alert_info/alert_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smarthome/models/userModel.dart';

class Register extends StatefulWidget {
  const Register({super.key, required this.onUserRegister});
  final Function( Usermodel newuser) onUserRegister;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Usermodel newuser = Usermodel(username: "", email: "", phonenumber: "", gender: "male");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppBar(
              toolbarHeight: 10,
              backgroundColor: Colors.white,
            ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                    Row(
                    children: [
                          Text("Create account", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.onSurface),),
                    ],
                  ),
                  SizedBox(height: 30,),
                     Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width / 1.12,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          hintText: 'Username',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(16),
                        ],
                        onChanged: (value) {
                          setState(() {
                            newuser.username = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width / 1.12,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(16),
                        ],
                        onChanged: (value) {
                          setState(() {
                            newuser.email = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 1.12,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          hintText: 'Phone Number',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.phone_iphone,
                            color: Colors.grey,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onChanged: (value) {
                          setState(() {
                            newuser.phonenumber = value;
                          });
                        },
                      ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 1.12,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.man,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      newuser.gender = "male";
                                    });
                                  },
                                  style: newuser.gender == "male"
                                      ? ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context).colorScheme.primary,
                                          shadowColor: Colors.transparent,
                                        )
                                      : ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey[200],
                                          shadowColor: Colors.transparent,
                                        ),
                                  child: Text(
                                    "Male",
                                    style: TextStyle(
                                      color: newuser.gender == "male" ? Colors.white : Colors.grey.shade800,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      newuser.gender = "female";
                                    });
                                  },
                                  style: newuser.gender == "female"
                                      ? ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context).colorScheme.primary,
                                          shadowColor: Colors.transparent,
                                        )
                                      : ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey[200],
                                          shadowColor: Colors.transparent,
                                        ),
                                  child: Text(
                                    "Female",
                                    style: TextStyle(
                                      color: newuser.gender == "female" ? Colors.white : Colors.grey.shade800,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
              Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if(newuser.email == "" || newuser.username == "" || newuser.phonenumber == "" || newuser.gender == "")
                      {
                          AlertInfo.show(
                            context: context,
                            text: 'Please fill in all the fields first!',
                            typeInfo: TypeInfo.error,
                            backgroundColor: Colors.white,
                            textColor: Colors.grey.shade800,
                          );
                      }
                      else{
                        widget.onUserRegister(newuser);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Register", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),)
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}