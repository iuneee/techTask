//
//  ViewController.swift
//  Translate
//
//  Created by Erni Iun on 2021/04/03.
//

import UIKit

class TranslateViewController: UIViewController {
    @IBOutlet weak var addWordTextField: UITextField!
    @IBOutlet weak var wordTableView: UITableView!
    
    let defaults = UserDefaults.standard
    var translated = [String]()
    var wordList = [String]()
    
    var translateManager = TranslateManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        translateManager.delegate = self
        wordTableView.delegate = self
        wordTableView.dataSource = self
        if let items = defaults.array(forKey: "tranKey") as? [String] {
            translated = items
        }
        if let items = defaults.array(forKey: "originKey") as? [String] {
            wordList = items
        }
    }
    
    @IBAction func addWordPressed(_ sender: UIButton) {
        if let word = addWordTextField.text {
            translateManager.fetchWeather(addWord: word)
            addWord(word: addWordTextField.text!)
            defaults.set(wordList, forKey: "originKey")
            defaults.set(translated, forKey: "tranKey")
            wordTableView.reloadData()
        }
    }
    
    @IBAction func showFullPressed(_ sender: UIButton) {
        let fullMessage = translated.joined(separator: " ")
        showAlert(with: fullMessage)
    }
    
    func addWord(word: String) {
        wordList.append(word)
    }
    
    func removeWord(at index: Int) {
        
        wordList.remove(at: index)
    }
    
    func didUpdateTranslation(_ translateManager: TranslateManager, translate: TranslateModel) {
        DispatchQueue.main.async {
            self.translated.append(translate.addWord)
        }
    }
}


extension TranslateViewController: UITableViewDataSource, UITableViewDelegate, TranslateManagerDelegate {
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Translation", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordList.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAlert(with: translated[indexPath.row])
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = wordTableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath)
        cell.textLabel?.text = wordList[indexPath.row]
        return cell
    }
}

