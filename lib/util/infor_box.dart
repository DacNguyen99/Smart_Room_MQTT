import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class InforBox extends StatelessWidget {
  final String inforName;
  final String iconPath;
  final String inforValue;
  final double percent;

  const InforBox(
      {super.key,
      required this.inforName,
      required this.iconPath,
      required this.inforValue,
      required this.percent});

  MaterialColor modifyProgressColor(inforName, inforValue) {
    if (inforName == "Temperature") {
      return (double.parse(inforValue.split(" ")[0]) < 20 ||
              double.parse(inforValue.split(" ")[0]) > 40)
          ? Colors.red
          : Colors.indigo;
    } else if (inforName == "Humidity") {
      return (double.parse(inforValue.split(" ")[0]) < 30 ||
              double.parse(inforValue.split(" ")[0]) > 80)
          ? Colors.red
          : Colors.indigo;
    }
    return Colors.indigo;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(24)),
        height: 250,
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // icon
            Image.asset(
              iconPath,
              height: 60,
              color: Colors.black,
            ),

            // infor + name
            Expanded(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  CircularPercentIndicator(
                    radius: 45,
                    lineWidth: 4,
                    percent: percent,
                    progressColor: modifyProgressColor(inforName, inforValue),
                    center: Text(
                      inforValue,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Text(
              inforName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
