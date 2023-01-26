import Foundation

public protocol CurrencyConverterProtocol {
    func setup()
    func setup(exchangeRatesAPIKey: String)
    func setup(urlSession: URLSession)
    func setup(exchangeRatesAPIKey: String, urlSession: URLSession)
    
    func getExchangeRate(baseCurrency: Currency, targetCurrencies: [Currency],
                         resolve: @escaping ([String: Double]) -> Void, reject: @escaping (Error) -> Void)
    func convert(amount: Double, baseCurrency: Currency, targetCurrency: Currency,
                 resolve: @escaping (Double) -> Void, reject: @escaping (Error) -> Void)
    func convert(amount: Double, baseCurrency: Currency, targetCurrencies: [Currency],
                 resolve: @escaping ([String : Double]) -> Void, reject: @escaping (Error) -> Void)
}
