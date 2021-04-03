//
//  TranslateManager.swift
//  Translate
//
//  Created by Erni Iun on 2021/04/03.
//

import Foundation

protocol TranslateManagerDelegate {
    func didUpdateTranslation(_ translateManager: TranslateManager, translate: TranslateModel)
    func didFailWithError(error: Error)
}

struct TranslateManager {
    let translateURL = "https://aucatranslator.azurewebsites.net/api/v1/wordtranslation/?word"
    
    var delegate: TranslateManagerDelegate?
    
    func fetchWeather(addWord: String) {
        let urlString = "\(translateURL)=\(addWord)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let translate = self.parseJSON(safeData) {
                        delegate?.didUpdateTranslation(self, translate: translate )
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ translateData: Data) -> TranslateModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(TranslateData.self, from: translateData)
            let translation =  decodedData.translation
            let translate = TranslateModel(addWord: translation)
            return translate
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
