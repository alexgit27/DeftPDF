//
//  CustomCollectionViewCell.swift
//  DeftPDF
//
//  Created by Alexandr Ananchenko on 04.07.2022.
//

import UIKit
import PDFKit

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "CustomCollectionViewCell"
    
    private let pdfImageView = UIImageView()
    private  let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .lightGray
        
        return label
    }()
    private let moreButton: UIButton = {
       let button = UIButton()
        button.setTitle("...", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private var presentinOnVC: SheetViewControllerDelegate?
    private var indexPath: IndexPath?
    
    //Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor(red: 0.983, green: 0.983, blue: 0.983, alpha: 1)
        moreButton.addTarget(nil, action: #selector(openSheet), for: .touchUpInside)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        pdfImageView.layer.masksToBounds = true
        pdfImageView.layer.cornerRadius = 3
    }
    
    //Methods
    func setupCell(data: ModelPDF, indexPath: IndexPath, presentOnVC: SheetViewControllerDelegate) {
        self.indexPath = indexPath
        self.presentinOnVC = presentOnVC
        
        pdfImageView.image = UIImageView.drawPDFfromData(data.pdfData)
        titleLabel.text = data.title
        dateLabel.text = data.date?.formatted(date: .abbreviated, time: .omitted)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        pdfImageView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(pdfImageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(moreButton)
        

        NSLayoutConstraint.activate([
            pdfImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            pdfImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            pdfImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            pdfImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height / 2)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            titleLabel.topAnchor.constraint(equalTo: pdfImageView.bottomAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            titleLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -2)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        moreButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        moreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
    }
    
    //Actions
    @objc private func openSheet() {
       guard let presentinOnVC = presentinOnVC else { return }
       
       let sheetViewController = SheetViewController()
       sheetViewController.delegate = presentinOnVC
       if let sheetController = sheetViewController.sheetPresentationController {
           sheetController.detents = [.medium(), .large()]
           sheetViewController.indexPath = indexPath
           sheetController.preferredCornerRadius = 4
           sheetController.prefersGrabberVisible = true
       }
       presentinOnVC.present(sheetViewController, animated: true, completion: nil)
   }
}
