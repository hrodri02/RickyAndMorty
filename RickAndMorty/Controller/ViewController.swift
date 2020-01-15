//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Eri on 1/7/20.
//  Copyright © 2020 Eri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var info: Info?
    var characters = [RickAndMortyCharacter]() {
        didSet {
            if isViewLoaded {
                tableView.reloadData()
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CharacterTVCell.self, forCellReuseIdentifier: "cellId")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.black
        
        addSubviews()
        setupUIComponents()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupUIComponents() {
        setupTableView()
    }
    
    private func setupTableView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
            ])
    }
    
    private func loadMoreItems() {
        if let metaData = info {
            Network.loadJSONData(from: metaData.next, type: RickAndMortyCharacters.self, metaDataType: Metadata.self) { (characters, metaData, error) in
                if let rickAndMortyCharacters = characters?.results {
                    self.characters.append(contentsOf: rickAndMortyCharacters)
                    self.info = metaData?.info
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CharacterTVCell
        let character = characters[indexPath.row]
        
        cell.nameLabel.text = character.name
        cell.dateLabel.text = character.created.getDateAsString(format: "MMM d, h:mm a")
        
        ImageRetrieverService.shared.downloadImage(from: character.image) { (image) in
            cell.characterImageView.image = image
            cell.setNeedsLayout()
        }
        
        if indexPath.row == characters.count - 1 {
            loadMoreItems()
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
