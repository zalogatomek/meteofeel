# Testing Guidelines

## Framework
- Use **SwiftTesting** framework (modern Swift testing framework)

## Directory Structure
- Mirror the same directory structure in tests as in the tested app/package
- Example: `MeteoFeelModel/Sources/MeteoFeelModel/Forecast/Domain/Model/` → `MeteoFeelModel/Tests/MeteoFeelModelTests/Forecast/Domain/Model/`

## Naming Conventions
- Test structs: `[TestedName]Tests`
  - Example: `WeatherForecastTests`, `HealthPatternCalculatorTests`
- Test methods: Short, descriptive names indicating what is being tested (no "test" prefix)
  - Example: `calculateHealthRisk()`, `mapWeatherResponse()`
- Test annotations: Use `@Test func methodName()` format (no descriptions)

## Test Organization
- Keep test files close to the code they test
- Create 1 test file per 1 source file
- Use clear, concise test method names that describe the specific behavior being tested

## Parameterized Tests
- Use parameterized tests to reduce boilerplate when testing multiple similar cases
- Use `@Test(arguments: zip([arg1, arg2], [expected1, expected2]))` format
- Combine related test cases into single parameterized test functions
- Example: `@Test(arguments: zip([8, 14, 20], [TimeOfDay.morning, .afternoon, .evening]))`

## Test Macros
- Use `#require()` macro when initializing objects that should succeed (replaces nil checks)
- Use `#expect()` macro for assertions
- Example: `let timePeriod = #require(TimePeriod(date: date, calendar: calendar))` 