import SwiftUI
import MeteoFeelModel

struct AppEntryView: View {

    // MARK: - Properties
    
    @State private var viewModel: AppEntryViewModel

    // MARK: - Lifecycle
    
    init() {
        let profileService = ProfileServiceFactory.create()
        self.viewModel = AppEntryViewModel(profileService: profileService)
    }

    // MARK: - View
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.shouldShowOnboarding {
                    OnboardingView(onFinish: {
                        viewModel.onOnboardingFinished()
                    })
                } else {
                    HomeView()
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    AppEntryView()
} 
