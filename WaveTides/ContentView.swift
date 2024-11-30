//
//  ContentView.swift
//  WaveTides
//
//  Created by Rahul P V on 30/11/24.
//

import SwiftUI
import Charts

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var tideManager = TideManager()
    @State private var showLocationSearch = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Location header
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                    Text(locationManager.selectedLocation?.name ?? "Select Location")
                        .font(.title2)
                    Spacer()
                    Button(action: { showLocationSearch = true }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                
                // Simple placeholder when no data
                if let tideData = tideManager.tideData {
                    TideGraphView(tideData: tideData)
                        .frame(height: 300)
                } else {
                    Text("No tide data available")
                        .frame(height: 300)
                }
                
                Spacer()
            }
            .navigationTitle("WaveTides")
        }
    }
}

struct TideGraphView: View {
    let tideData: TideData
    
    var body: some View {
        Chart {
            ForEach(tideData.measurements) { measurement in
                LineMark(
                    x: .value("Time", measurement.time),
                    y: .value("Height", measurement.height)
                )
                .interpolationMethod(.catmullRom)
                
                if measurement.isCurrentTime {
                    PointMark(
                        x: .value("Current", measurement.time),
                        y: .value("Height", measurement.height)
                    )
                    .foregroundStyle(.blue)
                    .symbolSize(100)
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .hour, count: 3)) { value in
                AxisValueLabel(format: .dateTime.hour())
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
