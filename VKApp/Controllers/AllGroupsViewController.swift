//
//  AllGroupsViewController.swift
//  VKApp
//
//  Created by Denis Kuzmin on 16.04.2021.
//

import UIKit

class AllGroupsViewController: UIViewController, UITableViewDelegate {

    struct Section {
        var sectionName: Character
        var rows: [Int]
    }
    @IBOutlet weak var tableHeader: UIView!
    
    @IBOutlet weak var groupsTable: UITableView!
    
    var foundedGroups = [VKRealmGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGroups()
        groupsTable.keyboardDismissMode = .onDrag


    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if groupsTable.contentOffset.y < 0 {
            UIView.animate(withDuration: 0.25, animations: { [self] in
              groupsTable.contentInset.top = 0
            })
        } else if groupsTable.contentOffset.y > tableHeader.frame.height {
            UIView.animate(withDuration: 0.25, animations: { [self] in
                groupsTable.contentInset.top = -1 * tableHeader.frame.height
            })
          }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func getGroups() {
        
    }
    
    
    //Увеличиваем размер TableView при появлении клавиатуры
    @objc private func keyboardWasShown(notification: Notification) {
        
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as!   NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height - view.safeAreaInsets.bottom, right: 0.0)
        
        groupsTable.contentInset = contentInsets
        groupsTable.scrollIndicatorInsets = contentInsets
    }
    
    
    //Уменьшаем обратно ScrollView при исчезновении клавиатуры
    @objc private func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу TableView, равный 0
        let contentInsets = UIEdgeInsets.zero
        groupsTable.contentInset = contentInsets
    }
    
    
    
}

extension AllGroupsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return foundedGroups.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell
        else { return UITableViewCell() }
        cell.config(name: foundedGroups[indexPath.row].name,
                    avatarUrlString: foundedGroups[indexPath.row].photo200UrlString,
                    description: foundedGroups[indexPath.row].screenName)

        return cell
    }
    
    
}

extension AllGroupsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        NetworkService.searchGroups(by: searchText, resultsCount: 100) { [weak self] groups in
            self?.foundedGroups = groups
            self?.groupsTable.reloadData()
        }
        
    }
    /*func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchtext = searchBar.text else { return }
        //filterRows(by: searchtext)
        NetworkService.searchGroups(by: searchtext, resultsCount: 10) { [weak self] groups in
            groups.forEach { group in
                self?.firestore
                    .collection("users")
                    .document(String(Session.Instance.userId))
                    .collection(searchtext)
                    .document(String(group.id))
                    .setData(["name": group.name,
                              "screenName": group.screenName,],
                             merge: false) { error in
                                if let error = error {
                                    print("Error saving database: \(error.localizedDescription)")
                                }
                                else {
                                    print("Succesfully save search result to Firestore")
                                }
                            }
            }
            
            
        }
    }*/
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
     }
    
    
}
