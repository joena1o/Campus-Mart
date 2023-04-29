import 'package:campus_mart/Model/ProductModel.dart';
import 'package:campus_mart/Model/WishProductModel.dart';
import 'package:campus_mart/Provider/ProductProvider.dart';
import 'package:campus_mart/Provider/UserProvider.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class WishListAdGrid extends StatefulWidget {
  const WishListAdGrid({Key? key}) : super(key: key);

  @override
  State<WishListAdGrid> createState() => _WishListAdGridState();
}

class _WishListAdGridState extends State<WishListAdGrid> {

  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  static const images = ['Camera.jpeg'];
  bool isLoading = true;
  List<ProductModel> products = [];

  void _onRefresh() async{
    //getProducts();
    print("is working");
  }

  @override
  void initState(){
    super.initState();
    final user = context.read<UserProvider>().userDetails;
    context.read<ProductProvider>().getWishList(user!.username);
  }

  @override
  Widget build(BuildContext context) {
    print(products.length);
    Size size = MediaQuery.of(context).size;
    return Expanded(
        child:  Consumer<ProductProvider>(builder: (_, data, __) {
          return !data.isLoadingWishList ? SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            onRefresh: _onRefresh,
            onLoading: _onRefresh,
            controller: _refreshController,
            child: SingleChildScrollView(
                child:  StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  axisDirection: AxisDirection.down,
                  crossAxisSpacing: 10,
                  children: List.generate(data.wishProductModel!.toList().length, (index) {
                    final products = data.wishProductModel as List<WishProductModel>;
                    return GestureDetector(
                        onTap: (){
                         // Navigator.of(context).push(MaterialPageRoute(builder: (_)=> ProductScreen(product: ProductModel.fromJson(products![index].product![0].toJson()))));
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
                                          child: Image(image: AssetImage("assets/images/${images[0]}"),
                                            fit: BoxFit.cover,
                                          ),
                                        ))),

                                    Positioned(
                                        right: 0,
                                        child: IconButton(
                                            onPressed: () {},
                                            icon:  const Icon(
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
                                      child: Text("${products![index].product![0].title}",
                                        style: const TextStyle(color: Colors.black, fontSize: 13),
                                      ),
                                    ),
                                    Text("${products![index].product![0].adCategory}",
                                        style: const TextStyle(color: primary, fontSize: 12)),

                                    Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 7),
                                        child:Text("${products![index].user![0].campus}",
                                            style: const TextStyle(color: Colors.black, fontSize: 12))

                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ));
                  }),
            ))): const Center(
          child: CircularProgressIndicator(),
        ); }));
  }
}
