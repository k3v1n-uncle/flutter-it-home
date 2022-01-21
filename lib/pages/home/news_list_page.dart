import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:it_home_flutter/pages/article/article_detail_page.dart';
import 'package:it_home_flutter/utils/Ajax.dart';
import 'dart:async';

import 'package:it_home_flutter/utils/api.dart';
import 'package:it_home_flutter/utils/net_image.dart';

class NewsList extends StatefulWidget {
  final String newsType; //新闻类型
  @override
  NewsList({Key? key, required this.newsType}) : super(key: key);

  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList>
    with AutomaticKeepAliveClientMixin {
  @protected
  bool get wantKeepAlive => true;
//其他逻辑

  List articleList = [];
  List swiperList = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    print(widget.newsType);
//     _controller.addListener(() async {
//       var maxScroll = _controller.position.maxScrollExtent;
//       var pixels = _controller.position.pixels;
//       if (maxScroll == pixels) {
// //        上拉刷新做处理
//         print('load more ...');
//         curPage++;
//         String url = Api.articleListMore +
//             widget.newsType +
//             '/0f60b51de31f03c91143324895ebc8d$curPage';
//         await Ajax.doAjax(
//             context: context,
//             method: HTTP_METHOD.GET,
//             uri: url,
//             paramMap: {},
//             callBack: (response, result) async {
//               if (mounted) {
//                 setState(() {
//                   articleList.addAll(result['newslist']);
//                 });
//               }
//             });
//       }
//     });
    loadArticleList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pullToRefresh() async {
    String url = Api.articleList + widget.newsType;
    await Ajax.doAjax(
        context: context,
        method: HTTP_METHOD.GET,
        uri: url,
        paramMap: {},
        callBack: (response, result) async {
          if (mounted) {
            setState(() {
              articleList = result['newslist'];
            });
          }
        });
  }

  Future loadSwiperList() async {
    String url = Api.swiperList;
    await Ajax.doAjax(
        context: context,
        method: HTTP_METHOD.GET,
        uri: url,
        paramMap: {},
        callBack: (response, result) async {
          if (mounted) {
            setState(() {
              swiperList = result;
              loading = false;
            });
          }
        });
  }

  Future loadArticleList() async {
    String url = Api.articleList + widget.newsType;

    await Ajax.doAjax(
        context: context,
        method: HTTP_METHOD.GET,
        uri: url,
        paramMap: {},
        callBack: (response, result) async {
          if (mounted) {
            print(result);
            setState(() {
              articleList = result['newslist'];
            });
          }
        });

    loadSwiperList();
  }

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            child: ListView(
              children: <Widget>[
                widget.newsType == 'news'
                    ? Container(
                        margin: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(30),
                        ),
                        height: ScreenUtil().setHeight(280),
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: ScreenUtil().setWidth(696),
                              height: ScreenUtil().setHeight(280),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImageSSL(
                                    '${swiperList[index]['image']}',
                                    headers: {},
                                  ),
                                ),
                              ),
                            );
                          },
                          autoplay: true,
                          pagination: SwiperPagination(
                            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                            builder: DotSwiperPaginationBuilder(
                                color: Colors.white,
                                activeColor: Color(0xfff44f44),
                                size: 5.0,
                                activeSize: 5.0),
                          ),
                          itemCount: swiperList.length,
                          viewportFraction: 0.8,
                          scale: 0.9,
                        ),
                      )
                    : Container(),
                Column(
                  children: <Widget>[
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: articleList.length,
                        itemBuilder: (context, i) {
                          // return _newsRow(data[i]);//把数据项塞入ListView中
                          return _newsRow(articleList[i]);
                        }),
                  ],
                ),
              ],
            ),
            onRefresh: _pullToRefresh);
  }

  //新闻列表单个item
  Widget _newsRow(newsInfo) {
    if (newsInfo["imagelist"] != null) {
      return _generateThreePicItem(newsInfo);
    } else {
      return _generateOnePicItem(newsInfo);
    }
  }

  //仅有一个图片时的效果
  _generateOnePicItem(Map newsInfo) {
    double screenWidth = MediaQuery.of(context).size.width;
    //屏幕左右的PADDING
    double screenPadding = 15.0;
    //每个图片中间的空格
    double wrapSpacing = 5.0;
    //rowWidth
    double rowWidth = screenWidth - screenPadding * 2;
    //计算每个图片的宽度，多减掉0.1避免换行
    double imageWidth = (rowWidth - wrapSpacing * 2) / 3 - 0.5;

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ArticleDetailPage(
                article: newsInfo,
              ),
            ));
      },
      child: Container(
        padding: EdgeInsets.only(
            left: screenPadding,
            top: wrapSpacing,
            right: screenPadding,
            bottom: wrapSpacing),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: imageWidth,
                  height: 80.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImageSSL(
                        '${newsInfo['image']}',
                        headers: {},
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 80.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: rowWidth - (imageWidth + 10.0),
                        child: Text(
                          '${newsInfo["title"]}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(42),
                            color: Color(0xff353535),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        width: rowWidth - (imageWidth + 10.0),
                        margin: EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '${newsInfo["postdate"].toString().substring(0, 10)} ${newsInfo["postdate"].toString().substring(11, 19)}',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(32),
                                color: Color(0xff959595),
                              ),
                            ),
                            Text(
                              '${newsInfo["commentcount"]}评',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(32),
                                color: Color(0xff959595),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black12,
                    //width: 0.5
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //有三张图片时的效果
  _generateThreePicItem(Map newsInfo) {
    double screenWidth = MediaQuery.of(context).size.width;
    //屏幕左右的PADDING
    double screenPadding = 15.0;
    //每个图片中间的空格
    double wrapSpacing = 5.0;
    //Row_width
    double rowWidth = screenWidth - screenPadding * 2;
    //计算每个图片的宽度，多减掉0.1避免换行

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ArticleDetailPage(
                article: newsInfo,
              ),
            ));
      },
      child: Container(
          padding: EdgeInsets.only(
              left: screenPadding,
              top: wrapSpacing,
              right: screenPadding,
              bottom: wrapSpacing),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${newsInfo["title"]}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(40),
                    color: Color(0xff353535),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  width: rowWidth,
                  child: Wrap(
                      spacing: wrapSpacing, // gap between adjacent chips
                      children: _createImageChildren(
                          newsInfo['imagelist'], rowWidth, wrapSpacing)),
                ),
                Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${newsInfo["postdate"].toString().substring(0, 10)} ${newsInfo["postdate"].toString().substring(11, 19)}',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(32),
                            color: Color(0xff959595),
                          ),
                        ),
                        Text(
                          '${newsInfo["commentcount"]}评',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(32),
                            color: Color(0xff959595),
                          ),
                        ),
                      ],
                    )),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                        color: Colors.black12,
                        //width: 0.5
                      ))),
                )
              ])),
    );
  }

  List<Widget> _createImageChildren(mainAddonUrls, rowWidth, wrapSpacing) {
    double imageWidth = 0.0;
    int imageLength = mainAddonUrls.length;
    if (imageLength > 3) {
      imageLength = 3;
    }
    if (imageLength > 0) {
      imageWidth = (rowWidth - wrapSpacing * 2) / imageLength - 0.5;
    }
    List<Widget> children = [];
    int currentLength = 1;
    for (var mainPhotoUrl in mainAddonUrls) {
      if (currentLength > 3) {
        break;
      }
      currentLength++;

      children.add(
        Container(
          width: imageWidth,
          height: 80.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.0),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImageSSL(
                mainPhotoUrl,
                headers: {},
              ),
            ),
          ),
        ),
      );
    }
    return children;
  }
}
