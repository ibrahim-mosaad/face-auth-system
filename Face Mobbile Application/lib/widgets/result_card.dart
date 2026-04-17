import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final Map face;

  const ResultCard({super.key, required this.face});

  Color getColor(double score) {
    if (score > 0.8) return Colors.green;
    if (score > 0.5) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    double score = face["score"];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: getColor(score)),
      ),
      child: ListTile(
        leading: Icon(Icons.face, color: getColor(score)),
        title: Text(
          face["name"],
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          "Confidence: ${(score * 100).toStringAsFixed(2)}%",
          style: TextStyle(color: getColor(score)),
        ),
      ),
    );
  }
}