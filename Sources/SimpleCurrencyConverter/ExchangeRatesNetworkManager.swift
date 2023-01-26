import Foundation

public enum ExchangeRatesError: Error {
    case failedToGetResponse
    case failedToConfigureURL
    case invalidResponse
    case failedToDecodeResponse
}

final class ExchangeRatesNetworkManager {
    
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    @available(iOS 13.0.0, *)
    func requestExchangeRate(apiKey: String, url: URL, base: Currency, target: [Currency]) async throws -> Result<[String: Double], Error> {
        do {
            let querryItems = [URLQueryItem(name: "base", value: base.rawValue),
                               URLQueryItem(name: "symbols", value: target.map { $0.rawValue }.joined(separator: ", "))]
            var urlComps = URLComponents(string: url.absoluteString)
            urlComps?.queryItems = querryItems
            
            guard let modifiedURL = urlComps?.url else {
                return .failure(ExchangeRatesError.failedToConfigureURL)
            }
            
            var request = URLRequest(url: modifiedURL)
            request.httpMethod = "GET"
            request.setValue(apiKey, forHTTPHeaderField: "apikey")
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return .failure(ExchangeRatesError.invalidResponse)
            }
            
            if let jsonObject = try? JSONSerialization.jsonObject(with: data),
               let jsonDict = jsonObject as? [String: Any],
               let rates = jsonDict["rates"] as? [String: Double] {
                return .success(rates)
            } else {
                return .failure(ExchangeRatesError.failedToDecodeResponse)
            }
        } catch {
            return .failure(ExchangeRatesError.failedToGetResponse)
        }
    }
    
    @available(iOS 13.0.0, *)
    func requestConvert(apiKey: String, url: URL, amount: Double, base: Currency, target: Currency) async throws -> Result<Double, Error> {
        do {
            let querryItems = [URLQueryItem(name: "from", value: base.rawValue),
                               URLQueryItem(name: "to", value: target.rawValue),
                               URLQueryItem(name: "amount", value: String(amount))]
            var urlComps = URLComponents(string: url.absoluteString)
            urlComps?.queryItems = querryItems
            
            guard let modifiedURL = urlComps?.url else {
                return .failure(ExchangeRatesError.failedToConfigureURL)
            }
            
            var request = URLRequest(url: modifiedURL)
            request.httpMethod = "GET"
            request.setValue(apiKey, forHTTPHeaderField: "apikey")
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return .failure(ExchangeRatesError.invalidResponse)
            }
            
            if let jsonObject = try? JSONSerialization.jsonObject(with: data),
               let jsonDict = jsonObject as? [String: Any],
               let result = jsonDict["result"] as? Double {
                return .success(result)
            } else {
                return .failure(ExchangeRatesError.failedToDecodeResponse)
            }
        } catch {
            return .failure(ExchangeRatesError.failedToGetResponse)
        }
    }
    
}
