# OrientationKit
iOS device/interface/image/video orientation translation &amp; detection using CoreMotion + SwiftUI + Combine.

## How to Use

```swift
@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            // Call `.withOrientations()` to start observing 
            // CoreMotion-based device orientation changes.
            // This keeps notifying even when device orientation
            // is locked.
            ContentView()
                .withOrientations()
        }
    }
}

struct ContentView: View {
    @Environment(\.deviceOrientation)
    private var deviceOrientation

    @Environment(\.interfaceOrientation)
    private var interfaceOrientation

    /// - Note: To grab other `OrientationManager`'s properties
    /// e.g. `deviceMotion`, just access via `@EnvironmentObject`.
    @EnvironmentObject
    private var manager: OrientationManager

    var body: some View {
        ...
    }
}
```

## Example

<img src=https://user-images.githubusercontent.com/138476/107111127-c2571b80-6890-11eb-9f02-bc75319abe85.jpeg  width=390>

See [Examples](Examples) for more information.

## License

[MIT](LICENSE)