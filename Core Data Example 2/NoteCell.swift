//
//  NoteCell.swift
//  nadumkin@edu.hse.ru PW4
//
//  Created by Никита Думкин on 09.10.2022.
//

import UIKit

class NoteCell: UITableViewCell{
    
    let dataLabel: UITextView = {
        let control = UITextView()
        
        control.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        control.textAlignment = .center
        control.textColor = .black
        control.text = "30"
        control.backgroundColor = .systemGray6
        control.translatesAutoresizingMaskIntoConstraints = false // required
        control.textContainer.lineBreakMode = .byWordWrapping
        control.isScrollEnabled = false
        return control
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    private func addView(){
        backgroundColor = .systemGray6
        
        addSubview(dataLabel)
        dataLabel.pin(to: self, [.top, .bottom, .left,.right])
        
    }
    
    public func configure(_ note: NoteCoreData){
        dataLabel.text = note.text
    }
    
}
