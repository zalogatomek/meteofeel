import SwiftUI

struct WellBeingButton: View {
    // MARK: - Properties
    
    let level: WellBeingLevel
    let isSelected: Bool
    let action: () -> Void
    
    // MARK: - View
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: level.icon)
                    .font(.system(size: 24))
                    .foregroundColor(level.color)
                Text(level.label)
                    .font(.footnote.weight(.medium))
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? level.color.opacity(0.1) : Color.clear)
            )
        }
    }
}

struct WellBeingLegendItem: View {
    // MARK: - Properties
    
    let color: Color
    let label: String
    
    // MARK: - View
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
} 
