import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Provider/product_provider.dart';
import 'package:campus_mart/model/user_model.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/screens/home_screen/widgets/ImageWidget/image_widget.dart';
import 'package:campus_mart/screens/product_screen/product_screen.dart';
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

  final RefreshController _refreshController = RefreshController(initialRefresh: false);


  @override
  void initState(){
    super.initState();
      context.read<ProductProvider>().getProduct(widget.category, 1, context.read<AuthProvider>().accessToken, refreshControllerLoadComplete);
  }

  void _onRefresh() async{
    context.read<ProductProvider>().getProduct(widget.category, 1, context.read<AuthProvider>().accessToken, refreshControllerLoadComplete);
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
            controller: _refreshController,
            child: Consumer<ProductProvider>(
              builder: (_, bar, __) {
                if(bar.productList.isEmpty && !bar.isGettingProduct){
                  return const Center(child: Text("No Ads Found"));
                }

                return !bar.isGettingProduct ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: StaggeredGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      axisDirection: AxisDirection.down,
                      crossAxisSpacing: 10,
                      children: List.generate(bar.productList.toList().length, (index) {

                      UserModel user = UserModel.fromJson(bar.productList[index].user![0]);

              return GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=> ProductScreen(product: bar.productList[index])));
                },
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
                            child: bar.productList[index].images!.isEmpty ? Image(image: AssetImage("assets/images/${images[0]}"),
                            fit: BoxFit.cover,
                            ):ImageWidget(url: bar.productList[index].images![0]['url'].toString()),
                          ))),

                          Positioned(
                              right: 0,
                              child: IconButton(
                                  onPressed: () {},
                                  icon:  Icon(
                                    bar.productList[index].wishList!.isEmpty ? Icons.favorite_border:
                                    Icons.favorite,
                                    color: Colors.white,
                                  ))),


                          Positioned(
                            top: 0,
                            child: Visibility(
                              visible: bar.productList[index].adType != "Free",
                              child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration:  BoxDecoration(
                                      color: bar.productList[index].adType == "Standard" ? Colors.orangeAccent
                                          : Colors.green
                                  ),
                                  child: Text("${bar.productList[index].adType} Ad",
                                  style: const TextStyle(color: Colors.white, fontSize: 10),
                                  )
                              ),
                            ),
                          ),

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
                            child: Text("${bar.productList[index].title}",
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          Text("${bar.productList[index].adCategory}",
                              style: const TextStyle(color: primary, fontSize: 12)),

                          Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child:Text("${user.campus}",
                              style: const TextStyle(fontSize: 12)))
                        ],
                    ),
                  ),


                              ],
                            ));
      }),
    ),
                    )
        ): const Center(
                  child:  CircularProgressIndicator(),
                ) ; })
        ));
  }

  void refreshControllerLoadComplete(){
    _refreshController.loadComplete();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

}
