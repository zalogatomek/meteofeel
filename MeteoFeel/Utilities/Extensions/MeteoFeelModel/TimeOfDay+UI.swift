import MeteoFeelModel

extension TimeOfDay {
    var displayName: String {
        switch self {
        case .morning: "Morning"
        case .afternoon: "Afternoon"
        case .evening: "Evening"
        }
    }
}