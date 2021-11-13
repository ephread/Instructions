// Copyright (c)  2021-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import DeviceKit

extension Device {
    private var xSeries1stGenOled: [Device] {
        [.iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhone11Pro, .iPhone11ProMax]
    }

    private var xSeries1stGenLcd: [Device] {
        [.iPhoneXR, .iPhone11]
    }

    private var xSeries2ndGenMini: [Device] {
        [.iPhone12Mini, .iPhone13Mini]
    }

    private var xSeries2ndGen: [Device] {
        [.iPhone12, .iPhone12Pro, .iPhone12ProMax,
         .iPhone13, .iPhone13Pro, .iPhone13ProMax]
    }

    func homeIndicatorHeight(for orientation: UIDeviceOrientation) -> CGFloat {
        guard hasRoundedDisplayCorners else { return 0 }

        guard !isPad else { return 20 }

        if orientation.isLandscape {
            return 21
        }

        if orientation.isPortrait {
            return 34
        }

        return 0
    }

    func statusBarHeight(for orientation: UIDeviceOrientation) -> CGFloat {
        guard hasRoundedDisplayCorners else {
            if !isPad && orientation.isLandscape {
                return 0
            }

            return 20
        }

        guard !isPad else { return 24 }
        guard orientation.isPortrait else { return 0 }

        if (xSeries1stGenOled + xSeries1stGenOled.map(Device.simulator)).contains(self) {
            return 44
        }

        if (xSeries1stGenLcd + xSeries1stGenLcd.map(Device.simulator)).contains(self) {
            return 48
        }

        if (xSeries2ndGenMini + xSeries2ndGenMini.map(Device.simulator)).contains(self) {
            return 50
        }

        if (xSeries2ndGen + xSeries2ndGen.map(Device.simulator)).contains(self) {
            return 47
        }

        return 0
    }
}

extension Device {
    var snapshotDescription: String {
        let name: String
        if case .simulator(let device) = Device.current {
            name = device.safeDescription
        } else {
            name = Device.current.safeDescription
        }

        let deviceVersion = Device.current.systemVersion?.replacingOccurrences(of: ".", with: "_")

        return [name, deviceVersion].compactMap { $0 }.joined(separator: "_")
    }
}
