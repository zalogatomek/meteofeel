import Foundation

@Observable public final class UserProfileForm {
    
    // MARK: - Properties
    
    public var name: String? = nil
    public var location: Location? = nil
    public var healthIssues: Set<HealthIssue> = Set(HealthIssue.allCases)
    
    // MARK: - Lifecycle
    
    public init(userProfile: UserProfile? = nil) {
        self.name = userProfile?.name
        self.location = userProfile?.location
        self.healthIssues = userProfile?.healthIssues ?? Set(HealthIssue.allCases)
    }
    
    // MARK: - Validation
    
    public var isNameValid: Bool {
        true
    }

    public var isLocationValid: Bool {
        location != nil
    }

    public var areHealthIssuesValid: Bool {
        !healthIssues.isEmpty
    }

    public var isValid: Bool {
        isNameValid && isLocationValid && areHealthIssuesValid
    }
    
    // MARK: - Form Actions
    
    public func setHealthIssue(_ issue: HealthIssue, selected: Bool) {
        if selected {
            healthIssues.insert(issue)
        } else {
            healthIssues.remove(issue)
        }
    }
    
    // MARK: - Profile Creation
    
    public func createUserProfile() -> UserProfile? {
        guard isValid, let location else { return nil }

        return UserProfile(
            name: name?.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty,
            location: location,
            healthIssues: healthIssues
        )
    }
} 