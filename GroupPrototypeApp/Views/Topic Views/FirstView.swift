import SwiftUI
import UIKit

// MARK: - Helper for Accessibility Announcements

struct AccessibilityNotification {
    struct Announcement {
        let message: Any
        init(_ message: Any) {
            self.message = message
        }
        func post() {
            UIAccessibility.post(notification: .announcement, argument: message)
        }
    }
}

// MARK: - SwiftUI Example

struct FirstView: View {
    @State private var zoomAmount: CGFloat = 1.0

    var body: some View {
        VStack(spacing: 20) {
            // Header text with an accessibility header trait.
            Text("Accessible Apps with SwiftUI and UIKit")
                .font(.title)
                .padding()
                .accessibility(addTraits: .isHeader)
            
            // Button that posts a high-priority announcement.
            Button(action: {
                var highPriorityAnnouncement = AttributedString("High priority announcement from SwiftUI")
                highPriorityAnnouncement.accessibilitySpeechAnnouncementPriority = .high
                AccessibilityNotification.Announcement(highPriorityAnnouncement).post()
            }) {
                Text("SwiftUI: Announce High Priority")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .accessibilityLabel("SwiftUI Announce High Priority Button")
            .accessibility(addTraits: .isButton)
            
            // Zoomable image using SF Symbol "photo".
            Image(systemName: "photo")
                .resizable()
                .frame(width: 200, height: 200)
                .accessibilityLabel("Zoomable Photo")
                .scaleEffect(zoomAmount)
                // The adjustable action automatically makes this element adjustable.
                .accessibilityAdjustableAction { direction in
                    switch direction {
                    case .increment:
                        zoomAmount += 0.5
                        let announcement = "\(Int(zoomAmount)) x zoom"
                        AccessibilityNotification.Announcement(announcement).post()
                    case .decrement:
                        zoomAmount = max(1.0, zoomAmount - 0.5)
                        let announcement = "\(Int(zoomAmount)) x zoom"
                        AccessibilityNotification.Announcement(announcement).post()
                    default:
                        break
                    }
                }
            
            // Image with a custom content shape using SF Symbol "circle.fill" tinted red.
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 200, height: 200)
                .foregroundColor(.red)
                .accessibilityLabel("Red Circle")
                .contentShape(Circle())
        }
        .padding()
    }
}

// MARK: - UIKit Example Wrapped in SwiftUI

struct UIKitViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AccessibleViewController {
        AccessibleViewController()
    }
    
    func updateUIViewController(_ uiViewController: AccessibleViewController, context: Context) {
        // No update needed.
    }
}

class AccessibleViewController: UIViewController {
    var isFiltered = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // UIButton with an accessibility trait and announcement on tap.
        let accessibleButton = UIButton(type: .system)
        accessibleButton.setTitle("UIKit Announce", for: .normal)
        accessibleButton.frame = CGRect(x: 50, y: 100, width: 250, height: 50)
        accessibleButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        accessibleButton.accessibilityTraits = [.button]
        view.addSubview(accessibleButton)
        
        // UIImageView with a circular accessibility path using SF Symbol "circle.fill".
        let imageView = UIImageView(image: UIImage(systemName: "circle.fill"))
        imageView.tintColor = .red
        imageView.frame = CGRect(x: 50, y: 200, width: 200, height: 200)
        imageView.contentMode = .scaleAspectFill
        imageView.accessibilityLabel = "Red Circle"
        imageView.accessibilityPath = UIBezierPath(ovalIn: imageView.bounds)
        view.addSubview(imageView)
        
        // Zoomable image view demonstrating zoom announcements.
        let zoomView = ZoomingImageView(frame: CGRect(x: 50, y: 450, width: 200, height: 200))
        zoomView.backgroundColor = .lightGray
        zoomView.isAccessibilityElement = true
        zoomView.accessibilityLabel = "Zooming Image View"
        // Mark as adjustable so swipe up/down triggers zoom actions.
        zoomView.accessibilityTraits = [.image, .adjustable]
        view.addSubview(zoomView)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let announcement = NSAttributedString(
            string: "UIKit button pressed",
            attributes: [NSAttributedString.Key.accessibilitySpeechAnnouncementPriority: UIAccessibilityPriority.high]
        )
        UIAccessibility.post(notification: .announcement, argument: announcement)
    }
}

class ZoomingImageView: UIScrollView, UIScrollViewDelegate {
    let imageView: UIImageView
    
    override init(frame: CGRect) {
        // Use SF Symbol "photo" as a placeholder for zooming.
        imageView = UIImageView(image: UIImage(systemName: "photo"))
        super.init(frame: frame)
        self.delegate = self
        imageView.frame = bounds
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        minimumZoomScale = 1.0
        maximumZoomScale = 3.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    // These methods are called when VoiceOver swipe up/down is performed on an adjustable element.
    override func accessibilityIncrement() {
        setZoomScale(zoomScale + 0.5, animated: true)
        let zoomAmount = "\(Int(zoomScale)) x zoom"
        UIAccessibility.post(notification: .announcement, argument: zoomAmount)
    }
    
    override func accessibilityDecrement() {
        setZoomScale(max(1.0, zoomScale - 0.5), animated: true)
        let zoomAmount = "\(Int(zoomScale)) x zoom"
        UIAccessibility.post(notification: .announcement, argument: zoomAmount)
    }
}

