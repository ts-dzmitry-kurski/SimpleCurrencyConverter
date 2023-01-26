import Foundation

public enum Currency: String {
    case JPY = "JPY"
    case USD = "USD"
    case GBP = "GBP"
    case EUR = "EUR"
}

public final class CurrencyConverter: CurrencyConverterProtocol {

    private var exchangeRatesAPIKey: String = ""
    private var networkManager: ExchangeRatesNetworkManager?
    
    public init(exchangeRatesAPIKey: String? = nil, urlSession: URLSession? = nil) {
        if let exchangeRatesAPIKey = exchangeRatesAPIKey {
            self.exchangeRatesAPIKey = exchangeRatesAPIKey
        } else {
            self.exchangeRatesAPIKey = getAPIKeyFromPlistFile()
        }
        
        if let urlSession = urlSession {
            self.networkManager = ExchangeRatesNetworkManager(session: urlSession)
        } else {
            self.networkManager = ExchangeRatesNetworkManager(session: URLSession.shared)
        }
    }
    
    public func getExchangeRate(baseCurrency: Currency, targetCurrencies: [Currency],
                         resolve: @escaping ([String : Double]) -> Void, reject: @escaping (Error) -> Void) {
        if #available(iOS 13.0, *) {
            Task {
                let result = try await networkManager?.requestExchangeRate(
                    apiKey: exchangeRatesAPIKey, url: getExhangeRatesURL().get(), base: baseCurrency, target: targetCurrencies)
                switch result {
                case .success(let rates):
                    resolve(rates)
                case .failure(let error):
                    reject(error)
                default: ()
                }
            }
        }
    }
    
    public func convert(amount: Double, baseCurrency: Currency, targetCurrency: Currency,
                 resolve: @escaping (Double) -> Void, reject: @escaping (Error) -> Void) {
        if #available(iOS 13.0, *) {
            Task {
                let result = try await networkManager?.requestConvert(
                    apiKey: exchangeRatesAPIKey, url: getConvertURL().get(), amount: amount, base: baseCurrency, target: targetCurrency)
                switch result {
                case .success(let result):
                    resolve(result)
                case .failure(let error):
                    reject(error)
                default: ()
                }
            }
        }
    }
    
    public func convert(amount: Double, baseCurrency: Currency, targetCurrencies: [Currency],
                 resolve: @escaping ([String : Double]) -> Void, reject: @escaping (Error) -> Void) {
        if #available(iOS 13.0, *) {
            Task {
                let result = try await networkManager?.requestExchangeRate(
                    apiKey: exchangeRatesAPIKey, url: getExhangeRatesURL().get(), base: baseCurrency, target: targetCurrencies)
                switch result {
                case .success(let rates):
                    var modifiedRates = rates
                    for rate in modifiedRates {
                        let value = rate.value * amount
                        modifiedRates.updateValue(value, forKey: rate.key)
                    }
                    resolve(modifiedRates)
                case .failure(let error):
                    reject(error)
                default: ()
                }
            }
        }
    }
}

private extension CurrencyConverter {
    
    func getAPIKeyFromPlistFile() -> String {
        guard let key = Bundle.main.infoDictionary?["ExchangeRatesAPIKey"] as? String else {
            fatalError("Failed to get exchangerates.io API key from info.plist file")
        }
        
        return key
    }
    
    func getExhangeRatesURL() -> (Result<URL, Error>) {
        if let existingURL = URL(string: "https://api.exchangeratesapi.io/v1/latest") {
            return .success(existingURL)
        } else {
            return .failure(ExchangeRatesError.failedToConfigureURL)
        }
    }
    
    func getConvertURL() -> (Result<URL, Error>) {
        if let existingURL = URL(string: "https://api.exchangeratesapi.io/v1/convert") {
            return .success(existingURL)
        } else {
            return .failure(ExchangeRatesError.failedToConfigureURL)
        }
    }
    
}

