//
//  TableViewCell.swift
//  Countries
//
//  Created by Eda Altuntas on 1.02.2022.
//

import UIKit
import CoreData

protocol TableViewCellsDelegate : AnyObject {
    func delete(cell: TableViewCell)
}

class TableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var view: UIView!
    weak var delegate: TableViewCellsDelegate?
    var country : Datum? {
        didSet {
            guard let c = country else { return }
            label.text = c.name
            if ( SaveController.exists(name: c.name!)) {
                self.button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.gray.cgColor;
        self.layer.borderWidth =  1.0;
        self.layer.cornerRadius = 10;
        self.clipsToBounds = true
        self.selectionStyle = .none
        if ( self.reuseIdentifier! == "HomeTableViewCell") {
            self.button.addTarget(self, action: #selector(save), for: .touchUpInside)
        }else if(self.reuseIdentifier! == "SavedTableViewCell"){
            self.button.addTarget(self, action: #selector(rem), for: .touchUpInside)
        }
    }
    
    @objc func save() {
        if ( SaveController.save(country: country!)) {
            self.button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
    }
    
    @objc func rem() {
        if ( SaveController.rem(name: label.text!)) {
            delegate?.delete(cell: self)
        }
    }
}
