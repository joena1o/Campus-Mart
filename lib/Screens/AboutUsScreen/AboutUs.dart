import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}


class _AboutUsState extends State<AboutUs> {

  String fileContent = "";

  Future<void> loadFile() async {
    String content = await rootBundle.loadString('assets/about_us.txt');
    setState(() {
      fileContent = content;
    });
  }

  @override
  void initState(){
    super.initState();
    loadFile();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "About Us",
          style: TextStyle(fontSize: 15),
        ),
        elevation: 0,
      ),
      body: Container(
        width: size.width,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        height: size.height,
        child: SingleChildScrollView(child:Text(fileContent, style: const TextStyle(fontSize: 15),)),
      ),
    );
  }
}
