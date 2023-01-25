public protocol CurrencyConverterProtocol {
    func getExchangeRate(baseCurrency: Currency, targetCurrencies: [Currency],
                         resolve: @escaping ([String: Double]) -> Void, reject: @escaping (Error) -> Void)
    func convert(amount: Double, baseCurrency: Currency, targetCurrency: Currency,
                 resolve: @escaping (Double) -> Void, reject: @escaping (Error) -> Void)
    func convert(amount: Double, baseCurrency: Currency, targetCurrencies: [Currency],
                 resolve: @escaping ([String : Double]) -> Void, reject: @escaping (Error) -> Void)
}
