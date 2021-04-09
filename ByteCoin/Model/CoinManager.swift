import Foundation

protocol CoinMenagerDelegate {
    func didUpdatePrice(price: String , curreny: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinMenagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "22EAABFC-4A9A-4D35-8A18-2E8DCF7C77C2"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String ) {
        
        let urlString =  "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    return
                }
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData){
                        
                        let priceString = String(format:"%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, curreny: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_  data:Data) -> Double? {
        
        let decoder = JSONDecoder()
        do {
            
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastprice = decodedData.rate
            
            print(lastprice)
            
            return lastprice
            
        }catch{
            delegate?.didFailWithError(error: Error.self as! Error)
            return nil
            
        }
    }
}
