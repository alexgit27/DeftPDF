//
//  CustomTableViewCell.swift
//  DeftPDF
//
//  Created by Alexandr Ananchenko on 05.07.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    static let identifier = "CustomTableViewCell"
    
    private let icon = UIImageView()
    private let actionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        
        return label
    }()

    //Override
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(data: SheetViewController.ActionsEnum) {
        if data == .delete { actionLabel.textColor = .red }

        let imageName = data.rawValue.capitalized.filter {!$0.isWhitespace}
        icon.image = UIImage(named: imageName)
        actionLabel.text = data.rawValue
    }
    
    private func setupConstraints() {
        icon.translatesAutoresizingMaskIntoConstraints = false
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(icon)
        contentView.addSubview(actionLabel)
        
        NSLayoutConstraint.activate([
            icon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            icon.widthAnchor.constraint(equalToConstant: 22),
            icon.heightAnchor.constraint(equalToConstant: 22),
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            actionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            actionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
