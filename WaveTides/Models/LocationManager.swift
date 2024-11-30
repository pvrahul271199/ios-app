import Foundation
import CoreLocation

struct Location: Identifiable, Codable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    
    // Add CodingKeys to handle CLLocationCoordinate2D encoding/decoding
    enum CodingKeys: String, CodingKey {
        case id, name
        case latitude, longitude
    }
    
    init(id: UUID = UUID(), name: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
}

@MainActor
class LocationManager: ObservableObject {
    @Published var selectedLocation: Location? {
        didSet {
            if let location = selectedLocation {
                saveLocation(location)
            }
        }
    }
    
    init() {
        selectedLocation = loadSavedLocation()
    }
    
    private func saveLocation(_ location: Location) {
        if let encoded = try? JSONEncoder().encode(location) {
            UserDefaults.standard.set(encoded, forKey: "savedLocation")
        }
    }
    
    private func loadSavedLocation() -> Location? {
        if let data = UserDefaults.standard.data(forKey: "savedLocation"),
           let location = try? JSONDecoder().decode(Location.self, from: data) {
            return location
        }
        return nil
    }
} 