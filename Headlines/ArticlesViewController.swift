//
//  ArticlesViewController.swift
//  Headlines
//
//  Created by Andy Rees on 01/09/2017.
//  Copyright © 2017 rantcode.com. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.foundArticles.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 110
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Browse Articles"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentArticle = self.articles.articles[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleTableViewCell
        
        cell.articleTitleLabel.text = currentArticle.title
        cell.articleDescriptionLabel.text = currentArticle.description
        
        cell.ArticleUIImage.downloadImageFromUrl(url: currentArticle.urlToImage)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.chosenArticle = self.articles.articles[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toArticleViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toArticleViewController"{
            
            let articleViewController = segue.destination as! ArticleViewController
            articleViewController.article = self.chosenArticle
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    var articleSource: Source!
    var foundArticles = [Article]()
    var chosenArticle: Article!
    
    var articles:Articles!{
        
        didSet{

            articlesUpdated()
        }
    }
    
    func articlesUpdated(){
        
        for art in articles.articles{
            
            self.foundArticles.append(art)
        }
        DispatchQueue.main.async{
            
            self.articleTableview.reloadData()
        }
    }
    
    @IBOutlet weak var articleTableview: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var myNavItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dateLabel.text = ViewController.currentDateString()
        self.myNavItem.title = articleSource.name.uppercased()
        getArticles()
    }
    
    func getArticles() {
        
        let API_KEY = "{YOUR_API_KEY}"
        
        let sortType = self.articleSource.sortBysAvailable.first
                
        let urlString = "https://newsapi.org/v1/articles?source=\(self.articleSource.id)&sortBy=\(sortType ?? "")&apiKey=\(API_KEY)"
        
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            guard let data = data, error == nil else {
                print(error.debugDescription)
                return
            }
            

//            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? "")
            
            do{
                
                let articles = try JSONDecoder().decode(Articles.self, from: data)
            
                DispatchQueue.main.async{
                    
                    // update main thread here
                    
                    self.articles = articles
                }
                
            }catch let jsonErr{
                
                print("Error serializing json: ", jsonErr)
            }
            
        }).resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func downloadImageFromUrl(url: String) {
        guard let url = URL(string: url) else { return }
        
        let request = NSMutableURLRequest(url: url)
        
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage{
            
            self.image = imageFromCache
            return
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            if error != nil{
                
                print(error as Any)
            }else{
                if let data = data{
                    
                    DispatchQueue.main.async(execute: {
                        
                        if let downloadedImage = UIImage(data: data){
                            
                            self.image = downloadedImage
                            imageCache.setObject(downloadedImage, forKey: url as AnyObject)
                            
                        }else{
                            
                            self.image = UIImage(named: "default-thumbnail")
                        }
                        
                    })
                }
            }
        }
        
        task.resume()
    }
    
}
