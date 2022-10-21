//
//  ViewController.swift
//  Core Data Example 2
//
//  Created by Никита Думкин on 21.10.2022.
//

import UIKit

class ViewController: UIViewController {
    let tableView = UITableView();
    let addNoteButton = UIButton();
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var dataSource = [NotesCoreData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    }
    
    private func setupView(){
        self.view.backgroundColor = .systemGray6
        
        setupAddNoteButton()
        setupTableView()
        fetchNotes()
    }
    
    private func setupAddNoteButton(){
        addNoteButton.backgroundColor = .white
        addNoteButton.layer.borderColor = CGColor(red: 0.1, green: 0.3, blue: 0.3, alpha: 1)
        addNoteButton.layer.borderWidth = CGFloat(2)
        addNoteButton.layer.cornerRadius = CGFloat(10)
        addNoteButton.setTitle("+", for: .normal)
        addNoteButton.setTitleColor(.systemBlue, for: .normal)
        addNoteButton.addTarget(self, action:#selector(addNoteButtonTapped(_:)) , for: .touchUpInside)
        addNoteButton.isEnabled = true
        
        self.view.addSubview(addNoteButton)
        print("button view")
        addNoteButton.setWidth(to: 40)
        addNoteButton.setHeight(to: 40)
        addNoteButton.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor)
        addNoteButton.pinRight(to: self.view, 20)
       
    }
    
    @objc
    private func addNoteButtonTapped(_ sender: UIButton){
        //MARK: Creating note
        let alert = UIAlertController(title: "Add note", message: "Your note", preferredStyle: .alert)
        alert.addTextField()
        
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            if let textField = alert.textFields?[0]{
                
                //new note creation
                let newNote = NotesCoreData(context: self.context)
                newNote.text = textField.text
                
                //data saving
                do{
                    try self.context.save()
                }
                catch{
                    
                }
                
                //re-fetching
                self.fetchNotes()
            }
        }
        
        alert.addAction(submitButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupTableView(){
        tableView.register(NoteCell.self , forCellReuseIdentifier: "cellId")
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        print("table view")
        view.addSubview(tableView)
        tableView.pin(to: self.view, [.right, .left, .bottom])
        tableView.pinTop(to: addNoteButton.bottomAnchor, 20)
    }

    private func fetchNotes(){
        //MARK: Reading notes
        
        //fetching
        do{
            self.dataSource = try context.fetch(NotesCoreData.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            
        }
    }

}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
            let deleteAction = UIContextualAction(style: .destructive, title: .none){
                [weak self] (action, view, completion) in
                self?.handleDelete(indexPath: indexPath)
                completion(true)
            }
            deleteAction.image = UIImage(systemName: "trash.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))?.withTintColor(.white)
            deleteAction.backgroundColor = .red
            return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MARK: Updating note
        let noteToChange = self.dataSource[indexPath.row]
        
        let alert = UIAlertController(title: "Edit note", message: "Edit text:", preferredStyle: .alert)
        alert.addTextField()
        
        let textField = alert.textFields?[0]
        textField?.text = noteToChange.text
        
        
        let submitButton = UIAlertAction(title: "Save", style: .default) { (action) in
            if let textField = alert.textFields?[0]{
                
                //updating note's property
                noteToChange.text = textField.text
                
                //save the data
                do{
                    try self.context.save()
                }
                catch{
                    
                }
                
                //re-fetch
                self.fetchNotes()
            }
        }
        
        alert.addAction(submitButton)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        default:
            let note = dataSource[indexPath.row]
            if let noteCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? NoteCell {
                noteCell.configure(note)
                return noteCell
            }
        }
        
        return UITableViewCell()
    }
    
    private func handleDelete(indexPath: IndexPath){
        //MARK: Deleting note
        
        //note deleting
        let noteToDelete = self.dataSource[indexPath.row]
        self.context.delete(noteToDelete)
        
        //data saving
        do{
            try context.save()
        }
        catch{
            
        }
        
        //re-fetching
        fetchNotes()
    }
}

