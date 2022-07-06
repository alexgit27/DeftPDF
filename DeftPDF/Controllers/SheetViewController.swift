//
//  SheetViewController.swift
//  DeftPDF
//
//  Created by Alexandr Ananchenko on 05.07.2022.
//

import UIKit


protocol SheetViewControllerDelegate: UIViewController {
    func deleteItem(indexPath: IndexPath?)
}

final class SheetViewController: UIViewController {
    enum ActionsEnum: String, CaseIterable {
        case edit = "Edit"
        case sign = "Sign"
        case convertTo = "Convert to"
        case share = "Share"
        case saveOnDevice = "Save on device"
        case saveInCloud = "Save in cloud"
        case rename = "Rename"
        case delete = "Delete"
    }
    enum ActionsSectionsEnum {
        case changeDocument
        case saveDocument
    }
    typealias DataSource = UITableViewDiffableDataSource<ActionsSectionsEnum, ActionsEnum>
    private lazy var dataSource = makeDataSource()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    weak var delegate: SheetViewControllerDelegate?
    var indexPath: IndexPath?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        applySnapshot(section: [.changeDocument], items: [.edit, .sign, .convertTo])
        applySnapshot(section: [.saveDocument], items: [.share, .saveOnDevice, .saveInCloud, .rename, .delete])
    }
    
    private func setupTableView() {
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
//        tableView.backgroundColor = .white.withAlphaComponent(0.5)
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    private func makeDataSource() -> DataSource {
       let dataSource = DataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
//           let section = SectionsPDF.allCases[indexPath.section]

//           switch section {
//           case .main:
               let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
               cell.setupCell(data: itemIdentifier)

               return cell
//           }
       }
       return dataSource
   }

    private func applySnapshot(section: [ActionsSectionsEnum], items: [ActionsEnum]) {
       var snapshot = dataSource.snapshot()
  
        snapshot.appendSections(section)
        snapshot.appendItems(items)
        
//       snapshot.appendSections([.changeDocument])
//       snapshot.appendItems(items, toSection: .changeDocument)
       dataSource.apply(snapshot, animatingDifferences: true)
   }
}

//MARK: - UITableViewDelegate
extension SheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 4 {
            delegate?.deleteItem(indexPath: self.indexPath)
            self.dismiss(animated: true)
        }
    }
}
