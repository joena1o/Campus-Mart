import 'package:flutter/material.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
        child: ListView.builder(
            padding: const EdgeInsets.only(top: 5),
            itemCount: 10,
            itemBuilder: (BuildContext ctx, int i) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (i%3==0)?Container(
                   margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                   child: const Text("Today"),
                 ):Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                          padding:  EdgeInsets.only(right: 15),
                          child: CircleAvatar(
                            radius: 25,
                            child:  Text(
                              "H",
                              style: TextStyle(fontSize: 17),
                            ),
                          )),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "This is the recent notice This is the recent notice"+".  10mins",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 14),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Reviews",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black45),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Divider(),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      // const Padding(
                      //     padding: EdgeInsets.only(left: 15),
                      //     child: SizedBox(
                      //       child: Text(
                      //         "10:00",
                      //         style: TextStyle(fontSize: 12),
                      //       ),
                      //     ))
                    ],
                  )
                ],
              );
            }));
  }
}
