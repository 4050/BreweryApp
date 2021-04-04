//
//  ViewController.swift
//  BreweryApp
//
//  Created by Stanislav on 03.04.2021.
//

import UIKit

class ListBreweriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    private var safeArea: UILayoutGuide!
    
    private let breweryStorageModel: BreweryStorageModel
    private let beersGradesStorageModel: BeerGradeStorageModel
    
    private var requestBrewery = [ManagedBrewery?]()
    
    init(breweryStorageModel: BreweryStorageModel, beersGradesStorageModel: BeerGradeStorageModel) {
        self.breweryStorageModel = breweryStorageModel
        self.beersGradesStorageModel = beersGradesStorageModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        safeArea = view.layoutMarginsGuide
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "loadBreweries"), object: nil)
        setupTableView()
        setupNavigationItem()
        requestData()
    }
    
    func setupNavigationItem() {
        navigationItem.title = "Breweries"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBrewerie))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    @objc func loadList(notification: NSNotification) {
        requestData()
        tableView.reloadData()
    }
    
    @objc func addBrewerie() {
        let vc = UINavigationController(rootViewController: NewBreweryViewController(breweryStorageModel: breweryStorageModel))
        present(vc, animated: true)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.register(UINib(nibName: Constants.tabelViewCell, bundle: nil), forCellReuseIdentifier: Constants.reuseIdentifier)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestBrewery.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath) as! TableViewCell
        cell.titelLabel?.text = requestBrewery[indexPath.row]?.nameBrewery
        cell.descriptionLabel?.text = requestBrewery[indexPath.row]?.descriptionBrewery
        cell.breweriesImage.image = UIImage(data: (requestBrewery[indexPath.row]?.imageBrewery)!)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ListBeersGradesViewController(beersGradesStorageModel: beersGradesStorageModel)
        vc.modalPresentationStyle = .fullScreen
        let breweries = self.requestBrewery[indexPath.row]
        vc.breweries = breweries
        navigationController?.pushViewController(vc, animated: true)
      }
    
    func requestData() {
        requestBrewery = breweryStorageModel.getBreweries()
    } 
}

