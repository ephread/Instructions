// Copyright (c)  2021-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import DeviceKit

public extension UIImage {
    var dimensions: String { "\(Int(size.width))x\(Int(size.height))" }

    func cropped(using orientation: UIDeviceOrientation) -> UIImage? {
        let scale = imageRendererFormat.scale

        let statusBarHeight = Device.current.statusBarHeight(for: orientation) * scale
        let homeIndicatorHeight = Device.current.homeIndicatorHeight(for: orientation) * scale

        guard let rawImage = cgImage else { return nil }

        let rect: CGRect

        switch orientation {
        case .portrait:
            rect = CGRect(
                x: 0,
                y: Int(statusBarHeight),
                width: rawImage.width,
                height: rawImage.height - Int(homeIndicatorHeight) - Int(statusBarHeight)
            )
        case .portraitUpsideDown:
            rect = CGRect(
                x: 0,
                y: Int(homeIndicatorHeight),
                width: rawImage.width,
                height: rawImage.height - Int(statusBarHeight) - Int(homeIndicatorHeight)
            )
        case .landscapeLeft:
            rect = CGRect(
                x: Int(homeIndicatorHeight),
                y: 0,
                width: rawImage.width - Int(statusBarHeight) - Int(homeIndicatorHeight),
                height: rawImage.height
            )
        case .landscapeRight:
            rect = CGRect(
                x: Int(statusBarHeight),
                y: 0,
                width: rawImage.width - Int(homeIndicatorHeight) - Int(statusBarHeight),
                height: rawImage.height
            )
        default:
            return nil
        }

        guard let croppedRawImage = rawImage.cropping(to: rect)  else { return nil }

        return UIImage(
            cgImage: croppedRawImage,
            scale: imageRendererFormat.scale,
            orientation: imageOrientation
        )
    }
}
