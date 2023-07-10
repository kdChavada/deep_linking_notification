import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Generate Dynamic link"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                String url = await createLink(1);
                Share.share(url);
              },
              child: const Text("Generate dynamic Link"),
            ),
          ),
        ],
      ),
    );
  }
}
