import 'dart:async';

import 'package:flutter/material.dart';

class SetTime extends StatefulWidget {
  const SetTime({Key? key}) : super(key: key);

  @override
  State<SetTime> createState() => _SetTimeState();
}

class _SetTimeState extends State<SetTime> {
  late Timer timer;
  int time = 0;
  bool running = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer timer) {
        if (time == 10) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            time++;
          });
        }
      },
    );
  }

  //void startTimer() {
    // timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
    //   setState(() {
    //     timeRunning = true;
    //     print("finish time");
    //   });
    // });
    // timer.cancel();

    // timer = Timer(const Duration(seconds: 1), () {
    //   setState(() {
    //     timeRunning = true;
    //     print("finish time");
    //   });
    // });
    // timer.cancel();

    // timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
    //   if (time == 20) {
    //     setState(() {
    //       timeRunning = false;
    //       print(timeRunning);
    //       timer.cancel();
    //     });
    //   } else {
    //     setState(() {
    //       timeRunning = true;
    //       time++;
    //       print(time);
    //     });
    //   }
    // });
  //}


  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                startTimer();
              },
              child: const Text("start"),
            ),
            Text("$time")
          ],
        ),
      ),
    );
  }




}