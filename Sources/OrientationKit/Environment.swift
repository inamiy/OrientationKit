#if canImport(SwiftUI)

import SwiftUI

extension EnvironmentValues
{
    /// First window's `UIInterfaceOrientation`.
    public var interfaceOrientation: () -> UIInterfaceOrientation
    {
        self[InterfaceOrientationKey.self]
    }
}

private struct InterfaceOrientationKey: EnvironmentKey
{
    public static let defaultValue: () -> UIInterfaceOrientation = {
        UIApplication.shared.windows.first?.windowScene?.interfaceOrientation ?? .unknown
    }
}

#endif
