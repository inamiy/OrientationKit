import UIKit
import Combine
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    )
    {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)

            let hostingVC = HostingController(
                rootView: ContentView()
            )
            window.rootViewController = hostingVC

            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
