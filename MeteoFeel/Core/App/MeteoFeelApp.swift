import SwiftUI

@main
struct MeteoFeelApp: App {
    
    // MARK: - Properties
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            AppEntryView()
        }
    }
}
