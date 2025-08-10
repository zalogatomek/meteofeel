import Foundation
import BackgroundTasks
import MeteoFeelModel

@MainActor
final class BackgroundFetchService {
    
    // MARK: - Constants
    
    private static let backgroundTaskIdentifier = "com.zalogatomek.meteofeel.weather-refresh"
    
    // MARK: - Properties
    
    static let shared = BackgroundFetchService()
    private let calendar = Calendar.current
    private let refreshService: any WeatherForecastRefreshServiceProtocol
    
    // MARK: - Lifecycle
    
    private init() {
        self.refreshService = WeatherForecastRefreshServiceFactory.create(apiKey: WeatherApiConfiguration.apiKey)
    }
    
    // MARK: - Background Task Setup
    
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: Self.backgroundTaskIdentifier,
            using: nil
        ) { task in
            self.handleBackgroundTask(task as! BGAppRefreshTask)
        }
    }
    
    func scheduleBackgroundTask() {
        Task {
            let request = BGAppRefreshTaskRequest(identifier: Self.backgroundTaskIdentifier)
            request.earliestBeginDate = await calculateNextFetchDate()
            try? BGTaskScheduler.shared.submit(request)
        }
    }
    
    // MARK: - Scheduling Logic
    
    private func calculateNextFetchDate() async -> Date {
        let shouldRefresh = await refreshService.shouldRefreshForecasts()
        
        if shouldRefresh {
            return calendar.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        } else {
            return nextEarlyMorningDate()
        }
    }
    
    private func nextEarlyMorningDate() -> Date {
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) else {
            return Date()
        }
        
        var components = calendar.dateComponents([.year, .month, .day], from: tomorrow)
        components.hour = 6
        
        return calendar.date(from: components) ?? tomorrow
    }
    
    // MARK: - Background Task Handling
    
    private func handleBackgroundTask(_ task: BGAppRefreshTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        Task {
            do {
                if await refreshService.shouldRefreshForecasts() {
                    try await refreshService.refreshForecasts()
                    task.setTaskCompleted(success: true)
                } else {
                    task.setTaskCompleted(success: true)
                }
                
                scheduleBackgroundTask()
            } catch {
                task.setTaskCompleted(success: false)
                scheduleBackgroundTask()
            }
        }
    }
}
