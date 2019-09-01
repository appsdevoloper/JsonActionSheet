//
//  ViewController.swift
//  ActionSheet
//
//  Created by Jhon on 29/08/19.
//  Copyright © 2019 Jhon. All rights reserved.
//

import UIKit

// MARK: - Welcome
struct Welcome: Codable {
    let status: Bool
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let id, rollnum, osname, dataDescription: String
    let team: [Team]
    let record, score: [String]
    let titles: [Title]
    
    enum CodingKeys: String, CodingKey {
        case id, rollnum, osname
        case dataDescription = "description"
        case team, record, score, titles
    }
}

// MARK: - Team
struct Team: Codable {
    let name, group: String
}

// MARK: - Title
struct Title: Codable {
    let status, id, icon: String
}

class ViewController: UIViewController, UIActionSheetDelegate {

    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    var titleData = [Title]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadJSON()
    }
    
    // MARK: JSON Data Load
    
    func loadJSON(){
        let urlPath = "https://api.myjson.com/bins/yg7y7"
        let url = NSURL(string: urlPath)
        let session = URLSession.shared
        let task = session.dataTask(with: url! as URL) { data, response, error in
            guard data != nil && error == nil else {
                print(error!.localizedDescription)
                return
            }
            do {
                let decoder = try JSONDecoder().decode(Welcome.self,  from: data!)
                let status = decoder.status
                if status == true {
                    self.teamData = decoder.data.team
                    self.titleData = decoder.data.titles
                    DispatchQueue.main.async {
                        //self.tableView.reloadData()
                    }
                } else {
                    
                }
            } catch { print(error) }
        }
        task.resume()
    }
    
    @IBAction func ClickAction(_ sender: Any) {
        let actionSheetAlertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for title in self.titleData {
            let action = UIAlertAction(title: title.status, style: .default) { (action) in
                print("Title: \(title.status)")
                print("Title: \(title.id)")
                
                DispatchQueue.main.async {
                    self.resultTitle.text = title.status
                }
                
                //self.resultTitle.text = title.status
                //self.contentChangeUI(title: title.status, id: title.id)

                /*// Here, We can set Title Name and by validation can able to set color icon
                 let index = title.id
                 switch index {
                 case "1"  :
                 self.resultTitle.text = title.status
                 self.colorLabel.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                 case "2"  :
                 self.resultTitle.text = title.status
                 self.colorLabel.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                 case "3"  :
                 self.resultTitle.text = title.status
                 self.colorLabel.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
                 default : break
                 }*/
            }
            
            let icon = UIImage.init(named: title.icon)
            action.setValue(icon, forKey: "image")
            action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            actionSheetAlertController.addAction(action)
        }
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheetAlertController.addAction(cancelActionButton)
        self.present(actionSheetAlertController, animated: true, completion: nil)
    }
    
    func contentChangeUI(title: String, id: String) {
        DispatchQueue.main.async {
           self.resultTitle.text = title
        }
    }
}
    


