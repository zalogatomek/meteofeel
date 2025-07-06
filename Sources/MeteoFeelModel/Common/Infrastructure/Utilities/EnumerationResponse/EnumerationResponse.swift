import Foundation

protocol EnumerationResponse: RawRepresentable & CaseIterable & Codable where RawValue: Equatable {
    static var defaultCase: Self { get }
}

extension EnumerationResponse {
    init(rawValue: RawValue) {
        self = Self.caseFor(rawValue) ?? Self.defaultCase
    }
    
    static func caseFor(_ rawValue: RawValue) -> Self? {
        if let rawValue = rawValue as? String {
            return allCases.first(where: { ($0.rawValue as! String).lowercased() == rawValue.lowercased() })
        } else {
            return allCases.first(where: { $0.rawValue == rawValue })
        }
    }
}