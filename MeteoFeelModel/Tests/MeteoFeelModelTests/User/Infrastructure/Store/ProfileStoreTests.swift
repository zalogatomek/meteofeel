import Foundation
import Testing
import MeteoFeelTestUtilities
@testable import MeteoFeelModel

struct ProfileStoreTests {

    // MARK: - Tests - Load Profile
    
    @Test 
    func loadProfileWhenNoDataExists() async throws {
        let mockUserDefaults = MockUserDefaults()
        let store = ProfileStore(userDefaults: mockUserDefaults)
        
        let result = await store.loadProfile()
        
        #expect(result == nil)
    }
    
    @Test 
    func loadProfileWithValidData() async throws {
        let profile = UserProfile.createStub()
        let mockUserDefaults = MockUserDefaults()
        let encodedData = try JSONEncoder().encode(profile)
        mockUserDefaults.set(encodedData, forKey: ProfileStore.Keys.profile)
        
        let store = ProfileStore(userDefaults: mockUserDefaults)
        
        let result = await store.loadProfile()
        
        #expect(result == profile)
    }
    
    @Test 
    func loadProfileWithInvalidData() async throws {
        let mockUserDefaults = MockUserDefaults()
        let invalidData = "invalid json data".data(using: .utf8)!
        mockUserDefaults.set(invalidData, forKey: ProfileStore.Keys.profile)
        
        let store = ProfileStore(userDefaults: mockUserDefaults)
        
        let result = await store.loadProfile()
        
        #expect(result == nil)
    }
    
    // MARK: - Tests - Save Profile
    
    @Test 
    func saveProfileSuccessfully() async throws {
        let profile = UserProfile.createStub()
        let mockUserDefaults = MockUserDefaults()
        let store = ProfileStore(userDefaults: mockUserDefaults)
        
        try await store.saveProfile(profile)
        
        let savedData = mockUserDefaults.data(forKey: ProfileStore.Keys.profile)
        let decodedProfile = try JSONDecoder().decode(UserProfile.self, from: savedData!)
        #expect(decodedProfile == profile)
    }
    
    @Test(arguments: [
        UserProfile.createStub(name: "John", location: Location.createStub(name: "New York"), healthIssues: [.headache, .fatigue]),
        UserProfile.createStub(name: nil, location: Location.createStub(name: "London"), healthIssues: [.asthma]),
        UserProfile.createStub(name: "Jane", location: Location.createStub(name: "Paris"), healthIssues: [])
    ])
    func saveAndLoadProfileWithDifferentData(_ profile: UserProfile) async throws {
        let mockUserDefaults = MockUserDefaults()
        let store = ProfileStore(userDefaults: mockUserDefaults)
        
        // Save profile
        try await store.saveProfile(profile)
        
        // Load profile
        let loadedProfile = await store.loadProfile()
        
        #expect(loadedProfile == profile)
    }
    
    @Test 
    func saveProfileOverwritesExistingData() async throws {
        let originalProfile = UserProfile.createStub(name: "Original", location: Location.createStub(name: "Original City"), healthIssues: [.headache])
        let newProfile = UserProfile.createStub(name: "New", location: Location.createStub(name: "New City"), healthIssues: [.fatigue])
        
        let mockUserDefaults = MockUserDefaults()
        let store = ProfileStore(userDefaults: mockUserDefaults)
        
        // Save original profile
        try await store.saveProfile(originalProfile)
        
        // Save new profile
        try await store.saveProfile(newProfile)
        
        // Load profile
        let loadedProfile = await store.loadProfile()
        
        #expect(loadedProfile == newProfile)
        #expect(loadedProfile != originalProfile)
    }
} 