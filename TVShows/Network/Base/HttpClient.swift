//
//  HTTPClient.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

import Foundation

protocol HttpClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, HttpError>
}

extension HttpClient {
    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) async -> Result<T, HttpError> {
        guard let path = endpoint.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: endpoint.baseURL + path) else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            switch response.statusCode {
            case 200...299:
                print(response)
                do {
                    print(data)
                    let resultData = try JSONDecoder().decode(responseModel, from: data)
                    
                } catch (let error) {
                    print(error)
                }
                
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
