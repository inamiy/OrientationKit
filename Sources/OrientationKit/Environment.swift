#if canImport(SwiftUI)

import SwiftUI
import CoreMotion

extension EnvironmentValues
{
    /// CoreMotion-driven `UIDeviceOrientation` (can also observe changes while orientation lock).
    public var deviceOrientation: UIDeviceOrientation
    {
        get {
            self[DeviceOrientationKey.self]
        }
        set {
            self[DeviceOrientationKey.self] = newValue
        }
    }

    /// First window's `UIInterfaceOrientation`.
    public var interfaceOrientation: UIInterfaceOrientation
    {
        get {
            self[InterfaceOrientationKey.self]
        }
        set {
            self[InterfaceOrientationKey.self] = newValue
        }
    }
}

private struct DeviceOrientationKey: EnvironmentKey
{
    public static let defaultValue: UIDeviceOrientation = .unknown
}

private struct InterfaceOrientationKey: EnvironmentKey
{
    public static let defaultValue: UIInterfaceOrientation = .unknown
}

#endif
