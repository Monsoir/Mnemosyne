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
	
## 父视图添加的 subLayer 遮挡了 subView

如视频录制按钮，解决：

将父视图的 subLayer 插入到 subView.layer 之下

```swift
panel.contentView.layer.insertSublayer(progressContainerLayer, below: btnRecord.layer)
panel.contentView.layer.insertSublayer(progressLayer, below: btnRecord.layer)
```

### Reference

- [https://medium.com/@nrewik/easy-line-drawing-animation-b56958bc2bee](https://medium.com/@nrewik/easy-line-drawing-animation-b56958bc2bee)
- [https://stackoverflow.com/a/35363425/5211544](https://stackoverflow.com/a/35363425/5211544)

## 描述文字

- NSCameraUsageDescription - 照相机
- NSPhotoLibraryUsageDescription - Photos 的使用
- NSMicrophoneUsageDescription - 麦克风使用

## Date formatter 格式

```
yyyyMMddHHmmss -> 年月日时分秒
```

## 手动现实和隐藏状态栏

1. override 属性

	```swift
	override var prefersStatusBarHidden: Bool {
	   get {
	       return recordStatus == .recording
	   }
	}
	```

2. 手动通知更新

	```swift
	self.setNeedsStatusBarAppearanceUpdate()
	```

## 使用 AVPlayerLayer 播放视频

```swift
let player = AVPlayer(url: <#url#>)
layer = AVPlayerLayer(player: player)
layer?.frame = view.bounds
view.layer.addSubLayer(layer)
player.play()
```

---

若需要监听视频播放完成，则设置

通知监听

```swift
player.actionAtItemEnd = .none

NotificationCenter.default.addObserver(self, selector: #selector(ClipRecordViewController.playerItemDidReachEnd(_:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
```

通知回调

```swift
@objc func playerItemDidReachEnd(_ notification: Notification) {
   // 播放完之后，重新播放
   let playerItem = notification.object as! AVPlayerItem
   playerItem.seek(to: kCMTimeZero)
   
}
```

## 存储一张 UIImage 到沙盒

```swift
// 为图片起名
let thumbnailName = "\(tempAssetMeta.identifier)"

// 指定存储路径
let thumbnailPath = FolderURL.clipThumbnail.appendingPathComponent(thumbnailName).appendingPathExtension("png")

// 将 UIImage 转换为 二进制数据
let thumbnailData = UIImagePNGRepresentation(thumbnail)

// 调用 NSData 的写方法
try? thumbnailData?.write(to: thumbnailPath)
```

## 简要

- 子类可以直接调用父类的 extension 中的方法
- `M_PI` 改为了 `Double.pi`
- 使用 layer 进行画图时(画圆)，需注意 frame 和 center 的值，是相对于 super 而言的，即 super layer，否则坐标将会算错
	- [https://stackoverflow.com/a/26978091/5211544](https://stackoverflow.com/a/26978091/5211544)
- OC 中 `SEL` 在 Swift 中为 `Selector`
- 之前在 OC 中，有的 API 参数是使用 `|` 操作符进行组合，到了 Swift 中，使用 `[]` 将值包裹，多个值使用 `,` 隔开
- KVO 时，要在 init 方法运行完成，有了实例才能进行监听，否则将会找不到方法
	- 最好在 `viewWillAppear(:)` 和 `viewwillDisappear(:)` 之类的方法中进行监听与取消监听
- 在 Swift 中，用于 KVO 监听的属性，需要使用 `@objc dynamic` 修饰
	- 若监听的属性是自定义的枚举类型，定义枚举类型时，也需要使用 `@objc` 修饰
	- 监听自定义枚举属性时，在取得新值时候，需要使用 enum 的创建方法对新值进行转换

		```swift
		let aCustomEnumValue = CustomEnumType(rawValue: change![.newKey] as! Int)
		```

- 向 layer 添加的 animation，是复制过去的，而不是引用过去的
- 关于 Visual Effect View
	- 不要将 alpha 设置小于 1 或者 isHidden = true

	> Setting the alpha to less than 1 on the visual effect view or any of its superviews causes many effects to look incorrect or not show up at all.

- Xcode 9 中，虽然在目录导航器中拖移文件可以同时实现物理移动，但最好还是逐个移动而不是批处理，否则可能报错
- Objective-C 中使用 `#pragma mark - ...` 可以对代码进行分段，而 Swift 中使用 `// MARK: ...`
- 移动 GIF 花费的时间似乎要比移动 mov 要长，即使 GIF 要比 mov 的占用空间小

