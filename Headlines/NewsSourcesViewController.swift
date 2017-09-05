//
//  NewsSourcesViewController.swift
//  Headlines
//
//  Created by Andy Rees on 01/09/2017.
//  Copyright © 2017 rantcode.com. All rights reserved.
//

import UIKit

class NewsSourcesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var srcsCat = [Source]()
    
    var chosenSrc: Source!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        for src in srcs.sources{
            if src.category == chosenCategory{
                
                count += 1
            }
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        for src in srcs.sources{
            if src.category == chosenCategory{
                
                srcsCat.append(src)
            }
        }
        
        cell.textLabel?.text = srcsCat[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.chosenSrc = srcsCat[indexPath.row]
        
        performSegue(withIdentifier: "toArticlesSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toArticlesSegue"{
            
            let articlesViewController = segue.destination as! ArticlesViewController
            articlesViewController.articleSource = self.chosenSrc
        }
    }
  
    var srcs: Sources!
    var chosenCategory: String = ""
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func backButton(_ sender: Any) {
    
        dismiss(animated: true, completion: nil)
    }
    

    @IBOutlet weak var myNavItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dateLabel.text = ViewController.currentDateString()
        
        self.myNavItem.title = "SOURCES"
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
