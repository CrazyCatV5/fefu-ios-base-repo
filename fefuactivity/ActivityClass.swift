//
//  ActivityClass.swift
//  fefuactivity
//
//  Created by wsr5 on 12.11.2021.
//

import UIKit
import CoreData
class ActivityStartViewController:
    UIViewController {
    @IBAction func Swich(_ sender: Any) {
        FirstView.isHidden = true;
        AlmostWorkingTableView.isHidden = false;
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items:[Activities]?
    func fetchMePlease(){
        do {
            items = try context.fetch(Activities.fetchRequest())
            DispatchQueue.main.async {
                self.AlmostWorkingTableView.reloadData()
            }
        }
        catch{
            FirstView.isHidden = false
            FirstView.backgroundColor = UIColor.blue
        }
    }
    let idCell = "CellFinal"
    let time = ["Вчера","Май 2022 года"]
    @IBOutlet weak var AlmostWorkingTableView: UITableView!
    @IBOutlet weak var FirstView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        AlmostWorkingTableView.isHidden = true;
        AlmostWorkingTableView.dataSource = self;
        AlmostWorkingTableView.delegate = self;
        AlmostWorkingTableView.register(UINib(nibName: "CellFinal", bundle:nil), forCellReuseIdentifier: idCell)
        self.AlmostWorkingTableView.rowHeight = 220
        AlmostWorkingTableView.backgroundColor = UIColor.clear
    }

}

extension ActivityStartViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activityFinal = items![indexPath.row]
        let time = activityFinal.time!
        let date = Calendar.current.dateComponents([.day, .hour, .minute,.second], from: activityFinal.date!, to: Date())
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellFinal", for: indexPath) as! CellFinal
        cell.type.text = activityFinal.title
        cell.lenght.text = "\(activityFinal.distanse/1000)km"
        let hours = Calendar.current.component(.hour, from: time)
        let minutes = Calendar.current.component(.minute, from: time)
        cell.title.text = "\(date.day ?? 0) дней назад"
        if (date.day! < 1){
            cell.title.text = "вчера"
        }
        cell.timeAfter.text = "\(date.hour ?? 0) часов назад"
        cell.time.text = "\(hours) часов \(minutes) минут"
        cell.grandView.backgroundColor = UIColor.clear;
        cell.backgroundColor = UIColor.clear;
        return cell
    }
    
    
}
