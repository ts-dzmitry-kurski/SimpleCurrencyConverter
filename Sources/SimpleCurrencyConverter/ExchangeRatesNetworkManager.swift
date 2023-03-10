import Foundation

public enum ExchangeRatesError: Error {
    case failedToGetResponse
    case failedToConfigureURL
    case invalidResponse
    case failedToDecodeResponse
    case failedToGetApiKey
    case failedToAccessNetworkManager
}
 
enum Keys {
    static let base = "base"
    static let symbols = "symbols"
    static let rates = "rates"
    static let from = "from"
    static let to = "to"
    static let amount = "amount"
    static let result = "result"
    
    enum Header {
        static let apiKey = "apikey"
    }
    
    enum Request {
        static let getMethod = "GET"
    }
}

final class ExchangeRatesNetworkManager {
    
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func requestExchangeRate(apiKey: String, url: URL, base: Currency, target: [Currency]) async throws -> Result<[Currency: Double], Error> {
        do {
            let querryItems = [URLQueryItem(name: Keys.base, value: base.rawValue),
                               URLQueryItem(name: Keys.symbols, value: target.map { $0.rawValue }.joined(separator: ", "))]
            var urlComps = URLComponents(string: url.absoluteString)
            urlComps?.queryItems = querryItems
            
            guard let modifiedURL = urlComps?.url else {
                return .failure(ExchangeRatesError.failedToConfigureURL)
            }
            
            var request = URLRequest(url: modifiedURL)
            request.httpMethod = Keys.Request.getMethod
            request.setValue(apiKey, forHTTPHeaderField: Keys.Header.apiKey)
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return .failure(ExchangeRatesError.invalidResponse)
            }
            
            if let jsonObject = try? JSONSerialization.jsonObject(with: data),
               let jsonDict = jsonObject as? [String: Any],
               let rates = jsonDict[Keys.rates] as? [String: Double] {
                return .success(ExchangeRatesNetworkManager.transformToCurrencyKeys(ratesDict: rates))
            } else {
                return .failure(ExchangeRatesError.failedToDecodeResponse)
            }
        } catch {
            return .failure(ExchangeRatesError.failedToGetResponse)
        }
    }
    
    func requestConvert(apiKey: String, url: URL, amount: Double, base: Currency, target: Currency) async throws -> Result<Double, Error> {
        do {
            let querryItems = [URLQueryItem(name: Keys.from, value: base.rawValue),
                               URLQueryItem(name: Keys.to, value: target.rawValue),
                               URLQueryItem(name: Keys.amount, value: String(amount))]
            var urlComps = URLComponents(string: url.absoluteString)
            urlComps?.queryItems = querryItems
            
            guard let modifiedURL = urlComps?.url else {
                return .failure(ExchangeRatesError.failedToConfigureURL)
            }
            
            var request = URLRequest(url: modifiedURL)
            request.httpMethod = Keys.Request.getMethod
            request.setValue(apiKey, forHTTPHeaderField: Keys.Header.apiKey)
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return .failure(ExchangeRatesError.invalidResponse)
            }
            
            if let jsonObject = try? JSONSerialization.jsonObject(with: data),
               let jsonDict = jsonObject as? [String: Any],
               let result = jsonDict[Keys.result] as? Double {
                return .success(result)
            } else {
                return .failure(ExchangeRatesError.failedToDecodeResponse)
            }
        } catch {
            return .failure(ExchangeRatesError.failedToGetResponse)
        }
    }
    
}

extension ExchangeRatesNetworkManager {
    
    static func transformToCurrencyKeys(ratesDict: [String : Double]) -> [Currency: Double] {
        var modifiedRatesDict: [Currency: Double] = [:]
        for (key, value) in ratesDict {
            if let currencyKey = Currency(rawValue: key) {
                modifiedRatesDict[currencyKey] = value
            }
        }
        
        return modifiedRatesDict
    }
}
