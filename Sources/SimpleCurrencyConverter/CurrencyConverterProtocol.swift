import Foundation

public protocol CurrencyConverterProtocol {
    
    /// This function is used to retrieve the exchange rate for a given base currency and a list of target currencies.
    ///
    /// This function uses the network manager to make a request to an exchange rates API, passing the base currency code and the target currency codes as parameters.
    /// If the request is successful, the returned exchange rates are passed to the resolve closure.
    /// If the request fails, the error is passed to the reject closure.
    ///
    ///  - Parameter baseCurrency: A Currency object representing the base currency for which the exchange rate is desired.
    ///  - Parameter targetCurrencies: An array of Currency objects representing the target currencies for which the exchange rates are desired.
    ///  - Parameter completion: An escaping closure that takes a Result<[Currency: Double], Error> as its argument. The Result value will contain a dictionary with the target currencies as keys and the corresponding exchange rates as values if the operation was successful, or an Error if the operation failed.

    func getExchangeRate(baseCurrency: Currency, targetCurrencies: [Currency], completion: @escaping (Result<[Currency: Double], Error>) -> Void)
    
    /// This function is used to convert an amount of money from one currency to another.
    ///
    /// This function uses the exchange rate between the base currency and the target currency to convert the amount and returns the converted amount through the resolve closure. If the request fails, the error is passed to the reject closure.
    ///
    /// - Parameter amount: A Double value representing the amount of money to be converted.
    /// - Parameter baseCurrency: A Currency object representing the currency of the amount to be converted.
    /// - Parameter targetCurrency: A Currency object representing the currency to which the amount should be converted
    /// - Parameter completion: An escaping closure that takes a Result<Double, Error> as its argument. The Result value will contain the converted amount as a Double if the conversion was successful, or an Error if the conversion failed.
            
    func convert(amount: Double, baseCurrency: Currency, targetCurrency: Currency, completion: @escaping (Result<Double, Error>) -> Void)
    
    /// This function is used to convert an amount of money from one currency to multiple target currencies.
    ///
    /// This function uses the exchange rate between the base currency and the target currencies to convert the amount to all the target currencies, it returns the converted amount in all the target currencies through the resolve closure as a dictionary. If the request fails, the error is passed to the reject closure.
    ///
    /// - Parameter amount: A Double value representing the amount of money to be converted.
    /// - Parameter baseCurrency: A Currency object representing the currency of the amount to be converted.
    /// - Parameter targetCurrency: An array of Currency objects representing the currencies to which the amount should be converted
    /// - Parameter completion: An escaping closure that takes a Result<[Currency: Double], Error> as its argument. The Result value will contain a dictionary with the target currencies as keys and the corresponding exchange rates as values if the operation was successful, or an Error if the operation failed.

    func convert(amount: Double, baseCurrency: Currency, targetCurrencies: [Currency], completion: @escaping (Result<[Currency: Double], Error>) -> Void)
}
