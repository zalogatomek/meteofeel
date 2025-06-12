import SwiftUI

struct HomeView: View {
    // MARK: - Properties
    
    private let userName = "Tomek"
    @State private var selectedWellBeing: WellBeingLevel?
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: colorScheme == .dark ? Color.darkModeBackgroundGradient : Color.lightModeBackgroundGradient,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(greeting), \(userName)")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    VStack(spacing: 24) {
                        WeatherCardView(
                            content: {
                                VStack(spacing: 16) {
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack(spacing: 8) {
                                            WeatherMetricView(
                                                iconName: "sun.max.fill",
                                                value: "Sunny",
                                                label: "Weather",
                                                iconColor: .yellow
                                            )
                                            WeatherMetricView(
                                                iconName: "thermometer",
                                                value: "22°C",
                                                label: "Temperature"
                                            )
                                            WeatherMetricView(
                                                iconName: "humidity",
                                                value: "65%",
                                                label: "Humidity"
                                            )
                                            WeatherMetricView(
                                                iconName: "wind",
                                                value: "12 km/h",
                                                label: "Wind"
                                            )
                                            WeatherMetricView(
                                                iconName: "gauge",
                                                value: "1013 hPa",
                                                label: "Pressure"
                                            )
                                        }
                                    }
                                    
                                    Divider()
                                    
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("How are you feeling today?")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        
                                        HStack(spacing: 16) {
                                            WellBeingButton(
                                                level: .good,
                                                isSelected: selectedWellBeing == .good,
                                                action: { selectedWellBeing = .good }
                                            )
                                            
                                            WellBeingButton(
                                                level: .moderate,
                                                isSelected: selectedWellBeing == .moderate,
                                                action: { selectedWellBeing = .moderate }
                                            )
                                            
                                            WellBeingButton(
                                                level: .poor,
                                                isSelected: selectedWellBeing == .poor,
                                                action: { selectedWellBeing = .poor }
                                            )
                                        }
                                    }
                                    
                                    Divider()
                                    
                                    VStack(alignment: .leading, spacing: 12) {
                                        HealthStatusItemView(
                                            condition: "Headache Risk",
                                            level: .high,
                                            cause: "Significant pressure change (1013 → 1005 hPa) expected in next 24h",
                                            iconName: "exclamationmark.triangle.fill"
                                        )
                                        
                                        HealthStatusItemView(
                                            condition: "Joint Pain",
                                            level: .medium,
                                            cause: "Temperature rise of 8°C expected tomorrow",
                                            iconName: "thermometer.high"
                                        )
                                    }
                                }
                                .padding()
                            }
                        )
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Upcoming Conditions")
                                .font(.headline)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForecastCardView(
                                        time: "Morning",
                                        weather: "Partly Cloudy",
                                        temp: "26°C",
                                        healthStatus: "High temperature may affect your condition",
                                        severity: .high,
                                        iconName: "thermometer.high"
                                    )
                                    .containerRelativeFrame(.horizontal) { width, _ in
                                        width * 0.7
                                    }
                                    
                                    ForecastCardView(
                                        time: "Afternoon",
                                        weather: "Thunderstorm",
                                        temp: "22°C",
                                        healthStatus: "High risk of headaches due to pressure changes",
                                        severity: .high,
                                        iconName: "exclamationmark.triangle.fill"
                                    )
                                    .containerRelativeFrame(.horizontal) { width, _ in
                                        width * 0.7
                                    }
                                    
                                    ForecastCardView(
                                        time: "Evening",
                                        weather: "Light Rain",
                                        temp: "19°C",
                                        healthStatus: "Moderate joint pain risk due to temperature drop",
                                        severity: .medium,
                                        iconName: "thermometer.low"
                                    )
                                    .containerRelativeFrame(.horizontal) { width, _ in
                                        width * 0.7
                                    }
                                }
                            }
                            .scrollClipDisabled()
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Weekly Summary")
                                .font(.headline)
                            
                            WeatherCardView(
                                content: {
                                    VStack(spacing: 16) {
                                        VStack(alignment: .leading, spacing: 12) {
                                            HStack {
                                                Text("Your Well-being")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                
                                                Spacer()
                                                
                                                HStack(spacing: 12) {
                                                    WellBeingLegendItem(color: .green, label: "Good")
                                                    WellBeingLegendItem(color: .orange, label: "Moderate")
                                                    WellBeingLegendItem(color: .red, label: "Poor")
                                                }
                                            }
                                            
                                            HStack(alignment: .bottom, spacing: 8) {
                                                ForEach(0..<7) { index in
                                                    VStack(spacing: 4) {
                                                        RoundedRectangle(cornerRadius: 4)
                                                            .fill(weatherImpactColor(for: index))
                                                            .frame(height: weatherImpactHeight(for: index))
                                                        
                                                        Text(dayLabel(for: index))
                                                            .font(.system(size: 11))
                                                            .foregroundColor(.secondary)
                                                    }
                                                }
                                            }
                                            .frame(height: 100)
                                        }
                                    }
                                    .padding()
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
    }
    
    // MARK: - Helpers
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        default: return "Good Evening"
        }
    }
    
    private var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date())
    }
    
    private func weatherImpactColor(for index: Int) -> Color {
        let impacts: [Color] = [.green, .orange, .red, .green, .orange, .green, .red]
        return impacts[index % impacts.count]
    }
    
    private func weatherImpactHeight(for index: Int) -> CGFloat {
        let heights: [CGFloat] = [100, 60, 40, 100, 60, 100, 40]
        return heights[index % heights.count]
    }
    
    private func dayLabel(for index: Int) -> String {
        let calendar = Calendar.current
        let today = Date()
        let date = calendar.date(byAdding: .day, value: -6 + index, to: today)!
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
}

#Preview {
    HomeView()
        //.environment(\.colorScheme, .dark)
}
