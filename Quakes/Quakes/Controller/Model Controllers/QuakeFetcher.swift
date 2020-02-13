//
//  QuakeFetcher.swift
//  Quakes
//
//  Created by Chad Rutherford on 2/13/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import Foundation

enum QuakeError: Int, Error {
    case invalidURL
    case networkingError
    case noDataReturned
    case dateMathError
    case decodeError
}

class QuakeFetcher {
    let baseURL = URL(string: "https://earthquake.usgs.gov/fdsnws/event/1/query")
    let dateFormatter = ISO8601DateFormatter()
    
    func fetchQuakes(completion: @escaping (Result<[Quake], QuakeError>) -> Void) {
        let endDate = Date()
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.day = -7 // -365 * 10 // 7 days in the past.
        
        guard let startDate = Calendar.current.date(byAdding: dateComponents, to: endDate) else {
            print("Date math error")
            completion(.failure(.dateMathError))
            return
        }
        
        let interval = DateInterval(start: startDate, end: endDate)
        fetchQuakes(from: interval, completion: completion)
    }
    
    func fetchQuakes(from interval: DateInterval, completion: @escaping (Result<[Quake], QuakeError>) -> Void) {
        guard let baseURL = baseURL else { return }
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let startTime = dateFormatter.string(from: interval.start)
        let endTime = dateFormatter.string(from: interval.end)
        
        let queryItems = [
            URLQueryItem(name: "format", value: "geojson"),
            URLQueryItem(name: "starttime", value: startTime),
            URLQueryItem(name: "endtime", value: endTime)
        ]
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            print(url)
            guard error == nil else { completion(.failure(.networkingError)); return }
            guard let data = data else { completion(.failure(.noDataReturned)); return }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .millisecondsSince1970
                let quakes = try decoder.decode(QuakeResults.self, from: data).quakes
                completion(.success(quakes))
            } catch {
                completion(.failure(.decodeError))
            }
        }.resume()
    }
}
