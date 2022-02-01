//
//  ViewController.swift
//  Countries
//
//  Created by Eda Altuntas on 1.02.2022.
//

import UIKit
import CoreData

class SavedController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var countries : [Datum] = []
    let identifier = "SavedTableViewCell"
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchSaved()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchSaved()
    }
    
    func fetchSaved() {
        countries.removeAll(keepingCapacity: true)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Saved")
        fetchRequest.returnsObjectsAsFaults = false
        let objects = try! context.fetch(fetchRequest)
        for obj in objects as! [NSManagedObject] {
            let item : Datum = Datum(code: (obj.value(forKey: "code") as? String)!, currencyCodes: [], name: obj.value(forKey: "name") as? String, wikiDataID: "")
            countries.insert(item, at: 0)
        }
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.countries.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier) as! TableViewCell
        cell.country = countries[indexPath.section]
        cell.delegate = self
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "detail" {
           let cell : TableViewCell = sender as! TableViewCell
           let detail = segue.destination as! DetailController
           detail.sCode = cell.country?.code
       }
    }
}

extension SavedController: TableViewCellsDelegate {
    func delete(cell: TableViewCell) {
        fetchSaved()
    }
}
