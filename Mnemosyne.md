# Mnemosyne

## Third Framework

- FMDB
- NSGIF
- FLAnimatedImage
- ReactiveCocoa

## Authenticators

- Photos
- Camera
- MicroPhone

## Patterns

- POP Protocol Oriented Programming with Swift

## Steps

- [x] Authenticators
	- [x] Photos
	- [x] Camera
	- [x] MicroPhone

- [x] Third framework integration
	- [x] [FMDB](https://github.com/ccgus/fmdb)
	- [x] [NSGIF](https://github.com/NSRare/NSGIF)
	- [x] [FLAnimatedImage](https://github.com/Flipboard/FLAnimatedImage)
	- [x] [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)
	- [x] [SnapKit](https://github.com/SnapKit/SnapKit)

- [ ] Videos capture
	- [ ] video ✔︎ audio ✔︎
	- [ ] video ✔︎ audio ✗
	- [ ] video ✗ audio ✔︎

- [ ] Transform videos to gifs

- [ ] Play gifs and .mov and audio in collection view

- [ ] Store gifs and .mov and audio

	- table structure

	field | remark
	------ | ------
	create_datetime | 
	name | 
	type | .gif / .mov / .audio
	location | 
	remark | 

	.gif, .mov and .audio should be stored as separate files


### Extra work

- NSGIF
	- [x] Move and rename file

- File operations
	- [x] Create directories
	- [x] Move files
	- [x] Rename files
	- [x] Delete files

## UI

### 录制进度

[进度按钮](https://github.com/PavelKatunin/DownloadButton)

[声波图](https://cocoapods.org/pods/SwiftSiriWaveformView)

## Design

### 整体部分

- Clips -> Videos
- Sounds -> Audio
- Pics -> Photos

## Core flows

![](http://ww2.sinaimg.cn/large/006tNc79ly1ffob8a0lr5j30xc07ojru.jpg)

## Reference

[在 iOS 上捕获视频](https://objccn.io/issue-23-1/)

