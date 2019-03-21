import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:it_home/tools/Ajax.dart';
import 'package:it_home/tools/api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:it_home/pages/article_detail_page.dart';

class NewsList extends StatefulWidget {
  final String newsType; //新闻类型
  @override
  NewsList({Key key, this.newsType}) : super(key: key);

  _NewsListState createState() => new _NewsListState(this.newsType);
}

class _NewsListState extends State<NewsList>
    with AutomaticKeepAliveClientMixin {
  @protected
  bool get wantKeepAlive => true;
//其他逻辑
  _NewsListState(this.newsType);
  String newsType;
  List articleList = [];
  List swiperList = [];
  int page = 1;
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadArticleList();
  }

  void dispose() {
    super.dispose();
  }

  Future loadSwiperList() async {
    if (newsType == 'news') {
      String url = Api.swiperList;
      var data = {'pageIndex': 1, 'pageSize': 10};
      var response = await HttpUtil().get(url, data: data);
      setState(() {
        swiperList = response;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future loadArticleList() async {
    String url = Api.articleList + newsType;
    var data = {'pageIndex': 1, 'pageSize': 10};
    var response = await HttpUtil().get(url, data: data);
    setState(() {
      articleList = response['newslist'];
    });
    loadSwiperList();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2220)..init(context);
    return loading == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            children: <Widget>[
              newsType == 'news'
                  ? Container(
                      margin: EdgeInsets.symmetric(
                        vertical: ScreenUtil.getInstance().setHeight(30),
                      ),
                      height: ScreenUtil.getInstance().setHeight(500),
                      child: new Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                    '${swiperList[index]['image']}'),
                              ),
                            ),
                          );
                        },
                        autoplay: true,
                        pagination: new SwiperPagination(
                          margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                          builder: new DotSwiperPaginationBuilder(
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
                  new ListView.builder(
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
          );
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
                    borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider('${newsInfo['image']}'),
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
                            fontSize:
                                ScreenUtil(allowFontScaling: true).setSp(42),
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
                                fontSize: ScreenUtil(allowFontScaling: true)
                                    .setSp(32),
                                color: Color(0xff959595),
                              ),
                            ),
                            new Text(
                              '${newsInfo["commentcount"]}评',
                              style: TextStyle(
                                fontSize: ScreenUtil(allowFontScaling: true)
                                    .setSp(32),
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

    return new InkWell(
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
                    fontSize: ScreenUtil(allowFontScaling: true).setSp(40),
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
                            fontSize:
                                ScreenUtil(allowFontScaling: true).setSp(32),
                            color: Color(0xff959595),
                          ),
                        ),
                        new Text(
                          '${newsInfo["commentcount"]}评',
                          style: TextStyle(
                            fontSize:
                                ScreenUtil(allowFontScaling: true).setSp(32),
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

      children.add(CachedNetworkImage(
          imageUrl: mainPhotoUrl,
          fadeInDuration: const Duration(milliseconds: 100),
          fadeOutDuration: const Duration(milliseconds: 100),
          fit: BoxFit.cover,
          width: imageWidth,
          height: 80.0));
    }
    return children;
  }
}
