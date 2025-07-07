import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Provider/product_provider.dart';
import 'package:campus_mart/model/user_model.dart';
import 'package:campus_mart/Utils/categories.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/screens/home_screen/widgets/ImageWidget/image_widget.dart';
import 'package:campus_mart/screens/product_screen/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class CategoryAdGrid extends StatefulWidget {
  const CategoryAdGrid({Key? key, required this.category, required this.grid}) : super(key: key);

  final String category;
  final int grid;

  @override
  State<CategoryAdGrid> createState() => _CategoryAdGridState();
}

class _CategoryAdGridState extends State<CategoryAdGrid> {
  static const images = ['Camera.jpeg','detergent.jpeg','earbuds.jpeg','watch.jpeg'];

  @override
  void initState(){
    super.initState();
  }

  void _onRefresh() async{
    context.read<ProductProvider>().getProduct(
        removeSpecialCharactersAndSpaces(widget.category),
        widget.grid, context.read<AuthProvider>().accessToken, refreshControllerLoadComplete);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      flex: 1,
        child: SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            onRefresh: _onRefresh,
            onLoading: _onRefresh,
            controller: _refreshController,
            child: Consumer<ProductProvider>(
                builder: (_, bar, __) {

                  if(bar.categoryProductList.isEmpty && !bar.isGettingProduct){
                    return const Center(child: Text("No Ads Found"));
                  }

                  return !bar.isGettingProduct ? SingleChildScrollView(
                      child: StaggeredGrid.count(
                        crossAxisCount:2,
                        mainAxisSpacing: 10,
                        axisDirection: AxisDirection.down,
                        crossAxisSpacing: 10,
                        children: List.generate(bar.categoryProductList.toList().length, (index) {
                          UserModel user = UserModel.fromJson(bar.categoryProductList[index].user![0]);
                          return GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (_)=> ProductScreen(product: bar.categoryProductList[index])));
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
                                                child: bar.categoryProductList[index].images!.isEmpty ? Image(image: AssetImage("assets/images/${images[0]}"),
                                                  fit: BoxFit.cover,
                                                ):ImageWidget(url: bar.categoryProductList[index].images![0]['url'].toString())
                                              ))),

                                          Positioned(
                                            top: 0,
                                            child: Visibility(
                                              visible: bar.categoryProductList[index].adType != "Free",
                                              child: Container(
                                                  padding: const EdgeInsets.all(5),
                                                  decoration:  BoxDecoration(
                                                      color: bar.categoryProductList[index].adType == "Standard" ? Colors.orangeAccent
                                                          : Colors.green
                                                  ),
                                                  child: Text("${bar.categoryProductList[index].adType} Ad",
                                                    style: const TextStyle(color: Colors.white, fontSize: 10),
                                                  )
                                              ),
                                            ),
                                          ),

                                          Positioned(
                                              right: 0,
                                              child: IconButton(
                                                  onPressed: () {},
                                                  icon:  Icon(
                                                    bar.categoryProductList[index].wishList!.isEmpty ? Icons.favorite_border:
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
                                            child: Text("${bar.categoryProductList[index].title}",
                                              style: const TextStyle(color: Colors.black, fontSize: 13),
                                            ),
                                          ),
                                          Text("${bar.categoryProductList[index].adCategory}",
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

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void refreshControllerLoadComplete(){
    _refreshController.loadComplete();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }


}
