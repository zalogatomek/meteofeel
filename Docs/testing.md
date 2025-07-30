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
- **First Choice**: Use parameterized tests when testing multiple similar scenarios or edge cases
- Use `@Test(arguments: [value1, value2, value3])` format for simple cases
- Use `@Test(arguments: zip([arg1, arg2], [expected1, expected2]))` format when testing input-output pairs
- Combine related test cases into single parameterized test functions to reduce boilerplate
- Only create individual tests when the scenario is unique or complex enough to warrant separate explanation
- Example: `@Test(arguments: zip([8, 14, 20], [TimeOfDay.morning, .afternoon, .evening]))`
- Example: `@Test(arguments: ["valid1", "valid2", "valid3"]) func testValidInputs(_ input: String) throws`

## Test Macros
- Use `#require()` macro when initializing objects that should succeed (replaces nil checks)
- Use `#expect()` macro for assertions
- Example: `let timePeriod = #require(TimePeriod(date: date, calendar: calendar))` 

## Testing Principles
- **Do not test the system**: Avoid testing language features, framework behavior, or simple property assignments
  - Don't test enum raw values unless they contain custom logic
  - Don't test basic Equatable/Hashable conformance unless custom implementation exists
  - Don't test simple property getters/setters
  - Focus on testing business logic, custom initializers, and complex behavior

## Stubbing Strategy
- **Provide `createStub()` functions** for all domain models to enable easy test data creation
- **Rationale**: 
  - **Reusability**: Stub functions can be used across multiple tests, reducing duplication
  - **Multi-purpose**: Stubs are useful not only for testing but also for SwiftUI previews and development
- **Implementation**:
  - Add `createStub()` as a static function in an extension
  - Provide sensible defaults for all parameters
  - Allow overriding specific parameters when needed
  - Use descriptive default values that represent realistic data
- **Example**: `WeatherMeasurement.createStub(parameter: .temperature, value: 25.0)`