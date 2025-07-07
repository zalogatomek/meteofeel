import SwiftUI

struct HomeView: View {
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()

            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
}
