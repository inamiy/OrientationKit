import UIKit
import AVFoundation

// MARK: - CGImagePropertyOrientation

extension CGImagePropertyOrientation
{
    public init?(uiImageOrientation: UIImage.Orientation)
    {
        switch uiImageOrientation {
        case .up:
            self = .up
        case .upMirrored:
            self = .upMirrored
        case .down:
            self = .down
        case .downMirrored:
            self = .downMirrored
        case .left:
            self = .left
        case .leftMirrored:
            self = .leftMirrored
        case .right:
            self = .right
        case .rightMirrored:
            self = .rightMirrored
        @unknown default:
            return nil
        }
    }

    public var uiImageOrientation: UIImage.Orientation
    {
        UIImage.Orientation.init(cgImageOrientation: self)
    }
}

// MARK: - AVCaptureVideoOrientation

extension AVCaptureVideoOrientation: @retroactive CustomDebugStringConvertible
{
    public var debugDescription: String
    {
        switch self {
        case .portrait:
            return "portrait"
        case .portraitUpsideDown:
            return "portraitUpsideDown"
        case .landscapeRight:
            return "landscapeRight"
        case .landscapeLeft:
            return "landscapeLeft"
        @unknown default:
            return "unknown"
        }
    }

    public init?(deviceOrientation: UIDeviceOrientation)
    {
        switch deviceOrientation {
        case .portrait:
            self = .portrait
        case .portraitUpsideDown:
            self = .portraitUpsideDown
        case .landscapeLeft:
            self = .landscapeRight
        case .landscapeRight:
            self = .landscapeLeft
        case .faceUp,
             .faceDown,
             .unknown:
            return nil
        @unknown default:
            return nil
        }
    }

    public init?(interfaceOrientation: UIInterfaceOrientation)
    {
        switch interfaceOrientation {
        case .portrait:
            self = .portrait
        case .portraitUpsideDown:
            self = .portraitUpsideDown
        case .landscapeLeft:
            self = .landscapeLeft
        case .landscapeRight:
            self = .landscapeRight
        case .unknown:
            return nil
        @unknown default:
            return nil
        }
    }
}

// MARK: - UIDeviceOrientation

extension UIDeviceOrientation: @retroactive CustomDebugStringConvertible
{
    public var debugDescription: String
    {
        switch self {
        case .portrait:
            return "portrait"
        case .portraitUpsideDown:
            return "portraitUpsideDown"
        case .landscapeLeft:
            return "landscapeLeft"
        case .landscapeRight:
            return "landscapeRight"
        case .faceUp:
            return "faceUp"
        case .faceDown:
            return "faceDown"
        case .unknown:
            fallthrough
        @unknown default:
            return "unknown"
        }
    }

    public var interfaceOrientation: UIInterfaceOrientation
    {
        UIInterfaceOrientation.init(deviceOrientation: self)
    }

    public var avCaptureVideoOrientation: AVCaptureVideoOrientation?
    {
        AVCaptureVideoOrientation.init(deviceOrientation: self)
    }

    public var estimatedImageOrientation: UIImage.Orientation?
    {
        switch self {
        case .portrait:
            return .right
        case .portraitUpsideDown:
            return .left
        case .landscapeLeft:
            return .up
        case .landscapeRight:
            return .down
        case .faceUp:
            return nil
        case .faceDown:
            return nil
        case .unknown:
            fallthrough
        @unknown default:
            return nil
        }
    }
}

// MARK: - UIInterfaceOrientation

extension UIInterfaceOrientation: @retroactive CustomDebugStringConvertible
{
    public var debugDescription: String
    {
        switch self {
        case .portrait:
            return "portrait"
        case .portraitUpsideDown:
            return "portraitUpsideDown"
        case .landscapeLeft:
            return "landscapeLeft"
        case .landscapeRight:
            return "landscapeRight"
        case .unknown:
            fallthrough
        @unknown default:
            return "unknown"
        }
    }

    public init(deviceOrientation: UIDeviceOrientation)
    {
        switch deviceOrientation {
        case .portrait:
            self = .portrait
        case .portraitUpsideDown:
            self = .portraitUpsideDown
        case .landscapeLeft:
            self = .landscapeRight
        case .landscapeRight:
            self = .landscapeLeft
        case .faceUp,
             .faceDown,
             .unknown:
            self = .unknown
        @unknown default:
            self = .unknown
        }
    }

    public var avCaptureVideoOrientation: AVCaptureVideoOrientation?
    {
        AVCaptureVideoOrientation.init(interfaceOrientation: self)
    }
}

// MARK: - UIImage.Orientation

extension UIImage.Orientation
{
    public init(cgImageOrientation: CGImagePropertyOrientation)
    {
        switch cgImageOrientation {
        case .up:
            self = .up
        case .upMirrored:
            self = .upMirrored
        case .down:
            self = .down
        case .downMirrored:
            self = .downMirrored
        case .left:
            self = .left
        case .leftMirrored:
            self = .leftMirrored
        case .right:
            self = .right
        case .rightMirrored:
            self = .rightMirrored
        }
    }

    public init?(deviceOrientation: UIDeviceOrientation, cameraPosition: AVCaptureDevice.Position)
    {
        switch cameraPosition {
        case .back:
            switch deviceOrientation {
            case .portrait:
                self = .right
            case .portraitUpsideDown:
                self = .left
            case .landscapeLeft:
                self = .up
            case .landscapeRight:
                self = .down
            case .faceUp,
                 .faceDown,
                 .unknown:
                fallthrough
            @unknown default:
                return nil
            }

        case .front:
            switch deviceOrientation {
            case .portrait:
                self = .leftMirrored
            case .portraitUpsideDown:
                self = .rightMirrored
            case .landscapeLeft:
                self = .downMirrored
            case .landscapeRight:
                self = .upMirrored
            case .faceUp,
                 .faceDown,
                 .unknown:
                fallthrough
            @unknown default:
                return nil
            }

        case .unspecified:
            fallthrough

        @unknown default:
            return nil
        }
    }

    public var cgImagePropertyOrientation: CGImagePropertyOrientation?
    {
        CGImagePropertyOrientation.init(uiImageOrientation: self)
    }

    public var estimatedDeviceOrientation: UIDeviceOrientation
    {
        switch self {
        case .up:
            return .landscapeLeft
        case .down:
            return .landscapeRight
        case .left:
            return .portraitUpsideDown
        case .right:
            return .portrait;
        default:
            return .unknown
        }
    }
}

// MARK: - SwiftUI.Image.Orientation

#if canImport(SwiftUI)

import SwiftUI

extension SwiftUI.Image.Orientation
{
    public init(cgImageOrientation: CGImagePropertyOrientation)
    {
        switch cgImageOrientation {
        case .up:
            self = .up
        case .down:
            self = .down
        case .left:
            self = .left
        case .right:
            self = .right
        case .upMirrored:
            self = .upMirrored
        case .downMirrored:
            self = .downMirrored
        case .leftMirrored:
            self = .leftMirrored
        case .rightMirrored:
            self = .rightMirrored
        }
    }

    public var cgImageOrientation: CGImagePropertyOrientation
    {
        switch self {
        case .up:
            return .up
        case .upMirrored:
            return .upMirrored
        case .down:
            return .down
        case .downMirrored:
            return .downMirrored
        case .left:
            return .left
        case .leftMirrored:
            return .leftMirrored
        case .right:
            return .right
        case .rightMirrored:
            return .rightMirrored
        }
    }
}

#endif
