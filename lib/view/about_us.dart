import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matager/controller/about_us_and_terms_of_use_api.dart';
import 'package:matager/utilities/lang/applocate.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/utilities/theme/theme.dart';

import 'homepage.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  AboutAndTermsOfUseAPI aboutUsAPI;

  @override
  void initState() {
    aboutUsAPI = AboutAndTermsOfUseAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: CustomColors.grayThree,
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(AppLocale.of(context).getTranslated("image")),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                  future: aboutUsAPI.getInformationAboutUs(AppLocale.of(context).getTranslated("lang")=="English"?"ar":"en"),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return emptyPage(context);
                        break;
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return loading(context, .75);
                        break;
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          print(snapshot.data);
                          return Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 5,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              itemBuilder: (context, pos) {
                                Map map = snapshot.data['${pos + 1}'];
                                print(map);
                                switch (pos) {
                                  case 0:
                                    return _drawFirstCardOfInfo(map, pos);
                                    break;
                                  default:
                                    return _drawCardOfInfo(map, pos);
                                    break;
                                }
                              },
                            ),
                          );
                        } else
                          return emptyPage(context);
                        break;
                    }
                    return emptyPage(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawFirstCardOfInfo(Map data, int pos) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.98,
            height: MediaQuery.of(context).size.height * .25,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(7),
              ),
              child: (data["img"] == null)
                  ? Image.asset(
                      "assets/images/matager.png",
                    )
                  : Image(
                      height: MediaQuery.of(context).size.height * .3,
                      loadingBuilder:
                          (context, image, ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) {
                          return image;
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      image: NetworkImage(data["img"], scale: 1.0),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * .9,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          data["title"] == null ? "" : data["title"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: CustomColors.primary,
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Stack(
                            children: [
                              Divider(
                                color: CustomColors.red,
                                thickness: 1,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    child: Divider(
                                      color: CustomColors.primary,
                                      thickness: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          data["content"] == null ? "" : data["content"],
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: CustomColors.dark,
                          ),
                          maxLines: 8,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _drawCardOfInfo(Map data, int pos) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * .25,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(7),
              ),
              child: (data["img"] == null)
                  ? Image.asset(
                      "assets/images/matager.png",
                    )
                  : Image(
                      height: MediaQuery.of(context).size.height * .3,
                      loadingBuilder:
                          (context, image, ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) {
                          return image;
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      image: NetworkImage(data["img"], scale: 1.0),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .9,
                      child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                data["title"] == null ? "" : data["title"],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: CustomColors.primary,
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Stack(
                                  children: [
                                    Divider(
                                      color: CustomColors.red,
                                      thickness: 1,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          child: Divider(
                                            color: CustomColors.primary,
                                            thickness: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Text(
                                data["content"] == null ? "" : data["content"],
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: CustomColors.dark,
                                ),
                                maxLines: 8,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
