import 'package:flutter/material.dart';
import 'BannerViewEnum.dart';

abstract class BaseBannerIndicator extends StatefulWidget {
  /// 点击轮播图的回调
  clickBannerItem(int clickIndex);

  /// 滚动轮播图的回调
  bannerWillScroll(int currentIndex, int willScrollToNextIndex);

  /// 滚动轮播图回调
  bannerDidScroll(int didScrollToIndex);
}

class IndicatorView extends StatefulWidget {
  /// indicator的数量,最多支持20张轮播图,超过20张不显示
  final int itemCount;

  /// 当前下标
  int currentIndex;

  /// indicator的样式
  final IndicatorStyle indicatorStyle;

  /// 选中颜色
  final Color selectIndicatorColor;

  /// 未选中颜色
  final Color unSelectIndicatorColor;

  /// indicator距底部的距离
  final double bottomDistance;

  IndicatorView(
      this.itemCount,
      this.currentIndex,
      this.indicatorStyle,
      this.selectIndicatorColor,
      this.unSelectIndicatorColor,
      this.bottomDistance,
      {Key key})
      : super(key: key);

  @override
  _IndicatorViewState createState() => _IndicatorViewState();
}

class _IndicatorViewState extends State<IndicatorView> {
  List<Container> _pointList = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 20; i++) {
      if (i >= widget.itemCount) break;
      final point = widget.indicatorStyle == IndicatorStyle.fillPoint ? this._createPoint(isSelect: i == widget.currentIndex) : this._createBorderPoint(isSelect: i == widget.currentIndex);
      _pointList.add(point);
      if (i < widget.itemCount) _pointList.add(_createSpace());
    }
  }

  @override
  Widget build(BuildContext context) {
    
    if (widget.indicatorStyle == IndicatorStyle.none ||
        widget.itemCount <= 1 ||
        widget.itemCount > 20) return Container();
    if (widget.indicatorStyle == IndicatorStyle.fillPoint || widget.indicatorStyle == IndicatorStyle.emptyPoint) {
      /// 交换选中和未选中的点
      if (_currentIndex != widget.currentIndex) {
        final current = _pointList[_currentIndex*2];
        _pointList[_currentIndex*2] = _pointList[widget.currentIndex*2];
        _pointList[widget.currentIndex*2] = current;
        _currentIndex = widget.currentIndex;
      }
      return Container(
          padding: EdgeInsets.only(bottom: widget.bottomDistance),
          child: Row(
            children: _pointList,
            mainAxisAlignment: MainAxisAlignment.center,
          ));
    }
    return Container();
  }
  /// 创建实心点
  Container _createPoint({bool isSelect = true}) {
    return Container(
      decoration: BoxDecoration(
          color: isSelect
              ? widget.selectIndicatorColor
              : widget.unSelectIndicatorColor,
          borderRadius: BorderRadius.circular(4)),
      width: 8,
      height: 8,
    );
  }

  /// 创建空心点
  Container _createBorderPoint({bool isSelect = true}){
    return Container(
      decoration: BoxDecoration(
          color: isSelect ? widget.selectIndicatorColor : Color.fromARGB(0, 255, 255, 255),
          border:Border.all(color: isSelect
              ? widget.selectIndicatorColor
              : widget.unSelectIndicatorColor,width:1.5),
          borderRadius: BorderRadius.circular(4)),
      width: 8,
      height: 8,
    );
  }

  /// 创建空白
  Container _createSpace() {
    return Container(
      width: 8,
      height: 8,
    );
  }
}
