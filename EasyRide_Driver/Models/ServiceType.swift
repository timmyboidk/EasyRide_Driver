import Foundation

// This enum now includes ALL service types for the platform, resolving the errors.
enum ServiceType: String, Codable, CaseIterable, Identifiable {
    case airport = "airport"
    case longDistance = "long_distance"
    case charter = "charter" // Generic charter for filtering or general use
    case halfDay = "half_day_charter"
    case fullDay = "full_day_charter"
    case multiDay = "multi_day_charter"
    case carpooling = "carpooling"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .airport: return NSLocalizedString("airport_transfer", comment: "Airport Transfer")
        case .longDistance: return NSLocalizedString("long_distance", comment: "Long Distance")
        case .charter: return NSLocalizedString("charter", comment: "Charter Service")
        case .halfDay: return NSLocalizedString("half_day_charter", comment: "Half-Day Charter")
        case .fullDay: return NSLocalizedString("full_day_charter", comment: "Full-Day Charter")
        case .multiDay: return NSLocalizedString("multi_day_charter", comment: "Multi-Day Charter")
        case .carpooling: return NSLocalizedString("carpooling", comment: "Carpooling")
        }
    }

    var icon: String {
        switch self {
        case .airport: return "airplane"
        case .longDistance: return "road.lanes"
        case .charter: return "star.fill"
        case .halfDay: return "clock.fill"
        case .fullDay: return "sun.max.fill"
        case .multiDay: return "calendar"
        case .carpooling: return "person.2.fill"
        }
    }
}
