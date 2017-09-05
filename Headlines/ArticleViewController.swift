//
//  ArticleViewController.swift
//  Headlines
//
//  Created by Andy Rees on 05/09/2017.
//  Copyright © 2017 rantcode.com. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {

    var article: Article!
    
    @IBOutlet weak var ArticleUIImage: UIImageView!
    
    @IBOutlet weak var headlineUIlabel: UILabel!
    
    @IBOutlet weak var ArticleSummaryUILabel: UILabel!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let article = article{
            
            self.headlineUIlabel.text = article.title
            self.ArticleSummaryUILabel.text = article.description
            
            self.ArticleUIImage.downloadImageFromUrl(url: article.urlToImage)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

