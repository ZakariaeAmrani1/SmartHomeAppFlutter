import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smarthome/models/userModel.dart';

class Settingscreen extends StatefulWidget {
  const Settingscreen({super.key, required this.user, required this.onUserUpdate});
  final Usermodel user;
  final Function( Usermodel newuser) onUserUpdate;
  @override
  State<Settingscreen> createState() => _SettingscreenState();
}

class _SettingscreenState extends State<Settingscreen> {
  late Usermodel newuser;
  @override
  void initState() {
    super.initState();
    newuser = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 10,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                  Row(
                    children: [
                         GestureDetector(
                          onTap: () => {
                            Navigator.pop(context)
                          },
                           child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                                child: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.tertiary, size: 20,),
                              ),
                            ],
                                             ),
                         ),
                         SizedBox(width: 30,),
                         Text("Profile Settings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),),
                    ],
                  ),
                   const SizedBox(
                  height: 30,
                ),
                 Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width / 1.12,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    initialValue: widget.user.username,
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
                    initialValue: widget.user.email,
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
                    initialValue: widget.user.phonenumber,
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
                    SizedBox(height: 20,),
                     Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width / 1.12,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        initialValue: widget.user.ipAddress,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          hintText: 'Ip Address',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            CupertinoIcons.location,
                            color: Colors.grey,
                          ),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(16),
                        ],
                        onChanged: (value) {
                          setState(() {
                            newuser.ipAddress = value;
                          });
                        },
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
                    widget.onUserUpdate(newuser);
                    Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Update", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}