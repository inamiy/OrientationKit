import UIKit
import Combine
import SwiftUI

class HostingController<Content>: UIHostingController<Content> where Content: View
{
    override var shouldAutorotate: Bool
    {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return [.all]
//        return [.portrait, .landscapeRight]
    }
}
