import 'package:campus_mart/Model/UserModel.dart';
import 'package:campus_mart/Provider/AuthProvider.dart';
import 'package:campus_mart/Provider/ProductProvider.dart';
import 'package:campus_mart/Screens/HomeScreen/Widgets/ImageWidget/ImageWidget.dart';
import 'package:campus_mart/Screens/ProductScreen/ProductScreen.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AdGrid extends StatefulWidget {
  const AdGrid({Key? key, required this.category, required this.grid}) : super(key: key);

  final String category;
  final int grid;

  @override
  State<AdGrid> createState() => _AdGridState();
}

class _AdGridState extends State<AdGrid> {

  static const images = ['Camera.jpeg','detergent.jpeg','earbuds.jpeg','watch.jpeg'];

  @override
  void initState(){
    super.initState();
      context.read<ProductProvider>().getProduct(widget.category, 1, context, false, context.read<AuthProvider>().accessToken);
  }

  void _onRefresh() async{
    context.read<ProductProvider>().getProduct(widget.category, 1, context, false, context.read<AuthProvider>().accessToken);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
        child: SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            onRefresh: _onRefresh,
            onLoading: _onRefresh,
            controller: widget.grid ==1 ? context.read<ProductProvider>().refreshController
            : context.read<ProductProvider>().refreshController2,
            child: Consumer<ProductProvider>(
              builder: (_, bar, __) {

                if(bar.productList.isEmpty && !bar.getIsGettingProduct){
                  return const Center(child: Text("No Ads Found"));
                }

                return !bar.getIsGettingProduct ? SingleChildScrollView(
                    child: StaggeredGrid.count(
                    crossAxisCount:2,
            mainAxisSpacing: 10,
            axisDirection: AxisDirection.down,
            crossAxisSpacing: 10,
            children: List.generate(bar.productList!.toList().length, (index) {

              UserModel user = UserModel.fromJson(bar.productList![index].user![0]);

              return GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=> ProductScreen(product: bar.productList![index])));
                },
                child: SizedBox(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Container(
                width: size.width * .5,
                height: index%2==0? size.width * .34 : size.width * .4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
                child: Stack(
                  children: [

                    Positioned(child: Opacity(
                        opacity: 0.78,
                        child: SizedBox(
                      width: size.width * .5,
                      height: index%2==0? size.width * .34 : size.width * .4,
                      child: bar.productList![index].images!.isEmpty ? Image(image: AssetImage("assets/images/${images[0]}"),
                      fit: BoxFit.cover,
                      ):ImageWidget(url: bar.productList![index].images![0]['url'].toString()),
                    ))),

                    Positioned(
                        right: 0,
                        child: IconButton(
                            onPressed: () {},
                            icon:  Icon(
                              bar.productList![index].wishList!.isEmpty ? Icons.favorite_border:
                              Icons.favorite,
                              color: Colors.white,
                            ))),
                  ],
                ),
              ),
              Container(
                width: size.width,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text("${bar.productList![index].title}",
                        style: const TextStyle(color: Colors.black, fontSize: 13),
                      ),
                    ),
                    Text("${bar.productList![index].adCategory}",
                        style: const TextStyle(color: primary, fontSize: 12)),

                    Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child:Text("${user.campus}",
                        style: const TextStyle(color: Colors.black, fontSize: 12)))
                  ],
                ),
              )
            ],
          ),
        ));
      }),
    )
        ): const Center(
                  child:  CircularProgressIndicator(),
                ) ; })
        ));
  }

}
