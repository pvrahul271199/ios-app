import SwiftUI

struct LocationSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var locationManager: LocationManager
    @State private var searchText = ""
    @State private var searchResults: [Location] = []
    
    var body: some View {
        NavigationView {
            List(searchResults) { location in
                Button(action: {
                    locationManager.selectedLocation = location
                    dismiss()
                }) {
                    Text(location.name)
                }
            }
            .searchable(text: $searchText)
            .onChange(of: searchText) { _ in
                // TODO: Implement location search using your chosen API
                // For now, showing mock data
                searchResults = [
                    Location(name: "San Francisco Bay", coordinate: .init(latitude: 37.7749, longitude: -122.4194)),
                    Location(name: "Sydney Harbour", coordinate: .init(latitude: -33.8688, longitude: 151.2093))
                ]
            }
            .navigationTitle("Search Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
} 