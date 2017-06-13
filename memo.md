# Memo

## Swift 3 中通过动态类型调用方法，如类方法

```swift
type(of: self).aClassMethod()
```

## 创建高斯模糊，带文字的那种

1. 创建一个模糊 view

	```swift
	let bar = UIVisualEffectView(effect: UIBlurEffect(style: .light))
	bar.layer.masksToBounds = true
	view.addSubview(bar)
	```

2. 在模糊 view 上再添加一个模糊 view，在将 label 添加到第二个模糊 view

	需要注意的是，模糊的效果有所不同 -> `UIVibrancyEffect`

	```swift
	let subEffectView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: bar.effect as! UIBlurEffect))
	bar.contentView.addSubview(subEffectView)
	subEffectView.contentView.addSubview(lbRecordStatus)
	```

## 使用 BezierPath 进行画图，有动画的那种

1. 创建一个 `CAShapeLayer`

	```swift
	let layer = CAShapeLayer()
	```

2. 设置各种属性

	```swift
	// 描绘 outline 的颜色
	layer.strokeColor = UIColor.clear.cgColor
	// 填充的颜色
	layer.fillColor = UIColor.clear.cgColor
	// 描绘 outline 的线宽度
	layer.lineWidth = StrokeWidth
	```

3. 设置 `UIBezierPath`

	```swift
	/// 新建一个 UIBezierPath
	/// 设置好 path 的路径
	...
	
	/// 对 layer 设置好 path
	layer.path = aPath.cgPath
	xxx.layer.addSublayer(layer)
	```

4. 添加动画

	```swift
	// 动画的控制 strokeEnd 和 strokeStart 都可以
	let animation = CABasicAnimation(keyPath: "strokeEnd")
	animation.fromValue = 0.0
	animation.toValue = 1.0
	animation.duration = 2
	progressLayer.strokeColor = UIColor.white.cgColor
	// 添加动画，会立刻开始，key 为这个动画的名字
	progressLayer.add(animation, forKey: "Stroke progress")
	```


### Reference

- [https://medium.com/@nrewik/easy-line-drawing-animation-b56958bc2bee](https://medium.com/@nrewik/easy-line-drawing-animation-b56958bc2bee)
- [https://stackoverflow.com/a/35363425/5211544](https://stackoverflow.com/a/35363425/5211544)

## 描述文字

- NSCameraUsageDescription - 照相机
- NSPhotoLibraryUsageDescription - Photos 的使用
- NSMicrophoneUsageDescription - 麦克风使用

### 简要

- 子类可以直接调用父类的 extension 中的方法
- `M_PI` 改为了 `Double.pi`
- 使用 layer 进行画图时(画圆)，需注意 frame 和 center 的值，是相对于 super 而言的，即 super layer，否则坐标将会算错
	- [https://stackoverflow.com/a/26978091/5211544](https://stackoverflow.com/a/26978091/5211544)


