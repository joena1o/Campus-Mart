import 'package:campus_mart/Model/NotificationModel.dart';
import 'package:campus_mart/Model/UserModel.dart';
import 'package:campus_mart/Provider/AuthProvider.dart';
import 'package:campus_mart/Provider/ProductProvider.dart';
import 'package:campus_mart/Provider/UserProvider.dart';
import 'package:campus_mart/Utils/timeAndDate.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    user = context.read<UserProvider>().userDetails;
    context.read<ProductProvider>().getNotifications(user?.id, context.read<AuthProvider>().accessToken);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<ProductProvider>(builder: (_, bar, __) {

      return !bar.getLoadingNotifications
          ? bar.notificationList.isNotEmpty ? Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.only(top: 5),
                  itemCount: bar.notificationList.length,
                  itemBuilder: (BuildContext ctx, int i) {

                    bar.notificationList.sort(compareTimestamps);
                    bar.notificationList = bar.notificationList.reversed.toList();

                    bool isNewDay = i == 0 || isSameDay(bar.notificationList[i - 1].createdAt!, bar.notificationList[i].createdAt!);

                    Widget dateHeader = isNewDay
                        ?  ListTile(
                      title: Text(
                        getDateDescription(bar.notificationList[i].createdAt!),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      dense: true,
                    ) : Container();



                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // dateHeader,

                        Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: CircleAvatar(
                                      radius: 20,
                                      child: Text(
                                        bar.notificationList[i].title.toString().substring(0,1).toUpperCase(),
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                    )),

                                10.width,

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:  [
                                      Text(
                                        bar.notificationList[i].title.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Wrap(
                                        children: [
                                          Text(
                                            "${bar.notificationList[i].description}.",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14),
                                          ),
                                          const SizedBox(width: 10,),
                                          Text(getTimeDifference(bar.notificationList[i].createdAt!),
                                            style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black45),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        bar.notificationList[i].notificationType.toString(),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black45),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Divider(),

                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                      ],
                    );
                  })):Expanded(
                    child: Center(child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.notifications_none, size: 40, color: Colors.black45,),
                        SizedBox(height: 20,),
                        Text("No Notifications", style: TextStyle(fontSize: 17),)
                      ],
                    )),
                )
          : const Center(
              child: CircularProgressIndicator(),
            );
    });
  }


  String getTimeDifference(DateTime timestamp) {
    Duration difference = DateTime.now().difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  int compareTimestamps(NotificationModel a, NotificationModel b) {
    // Compare timestamps based on years, months, days, hours, and minutes
    if (a.createdAt!.year != b.createdAt!.year) {
      return a.createdAt!.year.compareTo(b.createdAt!.year);
    } else if (a.createdAt!.month != b.createdAt!.month) {
      return a.createdAt!.month.compareTo(b.createdAt!.month);
    } else if (a.createdAt!.day != b.createdAt!.day) {
      return a.createdAt!.day.compareTo(b.createdAt!.day);
    } else if (a.createdAt!.hour != b.createdAt!.hour) {
      return a.createdAt!.hour.compareTo(b.createdAt!.hour);
    } else if (a.createdAt!.minute != b.createdAt!.minute) {
      return a.createdAt!.minute.compareTo(b.createdAt!.minute);
    } else {
      return 0; // Timestamps are equal
    }
  }

}
