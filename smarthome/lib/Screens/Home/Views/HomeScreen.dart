import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/Screens/Home/Views/MainScreen.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar: AppBar(
              toolbarHeight: 10,
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
        bottomNavigationBar: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              child: BottomNavigationBar(
                onTap: (value) {
                  setState(() {
                    index = value;
                  });
                },
                backgroundColor: Theme.of(context).colorScheme.secondary,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                elevation: 3,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.home,
                      color: index == 0
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade400,
                    ),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.device_laptop,
                      color: index == 1
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade400,
                    ),
                    label: "Stats",
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              heroTag: "fab1",
              onPressed: () {
                  // Navigator.push(
                  // context,
                  // MaterialPageRoute<void>(
                  //   builder: (BuildContext context) =>
                  //       AddPlant(),
                  // ),
                  // );
              },
              shape: const CircleBorder(),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: const Icon(
                  CupertinoIcons.qrcode_viewfinder,
                ),
              ),
            ),
            body: index == 0
                ? Mainscreen()
                : Scaffold()
            //     : index == 1
            //     ? Scaffold():
            //     index == 2
            //     ? ChatScreen()
            //     :Scaffold(),
    );
  }
}