//
//  ViewController.swift
//  DeftPDF
//
//  Created by Alexandr Ananchenko on 04.07.2022.
//

import UIKit
import UniformTypeIdentifiers

class ViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<SectionsPDF, ModelPDF>
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private let searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.showsCancelButton = false
        
        return searchBar
    }()
    
    lazy var dataSource = makeDataSource()
    private var isFiltering = false
    private  var data: [ModelPDF] = UserDefaultsManager.shared.getPDF()
    private var filteredData = [ModelPDF]()
 
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        navigationItem.titleView = searchBar
//        searchBar.setValue("New Title", forKey: "cancelButtonText")
        setupCollectionView()
        applySnapshot(items: data)
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPDF))
        navigationItem.rightBarButtonItem = barButton
    }

    //Methods
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (view.frame.size.width / 3) - 15, height: view.frame.size.width / 1.9)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = .init(top: 20, left: 15, bottom: 20, right: 15)
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }

    //Objc
    @objc func dismissSearchBar() {
        searchBar.resignFirstResponder()
    }
    
    @objc func addPDF() {
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf], asCopy: true)
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .fullScreen
        
        present(documentPicker, animated: true, completion: nil)
        
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isFiltering {
            let pdfData = filteredData[indexPath.item].pdfData
            let vc = DetailsPDFVC(pdfData: pdfData)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let pdfData = data[indexPath.item].pdfData
            let vc = DetailsPDFVC(pdfData: pdfData)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

//MARK: - UIDocumentPickerDelegate
extension ViewController: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFilesURL = urls.first else { return }
        guard let data = try? Data(contentsOf: selectedFilesURL) else { return }

        let attr = try? FileManager.default.attributesOfItem(atPath: selectedFilesURL.path)
        let date = attr?[FileAttributeKey.creationDate] as? Date
        
        var pdfFileName = selectedFilesURL.lastPathComponent
        if let index = pdfFileName.range(of: ".")?.lowerBound {
            let substring = pdfFileName[..<index]
            pdfFileName = String(substring)
        }
        
        let pdfModel = ModelPDF(pdfData: data, date: date, title: pdfFileName)
        UserDefaultsManager.shared.savePDF(data: pdfModel)
        self.inserItem(pdfModel)
        self.data.insert(pdfModel, at: 0)
        
        controller.dismiss(animated: true)
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
}

//MARK: Data Source
 extension ViewController {
     func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let section = SectionsPDF.allCases[indexPath.section]

            switch section {
            case .main:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
                cell.setupCell(data: itemIdentifier, indexPath: indexPath, presentOnVC: self)
                return cell
            }
        }
        return dataSource
    }

     func applySnapshot(items: [ModelPDF]) {
        var snapshot = dataSource.snapshot()
   
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
     
     func replaceItems(_ items: [ModelPDF]) {
         var snapshot = dataSource.snapshot()
         snapshot.deleteItems(self.data)
         snapshot.appendItems(items)
         dataSource.apply(snapshot)
     }
     func inserItem(_ item: ModelPDF) {
         var snapshot = dataSource.snapshot()
         if let firstItem = data.first {
             snapshot.insertItems([item], beforeItem: firstItem)
         } else {
             snapshot.appendItems([item])             
         }
         dataSource.apply(snapshot, animatingDifferences: true)
     }
     
     func deleteItem(_ item: ModelPDF) {
         var snapshot = dataSource.snapshot()
         snapshot.deleteItems([item])
         dataSource.apply(snapshot, animatingDifferences: true)
     }
}

//MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func filterContentForSearchText(_ searchText: String) {
        filteredData = data.filter {(data: ModelPDF) -> Bool in
            return data.title.lowercased().contains(searchText.lowercased())
        }
        if !searchText.isEmpty {
            replaceItems(filteredData)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isFiltering = true
        if searchText.isEmpty {
            replaceItems(data)
        } else {
            filterContentForSearchText(searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFiltering = false
        replaceItems(data)
        searchBar.text = nil
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
}

//MARK: - SheetViewControllerDelegate
extension ViewController: SheetViewControllerDelegate {
    func deleteItem(indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        let item = data[indexPath.item]
        self.deleteItem(item)
        UserDefaultsManager.shared.removePDF(data: item)
        
    }

}
