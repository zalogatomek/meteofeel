import SwiftUI
import MeteoFeelModel

struct SettingsView: View {
    
    // MARK: - Properties
    
    @State private var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showUnsavedAlert = false
    
    // MARK: - Lifecycle
    
    init() {
        let profileService = ProfileServiceFactory.create()
        self._viewModel = State(initialValue: SettingsViewModel(profileService: profileService))
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            if let form = viewModel.form {
                ScrollView {
                    VStack(spacing: 32) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Your Name")
                                .font(.headline)
                            
                            CardTextField("Enter your name (optional)", text: Binding(
                                get: { form.name ?? "" },
                                set: { form.name = $0.nilIfEmpty }
                            ))
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Location")
                                .font(.headline)
                            
                            NavigationButton(title: form.location?.name ?? "Set your location") {
                                SettingsLocationView { location in
                                    form.location = location
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Health Issues")
                                .font(.headline)
                            
                            VStack(spacing: 12) {
                                ForEach(HealthIssue.allCases.sorted(), id: \.self) { issue in
                                    Toggle(
                                        issue.rawValue.capitalized,
                                        isOn: Binding(
                                            get: { form.healthIssues.contains(issue) },
                                            set: { isSelected in form.setHealthIssue(issue, selected: isSelected) }
                                        )
                                    )
                                    .toggleStyle(.switch)
                                }
                            }
                            .cardStyle()
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
            } else if viewModel.isLoading {
                ProgressView("Loading settings...")
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .interactiveDismissDisabled(viewModel.form?.hasChanges == true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    if viewModel.form?.hasChanges == true {
                        showUnsavedAlert = true
                    } else {
                        dismiss()
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .fontWeight(.medium)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    Task {
                        await saveProfile()
                    }
                }
                .disabled(viewModel.isSaving || viewModel.form?.isValid != true)
            }
        }
        .alert("You have unsaved changes", isPresented: $showUnsavedAlert) {
            Button("Discard Changes", role: .destructive) {
                dismiss()
            }
            Button("Save Changes") {
                Task {
                    await saveProfile()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("If you go back now, your changes will be lost. Would you like to save before leaving?")
        }
        .overlay {
            if viewModel.isSaving {
                LoadingOverlay(message: "Saving...")
            }
            
            if let errorMessage = viewModel.errorMessage {
                ErrorOverlay(message: errorMessage) {
                    viewModel.clearError()
                }
            }
        }
        .onAppearFirstTime {
            viewModel.onAppear()
        }
    }

    // MARK: - Actions

    private func saveProfile() async {
        guard await viewModel.saveProfile() else { return }
        dismiss()
    }
} 
