enum IndicatorPosition {
  bottomCenter,
  bottomLeft,
  bottomRight,
  leftCenter,
  leftTop,
  leftBottom,
  rightCenter,
  rightTop,
  rightBottom
}

enum IndicatorStyle {
  /// 实心填充
  fillPoint,

  /// 空心填充
  emptyPoint,

  /// 横线
  line,

  /// 不显示
  none
}

enum BannerStyle {
  /// 整个视图铺满，常规的banner
  fill,

  /// 左右会有间距，图片为圆角
  normalDistance,

  /// 左右有间距，居中时放大
  animateSizeDistance,

  /// 左右有间距,图片内容遮挡切换
  animateContentDistance
}
