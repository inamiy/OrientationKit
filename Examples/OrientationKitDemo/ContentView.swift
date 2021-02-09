import SwiftUI
import OrientationKit

struct ContentView: View
{
    /// - Note: Call `.withOrientations()` at root view to extract orientations via `@Environment`.
    @Environment(\.deviceOrientation)
    private var deviceOrientation

    @Environment(\.interfaceOrientation)
    private var interfaceOrientation

    /// - Note: To grab other `OrientationManager`'s properties e.g. `deviceMotion`, just access via `EnvironmentObject`.
    @EnvironmentObject
    private var manager: OrientationManager

    var body: some View
    {
        return VStack(spacing: 20) {
            VStack(spacing: 10) {
                hStack(
                    key: "@Environment deviceOrientation",
                    value: "\(self.deviceOrientation.debugDescription)"
                )
                Divider()
                hStack(
                    key: "UIDevice.current orientation",
                    value: "\(UIDevice.current.orientation.debugDescription)"
                )
            }
            .paddingBorder()

            VStack(spacing: 10) {
                hStack(
                    key: "@Environment interfaceOrientation",
                    value: "\(self.interfaceOrientation.debugDescription)"
                )
                Divider()
                hStack(
                    key: "statusBarOrientation",
                    value: "\(UIApplication.shared.statusBarOrientation.debugDescription)"
                )
            }
            .paddingBorder()

            accelerometerText()
        }
        .frame(maxWidth: 500)
    }

    private func hStack(key: String, value: String) -> some View
    {
        HStack(spacing: 20) {
            Text(key)
                .multilineTextAlignment(.center)
                .font(.footnote)
                .lineLimit(2)
                .frame(minWidth: 0, maxWidth: 140)

            Divider()
                .frame(maxHeight: 24)

            Text(value)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .frame(minWidth: 0, maxWidth: .infinity)
        }
    }

    @ViewBuilder
    private func accelerometerText() -> some View
    {
        if let acc = manager.deviceMotion?.gravity {
            HStack {
                Text("x = \(percent(acc.x))")
                Text("y = \(percent(acc.y))")
                Text("z = \(percent(acc.z))")
            }
        } else {
            Text("none")
        }
    }
}

private func percent(_ x: Double) -> String
{
    percentFormatter.string(from: NSNumber(value: Double(x))) ?? "NaN"
}

private let percentFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.minimumIntegerDigits = 1
    formatter.maximumIntegerDigits = 3
    formatter.maximumFractionDigits = 0
    return formatter
}()

extension View
{
    func paddingBorder() -> some View {
        self
            .padding()
            .border(Color.black)
            .padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        Group {
            ContentView()
                .previewLayout(.fixed(width: 390, height: 844))
                .environment(\.horizontalSizeClass, .regular)
                .environment(\.verticalSizeClass, .compact)

            ContentView()
                .previewLayout(.fixed(width: 844, height: 390))
                .environment(\.horizontalSizeClass, .compact)
                .environment(\.verticalSizeClass, .compact)
        }
    }
}
