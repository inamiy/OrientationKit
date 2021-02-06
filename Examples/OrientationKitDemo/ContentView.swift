import SwiftUI
import OrientationKit

struct ContentView: View
{
    @StateObject
    private var manager: OrientationManager = .init()

    @Environment(\.interfaceOrientation)
    private var interfaceOrientation

    var body: some View
    {
        let deviceOrientation = manager.deviceOrientation
        let deviceToInterfaceOrientation = deviceOrientation.interfaceOrientation

        return VStack(spacing: 20) {
            VStack(spacing: 10) {
                hStack(
                    key: "CoreMotion deviceOrientation",
                    value: "\(deviceOrientation.debugDescription)"
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
                    key: "CoreMotion interfaceOrientation",
                    value: "\(deviceToInterfaceOrientation.debugDescription)"
                )
                Divider()
                hStack(
                    key: "Env interfaceOrientation",
                    value: "\(interfaceOrientation().debugDescription)"
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
        .onAppear {
            manager.start(interval: 0.03, queue: .main)
        }
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
