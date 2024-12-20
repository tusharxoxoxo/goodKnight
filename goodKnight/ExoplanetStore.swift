//
//  DuckDB
//  https://github.com/duckdb/duckdb-swift
//
//  Copyright © 2018-2024 Stichting DuckDB Foundation
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.

//import DuckDB
//import Foundation
//import TabularData
//
//final class ExoplanetStore {
//  
//  static func create() async throws -> ExoplanetStore {
//    let (csvFileURL, _) = try await URLSession.shared.download(from: Self.csvRemoteURL)
//    let database = try Database(store: .inMemory)
//    let connection = try database.connect()
//    let _ = try connection.query(
//      "CREATE TABLE exoplanets AS SELECT * FROM read_csv_auto('\(csvFileURL.path)');")
//    return ExoplanetStore(database: database, connection: connection)
//  }
//  
//  let database: Database
//  let connection: Connection
//  
//  private init(database: Database, connection: Connection) {
//    self.database = database
//    self.connection = connection
//  }
//  
//  func groupedByDiscoveryYear() async throws -> DataFrame {
//    let result = try connection.query("""
//      SELECT disc_year, COUNT(disc_year) AS Count
//        FROM exoplanets
//        GROUP BY disc_year
//        ORDER BY disc_year
//      """)
//    let discoveryYearColumn = result[0].cast(to: Int.self)
//    let countColumn = result[1].cast(to: Int.self)
//    return DataFrame(columns: [
//      TabularData.Column(discoveryYearColumn)
//        .eraseToAnyColumn(),
//      TabularData.Column(countColumn)
//        .eraseToAnyColumn(),
//    ])
//  }
//}
//
//private extension ExoplanetStore {
//  
//  static let csvRemoteURL: URL = {
//    let apiEndpointURL = URL(
//      string: "https://exoplanetarchive.ipac.caltech.edu/TAP/sync")!
//    // column descriptions available at:
//    // https://exoplanetarchive.ipac.caltech.edu/docs/API_PS_columns.html
//    let remoteQueryColumns = [
//      "pl_name",
//      "hostname",
//      "sy_snum",
//      "disc_year",
//      "disc_facility",
//      "st_mass",
//      "st_rad",
//      "st_age",
//    ]
//    let remoteQuery = """
//    SELECT+\(remoteQueryColumns.joined(separator: "+,+"))+FROM+pscomppars
//    """
//    return apiEndpointURL.appending(queryItems: [
//      .init(name: "query", value: remoteQuery),
//      .init(name: "format", value: "csv"),
//    ])
//  }()
//}



//import DuckDB
//import Foundation
//import TabularData
//
//final class ExoplanetStore {
//
//    static func create() throws -> ExoplanetStore {
//        // Ensure the local CSV file exists in the root of the directory
//        let csvFileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
//            .appendingPathComponent("input.csv")
//        guard FileManager.default.fileExists(atPath: csvFileURL.path) else {
//            throw NSError(domain: "FileNotFoundError", code: 1, userInfo: [
//                NSLocalizedDescriptionKey: "The file 'input.csv' does not exist in the root directory."
//            ])
//        }
//        
//        let database = try Database(store: .inMemory)
//        let connection = try database.connect()
//        
//        // Load data from the local CSV file into DuckDB
//        let _ = try connection.query(
//            "CREATE TABLE exoplanets AS SELECT * FROM read_csv_auto('\(csvFileURL.path)');"
//        )
//        
//        return ExoplanetStore(database: database, connection: connection)
//    }
//
//    let database: Database
//    let connection: Connection
//
//    private init(database: Database, connection: Connection) {
//        self.database = database
//        self.connection = connection
//    }
//
//    func groupedByDiscoveryYear() async throws -> DataFrame {
//        let result = try connection.query("""
//          SELECT disc_year, COUNT(disc_year) AS Count
//            FROM exoplanets
//            GROUP BY disc_year
//            ORDER BY disc_year
//          """)
//        let discoveryYearColumn = result[0].cast(to: Int.self)
//        let countColumn = result[1].cast(to: Int.self)
//        return DataFrame(columns: [
//            TabularData.Column(discoveryYearColumn)
//                .eraseToAnyColumn(),
//            TabularData.Column(countColumn)
//                .eraseToAnyColumn(),
//        ])
//    }
//}
//


import DuckDB
import Foundation
import TabularData

final class ExoplanetStore {

    static func create() throws -> ExoplanetStore {
        // Ensure the local CSV file exists in the root of the directory
        //let csvFileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
         //   .appendingPathComponent("input.csv")
        //let csvFileURL = URL(fileURLWithPath: "/Users/blouse_man/Downloads/coding/shit-fun/task2/github/goodKnight/input.csv")
        let csvFileURL = URL(fileURLWithPath: "/(path)")
        if FileManager.default.fileExists(atPath: csvFileURL.path) {
            print("File exists!")
        } else {
            print("File does not exist.")
        }

        print("Looking for file at: \(csvFileURL.path)")
        guard FileManager.default.fileExists(atPath: csvFileURL.path) else {
            throw NSError(domain: "FileNotFoundError", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "The file 'input.csv' does not exist in the root directory."
            ])
        }
        print("Looking for file at: \(csvFileURL.path)")
        let database = try Database(store: .inMemory)
        let connection = try database.connect()

        // Load data from the local CSV file into DuckDB
        let _ = try connection.query(
            "CREATE TABLE accidents AS SELECT * FROM read_csv_auto('\(csvFileURL.path)');"
        )

        return ExoplanetStore(database: database, connection: connection)
    }

    let database: Database
    let connection: Connection

    private init(database: Database, connection: Connection) {
        self.database = database
        self.connection = connection
    }

    func groupedByStateAndYear() async throws -> DataFrame {
        // Extract year from 'inverse_data' and group by state
        let result = try connection.query("""
          SELECT 
              SUBSTR(inverse_data, 1, 4) AS year, 
              state, 
              COUNT(*) AS total_accidents
          FROM accidents
          GROUP BY year, state
          ORDER BY year, state
          LIMIT 50
        """)
        let yearColumn = result[0].cast(to: String.self)
        let stateColumn = result[1].cast(to: String.self)
        let countColumn = result[2].cast(to: Int.self)
        
        return DataFrame(columns: [
            TabularData.Column(yearColumn).eraseToAnyColumn(),
            TabularData.Column(stateColumn).eraseToAnyColumn(),
            TabularData.Column(countColumn).eraseToAnyColumn(),
        ])
    }
}

