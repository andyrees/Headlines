//
//  ViewController.swift
//  Headlines
//
//  Created by Andy Rees on 31/08/2017.
//  Copyright © 2017 rantcode.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var chosenCategory: String = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Browse categories"
    }
    
    fileprivate func createAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.chosenCategory = categories[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toNewsSourcesSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toNewsSourcesSegue"{
            
            let newsSourcesViewController = segue.destination as! NewsSourcesViewController
            
            newsSourcesViewController.srcs = self.srcs
            newsSourcesViewController.chosenCategory = self.chosenCategory
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SourcesTableViewCell

        cell.NewNameLabel.text = categories[indexPath.row]
        cell.NewsUIImage.image = UIImage(named: categories[indexPath.row])

        return cell
    }
    
    
    @IBOutlet weak var sourcesTableView: UITableView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.dateLabel.text = ViewController.currentDateString()
        
        getSources()
    }
    
    static func currentDateString() -> String {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        dateFormatter.dateFormat = "EEEE d MMMM"
        let currentDateString: String = dateFormatter.string(from: date).uppercased()

        return currentDateString
    }
    
    var srcs: Sources!{
        
        didSet{

            sourcesUpdated()
        }
    }
    
    var categories = [String]()
    
    func sourcesUpdated(){
        
        extractCategories()
        self.sourcesTableView.reloadData()
    }
    
    func extractCategories(){
        
        for src in srcs.sources{
            
            if !categories.contains(src.category){
                
                categories.append(src.category)
            }
        }
        
        self.categories.sort()
    }
    
    func getSources() {
        
        let urlString = "https://newsapi.org/v1/sources"
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            guard let data = data, error == nil else {
                print(error.debugDescription)
                return
            }
            
            do {
                
                let srcs = try JSONDecoder().decode(Sources.self, from: data)
                                
                DispatchQueue.main.async{

                    // update main thread here
                     self.srcs = srcs
                }
                
            
            } catch let jsonErr{
                
                print("Error serializing json: ", jsonErr)
            }
            
        }).resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

