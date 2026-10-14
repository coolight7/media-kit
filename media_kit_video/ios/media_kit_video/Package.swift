// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

/// 平台名（用于按仓库布局兜底找 libs 包），与目录名、包名里的平台段一致。
let platformName = "ios"

/// 仓库根目录。
///
/// 本清单位于 <仓库>/package_extend/media-kit/media_kit_video/ios/media_kit_video/，
/// 往上 5 层就是仓库根。先 resolvingSymlinksInPath()：Flutter 的 SPM 集成通过
/// ios/Flutter/ephemeral/Packages/.packages/<包名> 这类软链接引用插件包，
/// 不解析软链接会从软链接位置往上数，算出来的仓库根是错的。
let repoRoot = URL(fileURLWithPath: #file)
    .resolvingSymlinksInPath()
    .deletingLastPathComponent() // …/ios/media_kit_video
    .deletingLastPathComponent() // …/ios
    .deletingLastPathComponent() // …/media_kit_video
    .deletingLastPathComponent() // …/media-kit
    .deletingLastPathComponent() // …/package_extend
    .deletingLastPathComponent() // 仓库根
    .path

/// libmediaxx.dylib 所在目录，和主程序 Runner 的 CopyFiles 阶段搬进应用包的是同一份文件。
///
/// 这里用绝对路径是因为 SPM 会把 unsafeFlags 原样交给编译器，相对路径会以构建目录为基准。
/// 仓库换位置后需要重新解析一次包（Xcode: File > Packages > Reset Package Caches）。
let libmediaxxDir = "\(repoRoot)/resource/libs/ios/lib"

/// Checks whether a sibling SPM package exists at the given relative path.
///
/// Used to determine whether the native media libs package (e.g. `media_kit_libs_ios_video`)
/// has been included by the developer in their `pubspec.yaml`. When found, `media_kit_video` is
/// linked against it; otherwise it falls back to a stub implementation.
///
/// NOTE: This function is duplicated across iOS and macOS `Package.swift` manifests.
///
/// WARNING: After adding or removing the libs package from `pubspec.yaml`, the Swift Package
/// Manager cache must be cleared manually for the change to take effect:
///
///     rm -rf ~/Library/Caches/org.swift.swiftpm/
///
/// 另外这里补了一个按仓库布局的兜底：Flutter 通过 .packages/<包名> 软链接引用插件包时，
/// 同级目录里就有 libs 包的软链接（主判断命中）；直接用 swift package 或按真实路径打开时，
/// 同级目录里没有 libs 包（它在 package_extend/media-kit/libs/<平台>/ 下），
/// 只按软链接目录判断会误判成"没装 libs 包"，从而编译出没有视频输出的 stub 实现。
func packageExists(at relativePath: String) -> Bool {
    let base = URL(fileURLWithPath: #file).deletingLastPathComponent()
    let path = base.appendingPathComponent(relativePath).standardized.path
    if FileManager.default.fileExists(atPath: path) {
        return true
    }
    let fallback =
        "\(repoRoot)/package_extend/media-kit/libs/\(platformName)/media_kit_libs_\(platformName)_video/\(platformName)/media_kit_libs_\(platformName)_video"
    return FileManager.default.fileExists(atPath: fallback)
}

let libsPath = "../media_kit_libs_ios_video"
let hasLibs = packageExists(at: libsPath)

let package = Package(
    name: "media_kit_video",
    platforms: [
        .iOS("9.0")
    ],
    products: [
        .library(name: "media-kit-video", targets: ["media_kit_video"])
    ],
    dependencies: [],
    targets: [
        // mpv 的 C 接口模块：头文件是 Sources/Mpv/mpv（与 libmediaxx.dylib 同版本的 mpv 头文件，
        // 随包进版本库），链接由下面 media_kit_video 目标的 linkerSettings 指定为仓库里的
        // libmediaxx.dylib。不再使用 media-kit 官方的 Mpv.xcframework（那是 mpv 0.36 + 另一套
        // ffmpeg，会和 Dart 侧使用的 libmediaxx 形成两份 libmpv）。
        .systemLibrary(name: "Mpv", path: "Sources/Mpv"),
        .target(
            name: "media_kit_video",
            dependencies: hasLibs
                ? ["Mpv"]
                : [],
            sources: hasLibs
                ? ["plugin"]
                : ["stub"],
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ],
            linkerSettings: hasLibs
                ? [.unsafeFlags(["-L\(libmediaxxDir)", "-lmediaxx"])]
                : []
        )
    ]
)
