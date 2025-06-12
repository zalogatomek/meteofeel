import SwiftUI

struct HealthStatusItemView: View {
    // MARK: - Properties
    
    let condition: String
    let level: AlertSeverity
    let cause: String
    let iconName: String
    
    // MARK: - View
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: iconName)
                .font(.system(size: 20))
                .foregroundColor(level.color)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(condition)
                    .font(.subheadline.weight(.semibold))
                Text(cause)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
} 