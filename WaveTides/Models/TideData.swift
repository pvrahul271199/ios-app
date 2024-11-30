import Foundation

struct TideData {
    struct Measurement: Identifiable {
        let id = UUID()
        let time: Date
        let height: Double
        var isCurrentTime: Bool
    }
    
    let measurements: [Measurement]
}

class TideManager: ObservableObject {
    @Published var tideData: TideData?
    
    func fetchTideData(for location: Location) async {
        // TODO: Implement API call to your chosen tide service
        // For now, using mock data
        let mockData = generateMockData()
        await MainActor.run {
            self.tideData = mockData
        }
    }
    
    private func generateMockData() -> TideData {
        // Generate mock data for testing
        let now = Date()
        let measurements = stride(from: -6, through: 6, by: 0.5).map { hour in
            let time = Calendar.current.date(byAdding: .hour, value: Int(hour), to: now)!
            let height = sin(Double(hour) * .pi / 6) * 2 + 2 // Mock tide height
            return TideData.Measurement(time: time, height: height, isCurrentTime: hour == 0)
        }
        return TideData(measurements: measurements)
    }
} 