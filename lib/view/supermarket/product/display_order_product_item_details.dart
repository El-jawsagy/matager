import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:matager/controller/cart/cart_bloc_off.dart';
import 'package:matager/controller/store/home_api.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/homepage.dart';
import 'package:matager/view/user/cart/cart_online.dart';
import 'package:matager/view/utilities/multi_screen.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'package:matager/view/utilities/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplayOrderItemDetails extends StatefulWidget {
  String productId;
  int storeId;
  String storeName;
  String status;

  double latitude, longitude;

  DisplayOrderItemDetails(
    this.productId,
    this.storeId,
    this.status,
    this.storeName,
    this.latitude,
    this.longitude,
  );

  @override
  _DisplayOrderItemDetailsState createState() =>
      _DisplayOrderItemDetailsState();
}

final GlobalKey<ScaffoldState> _orderProductScaffoldKey =
    new GlobalKey<ScaffoldState>();

class _DisplayOrderItemDetailsState extends State<DisplayOrderItemDetails> {
  double pos;
  ValueNotifier<double> posOfProducts;
  MarketAndCategoryApi marketAndCategoryApi = MarketAndCategoryApi();

  @override
  void initState() {
    posOfProducts = ValueNotifier(1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DetectedScreen detectedScreen = DetectedScreen(context);
    ProductSize productSize = ProductSize(detectedScreen);
    return Scaffold(
      key: _orderProductScaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.storeName,
          style: TextStyle(
            color: CustomColors.whiteBG,
            fontSize: productSize.headerTextSize,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: <Widget>[
          ValueListenableBuilder(
            valueListenable: countOfProducts,
            builder: (BuildContext context, int value, Widget child) {
              return Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: CustomColors.red, shape: BoxShape.circle),
                        child: Text(countOfProducts.value.toString()),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartOnLineScreen(
                                  widget.latitude, widget.longitude)));
                    },
                    icon: Icon(
                      Icons.shopping_cart,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: marketAndCategoryApi.getSingleProduct(widget.productId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return emptyPage(context);
                break;
              case ConnectionState.waiting:

              case ConnectionState.active:
                return loading(context, 0.2);
                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  return BuildScaffold(snapshot.data, widget.productId,
                      widget.storeId, widget.status);
                } else
                  return emptyPage(context);
                break;
            }
            return emptyPage(context);
          }),
    );
  }
}

class BuildScaffold extends StatefulWidget {
  Map map;
  String productId;
  int storeId;
  String status;

  @override
  _BuildScaffoldState createState() => _BuildScaffoldState();

  BuildScaffold(
    this.map,
    this.productId,
    this.storeId,
    this.status,
  );
}

class _BuildScaffoldState extends State<BuildScaffold> {
  PageController _controller;
  TextEditingController _counterController;
  double pos;
  ValueNotifier<double> posOfProducts;

