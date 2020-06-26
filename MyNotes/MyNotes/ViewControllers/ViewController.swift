//
//  ViewController.swift
//  MyNotes
//
//  Created by Pace Wisdom on 23/06/20.
//  Copyright © 2020 Pace Wisdom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var myNotesTable: UITableView!
    
    var notes = [Note](){
        
        didSet {
            
            DispatchQueue.main.async {
            
                self.myNotesTable.reloadData()
            }
        }
    }
    
    var filterNotes = [Note]()
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.ConfigureUI()
                
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.filterNotes.removeAll()
        
        notes.removeAll()
    
       let dataBaseResults = CoreDataManager.shared.FetchMyNotes()
        
        for element in dataBaseResults {
            notes.append(Note(title: element.title, description: element.body, imageData: element.attachment, isSelected: element.isSelected))
        }
        
        self.filterNotes = notes
        
        DispatchQueue.main.async {
        
            self.myNotesTable.reloadData()
        }
        
    }
 
    @IBAction func didTapAdd() {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddViewController") as? AddViewController
        
        vc!.title = "Add New Note"
        vc!.navigationItem.largeTitleDisplayMode = .never
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }

    @IBAction func selectionBtnActn(_ sender: UIButton) {
        
        print(sender.tag)
        
        if(sender.currentImage == #imageLiteral(resourceName: "uncheck")){
            
            notes[sender.tag].isSelected = true
            
            notes = rearrange(array: notes, fromIndex: sender.tag, toIndex:notes.count - 1)
            
            CoreDataManager.shared.UpdateSelection(index: sender.tag, isSelected: true)
            
            CoreDataManager.shared.RearrangeCoreDataList(index: sender.tag, isSelected: true)
            
        }
        
        
    }
    
    func ConfigureUI() {
        
         self.navigationItem.searchController = searchController
               
               searchController.searchBar.delegate = self
               
              self.myNotesTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
              
              myNotesTable.delegate = self
              
              myNotesTable.dataSource = self
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        notes.removeAll()
        
        if searchText.isEmpty {
                            
            self.notes = self.filterNotes
            
            return
        }
                
        for currencyCode in self.filterNotes {
                            
            let range = currencyCode.title!.lowercased().range(of: searchText, options: .caseInsensitive, range: nil, locale: nil)
                
                if range != nil {
                    
                    self.notes.append(currencyCode)
                }
            
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.notes = self.filterNotes
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell
                
        cell.selectionBtn.tag = indexPath.row
        
        cell.attachmentImg.layer.cornerRadius = 10
        
        if(self.notes[indexPath.row].isSelected!){
            
            cell.backgroundColor = UIColor.lightGray
        }
        else{
            cell.backgroundColor = UIColor.clear

        }
        
        
        if let data = self.notes[indexPath.row].imageData {
            
            DispatchQueue.main.async {
                
                cell.attachmentImg.image = UIImage(data: data)
                
            }
        }
        else{
            
            DispatchQueue.main.async {
                cell.attachmentImg.image = nil
                
            }
        }
        
        DispatchQueue.main.async {
            
            cell.titleLbl.text = self.notes[indexPath.row].title
            
            cell.descriptionLbl.text = self.notes[indexPath.row].description
            
            if(self.notes[indexPath.row].isSelected!){
                
                cell.selectionBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            }
            else{
                
                cell.selectionBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            }
            
            
        }
        
        return cell
        
    }
  
}

func rearrange(array: [Note], fromIndex: Int, toIndex: Int) -> [Note]{
    var arr = array
    let element = arr.remove(at: fromIndex)
    arr.insert(element, at: toIndex)

    return arr
}

extension UIImage {
    func upOrientationImage() -> UIImage? {
        switch imageOrientation {
        case .up:
            return self
        default:
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(in: CGRect(origin: .zero, size: size))
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result
        }
    }
}
