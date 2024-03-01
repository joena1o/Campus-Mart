import 'package:campus_mart/Screens/FeedbackScreen/FeedBackPage/Widget/Bug.dart';
import 'package:campus_mart/Screens/FeedbackScreen/FeedBackPage/Widget/FeedbackCard.dart';
import 'package:campus_mart/Screens/FeedbackScreen/FeedBackPage/Widget/Report.dart';
import 'package:campus_mart/Screens/FeedbackScreen/FeedBackPage/Widget/Suggest.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute ;
import 'package:nb_utils/nb_utils.dart';


class FeedbackView extends StatefulWidget {
  const FeedbackView({Key? key, required this.type}) : super(key: key);

  final String type;

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
        value: 0,
        lowerBound: 0,
        upperBound: 1);
    _animation =
        CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn);

    _controller!.forward();
  }

  int step = 2;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SizedBox(
            width: size.width,
            height: size.height,
            child: FadeTransition(
              opacity: _animation!,
              child: ListView(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Container(height: 30,),

                    step == 1
                        ? Report(feedBackType: widget.type)
                        : GestureDetector(
                            onTap: () {
                              setState(() => step = 1);
                            },
                            child: const FeedbackCard(
                                title: "Report an issue with the transaction")),
                    20.height,
                    step == 2
                        ? Suggest(feedBackType: widget.type)
                        : GestureDetector(
                            onTap: () {
                              setState(() => step = 2);
                            },
                            child:
                                const FeedbackCard(title: "Suggest a new feature")),
                    20.height,
                    step == 3
                        ? Bug(feedBackType: widget.type)
                        : GestureDetector(
                            onTap: () {
                              setState(() => step = 3);
                            },
                            child: const FeedbackCard(title: "Report Bug"))
                  ],
                ),
              ]),
            )));
  }
}
