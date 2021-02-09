#if canImport(SwiftUI)

import SwiftUI

extension View
{
    /// Registers `OrientationManager` to provide
    /// `@Environment(\.deviceOrientation)` and `@Environment(\.interfaceOrientation)`.
    public func withOrientations(
        phase: WithOrientations.Phase = .start(strategy: .systemLike, interval: 0.1, queue: .main)
    ) -> some View
    {
        self.modifier(WithOrientations(phase: phase))
    }
}

/// Registers `OrientationManager` to provide
/// `@Environment(\.deviceOrientation)` and `@Environment(\.interfaceOrientation)`.
public struct WithOrientations: ViewModifier
{
    @ObservedObject
    private var orientationManager: OrientationManager

    @State
    private var interfaceOrientation: UIInterfaceOrientation = .unknown

    private let phase: Phase

    init(phase: Phase)
    {
        self.orientationManager = OrientationManager()
        self.phase = phase
    }

    @ViewBuilder
    public func body(content: Content) -> some View
    {
        content
            .environment(
                \.deviceOrientation,
                orientationManager.deviceOrientation
            )
            .environment(
                \.interfaceOrientation,
                interfaceOrientation
            )
            .environmentObject(self.orientationManager)
            .onReceive(self.orientationManager.$deviceOrientation) { deviceOrientation in
                let interfaceOrientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation ?? .unknown

                if interfaceOrientation != self.interfaceOrientation {
                    self.interfaceOrientation = interfaceOrientation
                }
            }
            .onAppear {
                switch self.phase {
                case let .start(strategy, interval, queue):
                    self.orientationManager.start(strategy: strategy, interval: interval, queue: queue)
                case .stop:
                    self.orientationManager.stop()
                }
            }
    }
}

extension WithOrientations
{
    public enum Phase: Equatable
    {
        case start(
                strategy: OrientationManager.Strategy = .systemLike,
                interval: TimeInterval = 0.1,
                queue: OperationQueue = .main
             )

        case stop

        public static func == (lhs: Self, rhs: Self) -> Bool
        {
            switch (lhs, rhs) {
            case (.start, .start): return true
            case (.stop, .stop): return true
            default: return false
            }
        }
    }
}

#endif
