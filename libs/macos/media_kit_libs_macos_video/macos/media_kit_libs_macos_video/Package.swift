// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// 这个包只起"标记"作用，不再从 media-kit 官方 releases 下载 libmpv / ffmpeg 的 xcframework：
//
// - media_kit_video 的 Package.swift 与 podspec 用"同级目录是否存在"判断要不要编译真正的视频
//   输出实现（hasLibs / libs_found），所以这个包必须继续存在（哪怕里面什么都没有）；
// - 原生库改成由 media_kit_video 自己的 Mpv 模块直接链接仓库里的 libmediaxx.dylib：
//   ../media_kit_video/{macos,ios}/media_kit_video/Package.swift 与 Sources/Mpv/module.modulemap。
//
// 这样应用里只有一份 mpv / ffmpeg（libmediaxx.dylib），不会再出现 media-kit 官方 libmpv 0.36
// 和自己的 libmediaxx 同时在同一个进程里的情况。
let package = Package(
    name: "media_kit_libs_macos_video",
    platforms: [
        .macOS("10.9")
    ],
    products: [
        .library(name: "media-kit-libs-macos-video", targets: ["media_kit_libs_macos_video"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "media_kit_libs_macos_video",
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
