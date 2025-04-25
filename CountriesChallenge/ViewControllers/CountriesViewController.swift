//
//  CountriesViewController.swift
//  CountriesChallenge
//

import Combine
import UIKit

class CountriesViewController: UIViewController {
    private let viewModel: CountriesViewModel

    init(viewModel: CountriesViewModel = CountriesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        title = "Countries"
        tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.identifier)
        searchController.hidesNavigationBarDuringPresentation = true
        
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("Use init(viewModel:) instead.")
    }

    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.attributedTitle = NSAttributedString(string: "Pull to refresh")
        control.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        return control
    }()

    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    private var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }

    private var countries: [Country] {
        if isFiltering {
            return filteredCountries
        }
        return viewModel.countriesSubject.value
    }

    private var filteredCountries: [Country] = []

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.addSubview(refreshControl)
        return view
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        return searchController
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .large
        return view
    }()

    private var tasks = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        activityIndicator.startAnimating()
        setupSubscribers()
        viewModel.refreshCountries()
    }

    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            activityIndicator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc private func refresh(_ sender: AnyObject) {
        viewModel.refreshCountries()
    }

    private func setupSubscribers() {
        viewModel.countriesSubject
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }.store(in: &tasks)

        viewModel.errorSubject
        .receive(on: DispatchQueue.main)
        .sink { [weak self] error in
            guard let self = self, let error = error else { return }
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                self.activityIndicator.startAnimating()
                self.viewModel.refreshCountries()
            })
            self.present(alert, animated: true)
        }.store(in: &tasks)
    }
}

extension CountriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.identifier, for: indexPath) as? CountryCell else {
            return UITableViewCell()
        }
        cell.configure(country: countries[indexPath.row])
        return cell
    }
}

extension CountriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = CountryDetailViewController(country: countries[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: false)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension CountriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredCountries = countries.filter {
            isSearchBarEmpty ||
            $0.name.lowercased().contains(searchText) ||
            $0.capital.lowercased().contains(searchText)
        }
        tableView.reloadData()
    }
}
#if DEBUG
extension CountriesViewController {
    var test_isFiltering: Bool {
        return isFiltering
    }
}
#endif
