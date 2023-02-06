import Foundation

public enum Currency: String {
    case JPY = "JPY"
    case USD = "USD"
    case GBP = "GBP"
    case EUR = "EUR"
}

public class SimpleCurrencyConverter: CurrencyConverterProtocol {

    private var exchangeRatesAPIKey: String?
    private var networkManager: ExchangeRatesNetworkManager?
    private static var sharedInstance: CurrencyConverterProtocol?
    
    /// Public setup singleton instance method for a class that allows for the setting of an exchange rates API key and a URL session.
    ///
    /// If an exchange rates API key is provided, it is set to the class's exchangeRatesAPIKey property.
    /// If no exchange rates API key is provided, the class attempts to retrieve an API key from a plist file using the ExchangeRatesAPIKey keyword.
    ///
    /// If a URL session is provided, it is used to initialize the class's network manager.
    /// If no URL session is provided, the class's network manager is initialized with the shared URL session.

    public static func shared() -> CurrencyConverterProtocol? {
        if sharedInstance == nil {
            assertionFailure("❗ Shared instance is used without framework initialization ❗")
            return nil
        }
        return sharedInstance
    }
    
    public static func setup(exchangeRatesAPIKey: String? = nil, urlSession: URLSession? = nil) -> CurrencyConverterProtocol {
        let container = DependencyContainer()
        sharedInstance = SimpleCurrencyConverter(exchangeRatesAPIKey: exchangeRatesAPIKey, urlSession: urlSession)
        container.register(type: CurrencyConverterProtocol.self, component: sharedInstance!)
        return container.resolve(type: CurrencyConverterProtocol.self)!
    }
    
    private init(exchangeRatesAPIKey: String? = nil, urlSession: URLSession? = nil) {
        if let exchangeRatesAPIKey = exchangeRatesAPIKey {
            self.exchangeRatesAPIKey = exchangeRatesAPIKey
        } else {
            self.exchangeRatesAPIKey = apiKeyFromPlistFile
        }

        if let urlSession = urlSession {
            self.networkManager = ExchangeRatesNetworkManager(session: urlSession)
        } else {
            self.networkManager = ExchangeRatesNetworkManager(session: URLSession.shared)
        }
    }
    
    public func getExchangeRate(
        baseCurrency: Currency,
        targetCurrencies: [Currency],
        completion: @escaping (Result<[Currency : Double], Error>) -> Void) {
            Task {
                let result = try await networkManager?.requestExchangeRate(
                    apiKey: exchangeRatesAPIKey, url: exchangeRatesURL.get(), base: baseCurrency, target: targetCurrencies)
                switch result {
                case .success(let rates):
                    completion(.success(rates))
                case .failure(let error):
                    completion(.failure(error))
                default: ()
                }
            }
        }
    
    public func convert(
        amount: Double,
        baseCurrency: Currency,
        targetCurrency: Currency,
        completion: @escaping (Result<Double, Error>) -> Void) {
            Task {
                let result = try await networkManager?.requestConvert(
                    apiKey: exchangeRatesAPIKey, url: convertURL.get(), amount: amount, base: baseCurrency, target: targetCurrency)
                switch result {
                case .success(let result):
                    completion(.success(result))
                case .failure(let error):
                    completion(.failure(error))
                default: ()
                }
            }
        }
    
    public func convert(
        amount: Double,
        baseCurrency: Currency,
        targetCurrencies: [Currency],
        completion: @escaping (Result<[Currency : Double], Error>) -> Void) {
            Task {
                let result = try await networkManager?.requestExchangeRate(
                    apiKey: exchangeRatesAPIKey, url: exchangeRatesURL.get(), base: baseCurrency, target: targetCurrencies)
                switch result {
                case .success(let rates):
                    var modifiedRates = rates
                    for rate in modifiedRates {
                        let value = rate.value * amount
                        modifiedRates.updateValue(value, forKey: rate.key)
                    }
                    completion(.success(modifiedRates))
                case .failure(let error):
                    completion(.failure(error))
                default: ()
                }
            }
        }
}

private extension SimpleCurrencyConverter {
    
    var apiKeyFromPlistFile: String? {
        guard let key = Bundle.main.infoDictionary?["ExchangeRatesAPIKey"] as? String else {
            assertionFailure("❗ Failed to get exchangerates.io API key from info.plist file ❗")
            return nil
        }
        
        return key
    }
    
    var exchangeRatesURL: (Result<URL, Error>) {
        if let existingURL = URL(string: "https://api.apilayer.com/exchangerates_data/latest") {
            return .success(existingURL)
        } else {
            return .failure(ExchangeRatesError.failedToConfigureURL)
        }
    }
    
    var convertURL: (Result<URL, Error>) {
        if let existingURL = URL(string: "https://api.apilayer.com/exchangerates_data/convert") {
            return .success(existingURL)
        } else {
            return .failure(ExchangeRatesError.failedToConfigureURL)
        }
    }
    
}

