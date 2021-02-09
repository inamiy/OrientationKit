#if canImport(Combine)

import UIKit
import Combine
import CoreMotion

/// `CMDeviceMotion` wrapper to comform `ObservableObject`.
public final class OrientationManager: ObservableObject
{
    @Published
    public private(set) var deviceOrientation: UIDeviceOrientation = .unknown

    @Published
    public private(set) var deviceMotion: CMDeviceMotion?

    private var coreMotionManager: CMMotionManager?

    public init() {}

    public func start(
        strategy: Strategy = .systemLike,
        interval: TimeInterval,
        queue: OperationQueue = .current ?? .main
    )
    {
        guard !self.isRunning else { return }

        self.deviceOrientation = UIDevice.current.orientation

        let coreMotionManager = CMMotionManager()
        self.coreMotionManager = coreMotionManager

        coreMotionManager.deviceMotionUpdateInterval = interval

        coreMotionManager.startDeviceMotionUpdates(to: queue) { [weak self] data, error in
            guard let self = self, let data = data else { return }

            self.deviceMotion = data

            let deviceOrientation = strategy.calculate(data.gravity)

            if let deviceOrientation = deviceOrientation {
                self.deviceOrientation = deviceOrientation
            }
        }
    }

    public func stop()
    {
        self.coreMotionManager?.stopDeviceMotionUpdates()
        self.coreMotionManager = nil
        self.deviceOrientation = .unknown
    }

    private var isRunning: Bool
    {
        self.coreMotionManager != nil
    }
}

// MARK: - Strategy

extension OrientationManager
{
    /// `UIDeviceOrientation` estimation strategy.
    public struct Strategy
    {
        /// - Note: Returning `nil` means "no update".
        fileprivate let calculate: (_ gravity: CMAcceleration) -> UIDeviceOrientation?

        public init(calculate: @escaping (_ gravity: CMAcceleration) -> UIDeviceOrientation?)
        {
            self.calculate = calculate
        }
    }
}

// MARK: Strategy Presets

extension OrientationManager.Strategy
{
    /// Largest axis wins the game.
    public static let largestAxis = Self.init(calculate: estimateLargestAxis)

    /// Mimics iOS system orientation change.
    public static let systemLike = Self.init(calculate: estimateSystemLike)
}

private func estimateLargestAxis(gravity g: CMAcceleration) -> UIDeviceOrientation?
{
    if abs(g.z) > abs(g.x) && abs(g.z) > abs(g.y) {
        if (g.z > 0) {
            return .faceDown
        }
        else {
            return .faceUp
        }
    }
    else if abs(g.x) > abs(g.y) {
        if (g.x > 0) {
            return .landscapeRight
        }
        else {
            return .landscapeLeft
        }
    }
    else {
        if (g.y > 0) {
            return .portraitUpsideDown
        }
        else {
            return .portrait
        }
    }
}

private func estimateSystemLike(gravity g: CMAcceleration) -> UIDeviceOrientation?
{
    // Just a quick guess, but mimics iPhone's behavior fairly well.
    if abs(g.z) > 0.88 {
        if (g.z > 0) {
            return .faceDown
        }
        else {
            return .faceUp
        }
    }

    /*

     Linear estimation from the following measured data (all in %)
     when orientation change occurs from the fixed axis.

      z     x     y
    -----------------
      0    88    48
     10    88    48
     20    86    46
     30    84    44
     40    82    41
     50    78    37
     60    73    33
     70    66    26
     80    --    --  (no orientation change)

     FIXME: A better algorithm!

    */

    let x_ = abs(g.x)
    let y_ = abs(g.y)
    let threshold = 1.07 + 0.1 * abs(g.z)

    if x_ > y_ && atan2(x_, y_) > threshold {
        if (g.x > 0) {
            return .landscapeRight
        }
        else {
            return .landscapeLeft
        }
    }
    else if y_ > x_ && atan2(y_, x_) > threshold {
        if (g.y > 0) {
            return .portraitUpsideDown
        }
        else {
            return .portrait
        }
    }

    return nil
}

#endif
