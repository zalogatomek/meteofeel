import SwiftUI
import MeteoFeelModel

struct LocationSearchSuggestionRowView: View {
    
    // MARK: - Properties
    
    private let suggestion: LocationSuggestion
    private let onTap: () -> Void

    // MARK: - Lifecycle

    init(
        suggestion: LocationSuggestion,
        onTap: @escaping () -> Void
    ) {
        self.suggestion = suggestion
        self.onTap = onTap
    }
    
    // MARK: - View
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "location")
                    .foregroundColor(.accentColor)
                    .frame(width: 20, height: 20)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(suggestion.title)
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    if !suggestion.subtitle.isEmpty {
                        Text(suggestion.subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
} 