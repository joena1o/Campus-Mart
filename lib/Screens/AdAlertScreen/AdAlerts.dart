import 'package:campus_mart/Provider/AuthProvider.dart';
import 'package:campus_mart/Provider/ProductProvider.dart';
import 'package:campus_mart/Provider/UserProvider.dart';
import 'package:campus_mart/Screens/AdAlertScreen/AdAlert.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class AdAlerts extends StatefulWidget {
  const AdAlerts({Key? key}) : super(key: key);

  @override
  State<AdAlerts> createState() => _AdAlertsState();
}

class _AdAlertsState extends State<AdAlerts> {
  String? selectedId;

  @override
  void initState() {
    super.initState();
    context.read<ProductProvider>().getAdAlerts(
        context.read<UserProvider>().userDetails?.id,
        context.read<AuthProvider>().accessToken);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Buzz Me",
          style: TextStyle(fontSize: 15),
        ),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                infoBottomSheet(context);
              },
              icon: const Icon(Icons.info_outline)),
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const AdAlert()));
              },
              icon: const Icon(Icons.add)),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        width: size.width,
        height: size.height,
        child: Consumer<ProductProvider>(builder: (_, bar, __) {
          return ListView.builder(
              itemCount: bar.adAlertList.length,
              itemBuilder: (BuildContext ctx, i) {
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  title: Text(
                    bar.adAlertList[i].item.toString(),
                    style: const TextStyle(fontSize: 15),
                  ),
                  subtitle: Text(bar.adAlertList[i].category.toString()),
                  trailing: IconButton(
                      onPressed: () {
                        setState(() => selectedId = bar.adAlertList[i].id);
                        customBottomSheet(context);
                      },
                      icon: const Icon(Icons.more_horiz)),
                );
              });
        }),
      ),
    );
  }

  void customBottomSheet(BuildContext context) {
    final userDetails = context.read<UserProvider>().userDetails;
    Size size = MediaQuery.of(context).size;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return Container(
          height: size.height * .20,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: radiusCircular(20), topRight: radiusCircular(20)),
            color: Colors.white, // Customize the background color
          ), // Set the desired height of the bottom sheet

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.edit,
                    color: Colors.grey,
                    size: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Edit",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    context.read<ProductProvider>().deleteAdAlert(
                        selectedId,
                        context,
                        context.read<UserProvider>().userDetails?.id,
                        context.read<AuthProvider>().accessToken);
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 30,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Delete", style: TextStyle(fontSize: 16))
                    ],
                  )),
            ],
          ),
        );
      },
    );
  }

  void infoBottomSheet(BuildContext context) {
    final userDetails = context.read<UserProvider>().userDetails;
    Size size = MediaQuery.of(context).size;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return Container(
          height: size.height * .3,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: radiusCircular(20), topRight: radiusCircular(20)),
            color: Colors.white, // Customize the background color
          ), // Set the desired height of the bottom sheet

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Buzz Me",
                style: TextStyle(fontSize: 23, color: primary),
              ),
              15.height,
              const Text(
                'Stay informed about the products you care about. "Buzz Me" sends you quick, attention-grabbing alerts when a product is back in stock, on sale, or its status changes, so you never miss an update.',
                style: TextStyle(height: 1.5),
              )
            ],
          ),
        );
      },
    );
  }
}
