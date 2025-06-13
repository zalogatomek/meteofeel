# MeteoFeel - Technical Document

## Technology Stack

### Core Technology
- **Skip.tools**: Cross-platform development framework
  - Swift as the primary programming language
  - Shared business logic and data models
  - SwiftUI views automatically transpiled to Compose for Android

### Architecture
- **Domain-Driven Design (DDD)**
  - Clear separation of domain logic
  - Bounded contexts based on core domain concepts
  - Rich domain models

### External Services
- **WeatherAPI.com**
  - RESTful API for weather data
  - Comprehensive weather parameters
  - Cost-effective scaling (1M calls/month free tier)
  - Health-related data (UV index, air quality)
  - 3-day forecast with hourly data
  - Real-time weather conditions
  - Historical weather data available

## Project Structure

### Feature-based Organization
Each feature is organized in its own directory with the following structure:
```
FeatureName/
├── Domain/
│   └── Model/         # Domain models and business logic
└── Infrastructure/
    ├── Model/         # API response models
    └── Mapper/        # Data mapping between API and domain models
```

### Common Components
Shared components and utilities are organized in the Common directory:
```
Common/
├── Time/             # Time-related models and utilities
└── Location/         # Location-related models and utilities
```

### Features
- **Weather**: Weather data models and API integration
- **Forecast**: Weather forecasting and health pattern analysis
- **HealthRecord**: Health status tracking and records
- **User**: User profile and preferences

## Development Tools
- **Version Control**: Git
- **CI/CD**: [TBC] - GitHub Actions or Bitrise 
- **Dependency Management**: Swift Package Manager 