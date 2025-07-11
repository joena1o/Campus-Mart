import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Provider/product_provider.dart';
import 'package:campus_mart/Provider/user_provider.dart';
import 'package:campus_mart/model/user_model.dart';
import 'package:flutter/material.dart';
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
    context
        .read<ProductProvider>()
        .getNotifications(user?.id, context.read<AuthProvider>().accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (_, bar, __) {
      return !bar.isLoadingNotifications
          ? bar.notificationList.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(top: 5),
                      itemCount: bar.notificationList.length,
                      itemBuilder: (BuildContext ctx, int i) {
                        // bool isNewDay = i == 0 || isSameDay(bar.notificationList[i - 1].createdAt!, bar.notificationList[i].createdAt!);

                        // Widget dateHeader = isNewDay
                        //     ?  ListTile(
                        //   title: Text(
                        //     getDateDescription(bar.notificationList[i].createdAt!),
                        //     style: const TextStyle(fontWeight: FontWeight.bold),
                        //   ),
                        //   dense: true,
                        // ) : Container();

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // dateHeader,

                              Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: CircleAvatar(
                                            radius: 20,
                                            child: Text(
                                              bar.notificationList[i].title
                                                  .toString()
                                                  .substring(0, 1)
                                                  .toUpperCase(),
                                              style:
                                                  const TextStyle(fontSize: 17),
                                            ),
                                          )),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              bar.notificationList[i].title
                                                  .toString(),
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
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 14),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  getTimeDifference(bar
                                                      .notificationList[i]
                                                      .createdAt!),
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
                                              bar.notificationList[i]
                                                  .notificationType
                                                  .toString(),
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
                          ),
                        );
                      }))
              : const Expanded(
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 40,
                        color: Colors.black45,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "No Notifications",
                        style: TextStyle(fontSize: 17),
                      )
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
}
