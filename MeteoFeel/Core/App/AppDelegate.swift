import UIKit
import BackgroundTasks
import MeteoFeelModel

@MainActor
final class AppDelegate: NSObject, UIApplicationDelegate {
    
    // MARK: - UIApplicationDelegate
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        setupBackgroundTasks()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        BackgroundFetchService.shared.scheduleBackgroundTask()
    }
    
    // MARK: - Setup
    
    private func setupBackgroundTasks() {
        BackgroundFetchService.shared.registerBackgroundTasks()
    }
}
