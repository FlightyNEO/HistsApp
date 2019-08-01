//
//  GistsListViewController.swift
//  HistsApp
//
//  Created by Arkadiy Grigoryanc on 31.07.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import UIKit

class GistsListViewController: UITableViewController {
    
    private var gists = (private: Gists(), public: Gists())
    private var gistType: GistType = .public
    private var networkManager = NetworkManager.manager
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGists {
            self.gists.private.sort()
            self.gists.public.sort()
            DispatchQueue.main.async { [weak self] in
                self?.updateUI()
                let gistFile = GistPost(information: "Information", files: ["File1": "Description1", "File2": "Description2"], isPublic: true)
                self?.networkManager.createGist(gistFile) { result in
                    
                    switch result {
                    case .success(_): print("!!!")
                    case .failure(let error): print(error.localizedDescription)
                    }
                    
                }
            }
        }
    }
    
    // MARK: - Private methods
    private func loadGists(completion: @escaping () -> Swift.Void) {
        networkManager.fetchGists(type: .public) { result in
            switch result {
            case .success(let gists):
                
                self.gists = gists.reduce(into: self.gists) {
                    if $1.isPublic {
                        $0.public.append($1)
                    } else {
                        $0.private.append($1)
                    }
                }
                
                completion()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadImage(urlString: String, completion: @escaping (Data?) -> Swift.Void) {
        networkManager.fetchImage(urlString: urlString) { result in
            if case .success(let data) = result {
                completion(data)
            } else {
                completion(nil)
            }
        }
    }
    
    private func updateUI() {
        self.tableView.reloadData()
    }
    
    private func updateCell(with indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    private func filling(cell: UITableViewCell, indexPath: IndexPath, with gist: Gist) {
        cell.textLabel?.text = gist.shrotDateString
        cell.detailTextLabel?.text = "\(gist.countOfComments) comments"
        if let dataImage = gist.owner.dataImage {
            cell.imageView?.image = UIImage(data: dataImage)
        }
    }
    
    @IBAction func actionChangeGistType(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: gistType = .public
        case 1: gistType = .all
        default: break
        }
        updateUI()
    }
    
}

// MARK: - Table view data source & Table view delegate
extension GistsListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return gistType == .public ? 1 : 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? gists.public.count : gists.private.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gistCell", for: indexPath)
        
        let gist = indexPath.section == 0 ? gists.public[indexPath.row] : gists.private[indexPath.row]
        filling(cell: cell, indexPath: indexPath, with: gist)
        
        if gist.owner.dataImage == nil {
            loadImage(urlString: gist.owner.avatarStringUrl) { imageData in
                gist.owner.dataImage = imageData
                DispatchQueue.main.async { [weak self] in
                    self?.updateCell(with: indexPath)
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Public gists" : "Private gists"
    }

}
