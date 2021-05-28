import 'dart:ui';
import 'package:flutter/material.dart';
import 'BannerViewEnum.dart';
import 'IndicatorView.dart';

const List<String> emptyList = [];

class ImageBannerView extends StatefulWidget {
  /// banner 图片本地路劲列表
  List<String> imageList;

  /// banner 图片url列表,
  List<String> imageUrlList;

  /// 图片展示模式
  BoxFit boxFit;

  /// banner滑动方向
  Axis scrollDirection;

  /// 是否自动滚动
  bool isAutoScroll;

  /// 轮播时间间隔
  double autoScrollTimeInterVal;

  /// 选中颜色
  Color selectIndicatorColor;

  /// 未选中颜色
  Color unSelectIndicatorColor;

  /// banner的indicator样式
  IndicatorStyle indicatorStyle;

  /// indicator的位置
  IndicatorPosition indicatorPosition;

  /// 图片圆角
  double imageborderRadius;

  /// banner的类型
  BannerStyle bannerStyle;

  /// banner图片的左右间距，bannerStyle != BannerStyle.fill有效
  double bannerLRDistance;

  /// 当前的轮播下标
  int get currentIndex {
    return _currentIndex;
  }

  /// 当前的轮播下标,没有图片的时候就返回-1
  int _currentIndex = 0;

  /// ***************以下的distance属性，四边形每条边的逆时针方向为参照右方向***************

  /// indicator距左边的距离(仅当indicatorPosition为bottomLeft、leftTop、rightBottom生效)
  double leftDistance;

  /// indicator距底部的距离
  double bottomDistance;

  /// indicator距右边的距离(仅当indicatorPosition为bottomRight、leftBottom、rightTop生效)
  double rightDistance;

  /// ***************以下为滚动或者点击事件的回调***************

  /// 点击轮播图的回调
  Function(int clickIndex) clickBannerItem;

  /// 滚动轮播图的回调
  Function(int currentIndex, int willScrollToNextIndex) bannerWillScroll;

  /// 滚动轮播图回调
  Function(int didScrollToIndex) bannerDidScroll;

  ImageBannerView(
      {Key key,
      this.imageList = emptyList,
      this.imageUrlList = emptyList,
      this.boxFit = BoxFit.fill,
      this.scrollDirection = Axis.horizontal,
      this.isAutoScroll = true,
      this.autoScrollTimeInterVal = 3.0,
      this.selectIndicatorColor = Colors.white,
      this.unSelectIndicatorColor = Colors.grey,
      this.indicatorStyle = IndicatorStyle.fillPoint,
      this.indicatorPosition = IndicatorPosition.bottomCenter,
      this.imageborderRadius = 8,
      this.bannerLRDistance = 15,
      this.bannerStyle = BannerStyle.fill,
      this.leftDistance = 10.0,
      this.bottomDistance = 10.0,
      this.rightDistance = 10.0,
      this.clickBannerItem,
      this.bannerDidScroll,
      this.bannerWillScroll})
      : super(key: key);

  @override
  _ImageBannerViewState createState() => _ImageBannerViewState();
}

class _ImageBannerViewState extends State<ImageBannerView> {
  final _pageController = PageController(initialPage: 5000);
  var _itemCount = 0;

  IndicatorView _indicator;

  @override
  void initState() {
    super.initState();
    _itemCount = widget.imageList.length > 0
        ? widget.imageList.length
        : (widget.imageUrlList.length > 0 ? widget.imageUrlList.length : 0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: _buildPageView()),
        Positioned.fill(child: _buildIndicator())
      ],
    );
  }

  /// 构建banner
  PageView _buildPageView() {
    PageView pageView;
    if (widget.bannerStyle == BannerStyle.fill ||
        widget.bannerStyle == BannerStyle.normalDistance) {
      final hasBorderRadius = widget.bannerStyle == BannerStyle.normalDistance;
      final distance = hasBorderRadius ? widget.bannerLRDistance : 0.0;
      pageView = PageView.builder(
          controller: _pageController,
          onPageChanged: this._onPageChanged,
          itemCount: _itemCount > 1 ? 10000 : _itemCount,
          itemBuilder: (builderContext, index) {
            final image = widget.imageList.isNotEmpty
                ? Image.asset(
                    widget.imageList[index % 3],
                    fit: widget.boxFit,
                  )
                : Image.network(
                    widget.imageUrlList[index % 3],
                    fit: widget.boxFit,
                  );

            return Container(
              padding: EdgeInsets.fromLTRB(distance, 0, distance, 0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      hasBorderRadius ? widget.imageborderRadius : 0),
                  child: InkWell(child: image, onTap: this._onTapImage)),
            );
          });
    } else if (widget.bannerStyle == BannerStyle.animateSizeDistance) {}
    return pageView;
  }

  /// 点击banner
  void _onTapImage() {
    if (widget.clickBannerItem != null) {
      widget.clickBannerItem(widget._currentIndex);
    }
  }

  /// 切换界面
  void _onPageChanged(int index) {
    final realIndex = (index - 5000) % _itemCount;
    if (widget.bannerDidScroll != null) {
      widget.bannerDidScroll(realIndex);
    }
    this.setState(() {
      widget._currentIndex = realIndex;
      print('widget._currentIndex=${widget._currentIndex}');
    });
  }

  /// 构建indicator
  Container _buildIndicator() {
    /// 图片数量小于1不显示indicator

    if (_itemCount < 1) return Container();

    _indicator = IndicatorView(
        _itemCount,
        widget._currentIndex,
        widget.indicatorStyle,
        widget.selectIndicatorColor,
        widget.unSelectIndicatorColor,
        widget.bottomDistance);
    if (widget.indicatorPosition == IndicatorPosition.bottomCenter) {
      return Container(alignment: Alignment.bottomCenter, child: _indicator);
    } else {}
    return Container();
  }
}
