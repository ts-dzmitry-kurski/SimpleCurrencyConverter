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
    ///  - Parameter resolve: A closure that takes in a dictionary of exchange rates, where the keys are the currency codes of the target currencies and the values are the exchange rates (expressed as a Double)
    ///  - Parameter reject: A closure that takes in an error object, it will be called if an error occurs while trying to get the exchange rates.

    func getExchangeRate(baseCurrency: Currency, targetCurrencies: [Currency], completion: @escaping (Result<[String: Double], Error>) -> Void)
    
    /// This function is used to convert an amount of money from one currency to another.
    ///
    /// This function uses the exchange rate between the base currency and the target currency to convert the amount and returns the converted amount through the resolve closure. If the request fails, the error is passed to the reject closure.
    ///
    /// - Parameter amount: A Double value representing the amount of money to be converted.
    /// - Parameter baseCurrency: A Currency object representing the currency of the amount to be converted.
    /// - Parameter targetCurrency: A Currency object representing the currency to which the amount should be converted
    /// - Parameter resolve: A closure that takes in a double value representing the converted amount, it will be called when the conversion is successful
    /// - Parameter reject: A closure that takes in an error object, it will be called if an error occurs while trying to convert the amount
            
    func convert(amount: Double, baseCurrency: Currency, targetCurrency: Currency, completion: @escaping (Result<Double, Error>) -> Void)
    
    ///     This function is used to convert an amount of money from one currency to multiple target currencies.
    ///
    ///     This function uses the exchange rate between the base currency and the target currencies to convert the amount to all the target currencies, it returns the converted amount in all the target currencies through the resolve closure as a dictionary. If the request fails, the error is passed to the reject closure.
    ///
    ///        - Parameter amount: A Double value representing the amount of money to be converted.
    ///        - Parameter baseCurrency: A Currency object representing the currency of the amount to be converted.
    ///        - Parameter targetCurrency: An array of Currency objects representing the currencies to which the amount should be converted
    ///        - Parameter resolve: A closure that takes in a dictionary of converted amount, where the keys are the currency codes of the target currencies and the values are the converted amount (expressed as a Double)
    ///        - Parameter reject: A closure that takes in an error object, it will be called if an error occurs while trying to convert the amount

    func convert(amount: Double, baseCurrency: Currency, targetCurrencies: [Currency], completion: @escaping (Result<[String: Double], Error>) -> Void)
}