  @override
  Widget build(BuildContext context) {
    DetectedScreen detectedScreen = DetectedScreen(context);
    ProductSize productSize = ProductSize(detectedScreen);
    var data = widget.map;
    print(data);
    pos = 0;
    data["unit"] == "0"
        ? posOfProducts = ValueNotifier(1)
        : posOfProducts = ValueNotifier(0.25);
    _counterController = TextEditingController();
    _counterController.text = posOfProducts.value.toString();
    _controller = PageController(
      initialPage: pos.floor(),
    );
    return ListView(
      children: <Widget>[
        _drawItemImage(data['images']),
        Align(
          alignment: Alignment.bottomCenter,
          child: DotsIndicator(
            dotsCount: data['images'].length,
            position: pos,
            decorator: DotsDecorator(
              color: Colors.grey,
              activeColor: CustomColors.primary,
              size: Size.square(productSize.dotsSize),
              activeSize:
                  Size(productSize.dotsSize * 2.0, productSize.dotsSize),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Text(
            AppLocale.of(context).getTranslated("lang") == 'English'
                ? data["name_ar"]
                : data["name_en"],
            style: TextStyle(
              color: CustomColors.primary,
              fontSize: productSize.nameSize,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.visible,
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 22, right: 22, top: 10, bottom: 10),
          child: Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          ),
        ),
        _drawItemDescription(data, productSize.nameSize),
        _drawPrice(data, productSize.nameSize),
        _drawCounterRow(
          data,
          posOfProducts.value,
          productSize.nameSize,
          productSize.iconSize,
        ),
        widget.status == "غير متاح"
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: _drawStoreClose(
                  productSize.nameSize,
                  productSize.iconSize,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: _drawAddToCartButton(
                  data,
                  widget.storeId,
                  posOfProducts,
                  productSize.nameSize,
                  productSize.iconSize,
                ),
              ),
      ],
    );
  }

  Widget _drawItemImage(List imagePath) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .3,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (val) {
              setState(() {
                pos = val.floorToDouble();
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.only(top: 8, left: 4, right: 4),
                child: (imagePath[index] == null)
                    ? Image.asset(
                        "assets/images/boxImage.png",
                      )
                    : Image(
                        loadingBuilder:
                            (context, image, ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) {
                            return image;
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        image: NetworkImage(
                          imagePath[index],
                        ),
                        fit: BoxFit.contain,
                      ),
              );
            },
            itemCount: imagePath.length,
          ),
        ),
      ],
    );
  }

  Widget _drawPrice(data, size) {
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 24, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocale.of(context).getTranslated("price"),
            style: TextStyle(
                color: CustomColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: size),
          ),
          SizedBox(
            width: 5,
          ),
          Text.rich(
            data['offer']
                ? TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            " ${data["oldprice"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                        style: new TextStyle(
                            color: CustomColors.red,
                            decoration: TextDecoration.lineThrough,
                            fontSize: size),
                      ),
                      TextSpan(
                        text: " ",
                      ),
                      new TextSpan(
                        text:
                            " ${data["price"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                        style: new TextStyle(
                            color: CustomColors.primary, fontSize: size),
                      ),
                    ],
                  )
                : TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            " ${data["price"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                        style: new TextStyle(
                            color: CustomColors.red, fontSize: size),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _drawItemDescription(data, size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 10),
          width: MediaQuery.of(context).size.width,
          child: Html(
            data: AppLocale.of(context).getTranslated("lang") == 'English'
                ? (data["content_ar"] == null ? "" : data["content_ar"])
                : (data["content_en"] == null ? "" : data["content_en"]),
            //Optional parameters:
            style: {
              "div": Style(
                  fontSize: FontSize(size),
                  textDecorationStyle: TextDecorationStyle.double,
                  fontWeight: FontWeight.w600),
              "p": Style(
                  fontSize: FontSize(size),
                  textDecorationStyle: TextDecorationStyle.double,
                  fontWeight: FontWeight.w600),
            },
          ),
        ),
      ],
    );
  }

  Widget _drawCounterRow(data, double count, nameSize, iconSize) {
    return ValueListenableBuilder(
      valueListenable: posOfProducts,
      builder: (BuildContext context, double value, Widget child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                  highlightColor: Colors.red,
                  iconSize: iconSize,
                  icon: Icon(Icons.add),
                  onPressed: () {
                    posOfProducts.value = (data["unit"] == "0"
                        ? (posOfProducts.value + 1)
                        : (posOfProducts.value + .25));

                    _counterController.text = posOfProducts.value.toString();
                  }),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                width: MediaQuery.of(context).size.width * 0.5,
                child: EditableText(
                  controller: _counterController,
                  backgroundCursorColor: Colors.black,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: nameSize,
                      fontWeight: FontWeight.bold),
                  cursorColor: Colors.black,
                  textAlign: TextAlign.center,
                  focusNode: FocusNode(),
                  onChanged: (val) {
                    posOfProducts.value = double.parse(val);
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                ),
              ),
              posOfProducts.value > 0
                  ? IconButton(
                      highlightColor: Colors.red,
                      iconSize: iconSize,
                      icon: Icon(Icons.remove, color: CustomColors.dark),
                      onPressed: () {
                        if (posOfProducts.value > 0) {
                          posOfProducts.value = (data["unit"] == "0"
                              ? (posOfProducts.value - 1)
                              : (posOfProducts.value - .25));

                          _counterController.text =
                              posOfProducts.value.toString();
                        }
                      })
                  : Icon(
                      Icons.remove,
                      color: CustomColors.darkOne,
                      size: iconSize,
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _drawAddToCartButton(
    data,
    storeId,
    ValueNotifier<double> quantity,
    nameSize,
    iconSize,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * .8,
      height: MediaQuery.of(context).size.height * .1,
      decoration: BoxDecoration(
        color: CustomColors.primary,
        boxShadow: [
          BoxShadow(
            color: CustomColors.whiteBG,
            blurRadius: .75,
            spreadRadius: .75,
            offset: Offset(0.0, 0.0),
          )
        ],
        borderRadius: BorderRadius.circular(7),
      ),
      child: InkWell(
        //todo:add to cart offline or online
        onTap: () async {
          SharedPreferences pref = await SharedPreferences.getInstance();

          if (pref.get("token") == null) {
            itemBlocOffLine.addToCart(data, quantity.value, widget.storeId,
                double.tryParse(data["price"]));
            final snackBar = SnackBar(
                backgroundColor: CustomColors.greenLightBG,
                content: Text(
                  AppLocale.of(context).getTranslated("lang") == 'English'
                      ? "مرحباُ : تم اضافه المنتج الي سله المشتريات ب نجاح.."
                      : 'Hello: The product has been added to the cart with success.. ',
                  style: TextStyle(color: CustomColors.greenLightFont),
                ));

            _orderProductScaffoldKey.currentState.showSnackBar(snackBar);
          } else {
            print(quantity.value);
            itemBlocOnLineN.addToCart(data, quantity.value, widget.storeId,
                double.tryParse(data["price"]));

            final snackBar = SnackBar(
                backgroundColor: CustomColors.greenLightBG,
                content: Text(
                  AppLocale.of(context).getTranslated("lang") == 'English'
                      ? "مرحباُ : تم اضافه المنتج الي سله المشتريات ب نجاح.."
                      : 'Hello: The product has been added to the cart with success.. ',
                  style: TextStyle(color: CustomColors.greenLightFont),
                ));
            _orderProductScaffoldKey.currentState.showSnackBar(snackBar);
          }
        },
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(
                Icons.shopping_cart,
                color: CustomColors.whiteBG,
                size: iconSize,
              ),
              Text(
                AppLocale.of(context).getTranslated("add_cart"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: nameSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawStoreClose(
    nameSize,
    iconSize,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * .8,
      height: MediaQuery.of(context).size.height * .1,
      decoration: BoxDecoration(
        color: CustomColors.primary,
        boxShadow: [
          BoxShadow(
            color: CustomColors.whiteBG,
            blurRadius: .75,
            spreadRadius: .75,
            offset: Offset(0.0, 0.0),
          )
        ],
        borderRadius: BorderRadius.circular(7),
      ),
      child: InkWell(
        //todo:add to cart offline or online
        onTap: () async {
          final snackBar = SnackBar(
              backgroundColor: CustomColors.ratingLightBG,
              content: Text(
                AppLocale.of(context).getTranslated("lang") == 'English'
                    ? "مرحباُ : ناسف هذا المتجر مغلق الان.."
                    : 'Hello: Sorry, this store is now closed ..',
                style: TextStyle(color: CustomColors.ratingLightFont),
              ));

          _orderProductScaffoldKey.currentState.showSnackBar(snackBar);
        },
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(
                Icons.shopping_cart,
                color: CustomColors.whiteBG,
                size: iconSize,
              ),
              Text(
                AppLocale.of(context).getTranslated("add_cart"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: nameSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
