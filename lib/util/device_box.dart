import "dart:math";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

class DeviceBox extends StatelessWidget {
  final String deviceName;
  final String iconPath;
  final bool powerOn;

  final Function(bool)? onChanged;

  const DeviceBox(
      {super.key,
      required this.deviceName,
      required this.iconPath,
      required this.powerOn,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
            color: powerOn ? Colors.grey[900] : Colors.grey[200],
            borderRadius: BorderRadius.circular(24)),
        height: 250,
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // icon
            Image.asset(
              iconPath,
              height: 65,
              color: powerOn ? Colors.white : Colors.black,
            ),

            // device name + switch
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    deviceName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: powerOn ? Colors.white : Colors.black),
                  ),
                )),
                Transform.rotate(
                    angle: pi / 2,
                    child:
                        CupertinoSwitch(value: powerOn, onChanged: onChanged))
              ],
            )
          ],
        ),
      ),
    );
  }
}
