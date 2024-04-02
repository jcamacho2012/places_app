import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonPlaces extends StatelessWidget {
  const SkeletonPlaces({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.grey,
                  width: double.infinity,
                  height: 10,
                ),
                const SizedBox(height: 10),
                Container(
                  color: Colors.grey,
                  width: double.infinity,
                  height: 10,
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.comment,
                      color: Colors.blue,
                      size: 15,
                    ),
                    const SizedBox(width: 4),
                    Container(
                      color: Colors.grey,
                      width: 10,
                      height: 10,
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.favorite, color: Colors.red, size: 15),
                    const SizedBox(width: 4),
                    Container(
                      color: Colors.grey,
                      width: 10,
                      height: 10,
                    ),
                  ],
                ),
              ],
            ),
            trailing: ClipRRect(
              borderRadius:
                  BorderRadius.circular(8.0), // Ajusta el radio del borde aquí
              child: Container(
                color: Colors.grey,
                width: 100,
                height: 100,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
