//  goodKnight
//
//  Created by Tushar Dahiya on 20/12/24.
//

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ContentView()
//}

import Charts
import SwiftUI
@preconcurrency import TabularData

struct ContentView: View {
  
  private enum ViewState {
    case fetching(Error?)
    case loaded(DataFrame)
  }
  
  let exoplanetStore: ExoplanetStore
  @State private var state = ViewState.fetching(nil)

  var body: some View {
    Group {
      switch state {
      case .loaded(let dataFrame):
        VStack {
          Text("Number of Accidents per Year")
            .font(.title)
            .fontDesign(.default)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
          DiscoveryYearChart(dataFrame: dataFrame)
        }
      case .fetching(nil):
        ProgressView { Text("Fetching Data") }
      case .fetching(let error?):
        ErrorView(title: "Query Failed", error: error)
      }
    }
    .padding()
    .task {
      do {
        //let frame = try await exoplanetStore.groupedByDiscoveryYear()
        let frame = try await exoplanetStore.groupedByStateAndYear()
        
        self.state = .loaded(frame)
      }
      catch {
        self.state = .fetching(error)
      }
    }
  }
}

// MARK: - Chart View

struct DiscoveryYearChart: View {
  
  private struct ChartRow {
    let year: Date
    let count: Int
  }
  
  let dataFrame: DataFrame
  
  private var rows: [ChartRow] {
    let yearColumn = dataFrame.columns[0].assumingType(Int.self).filled(with: 9999)
    let countColumn = dataFrame.columns[1].assumingType(Int.self).filled(with: -1)
    let calendar = Calendar(identifier: .gregorian)
    var rows = [ChartRow]()
    for (year, count) in zip(yearColumn, countColumn) {
      let dateComponents = DateComponents(calendar: calendar, year: year)
      let date = dateComponents.date ?? .distantPast
      rows.append(ChartRow(year: date, count: count))
    }
    return rows
  }
  
  var body: some View {
    Chart(rows, id: \.year) { row in
      BarMark(
        x: .value("Year", row.year, unit: .year),
        y: .value("Count", row.count)
      )
    }
  }
}
