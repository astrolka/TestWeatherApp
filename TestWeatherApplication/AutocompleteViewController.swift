
import UIKit
import ReactiveCocoa
import ReactiveSwift

class AutocompleteViewController: UIViewController {
    
    var viewModel: AutocompleteViewModel!
    @IBOutlet fileprivate weak var textField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reactive.shouldReload <~ viewModel.reloadTableView
        viewModel.textSignal = textField.reactive.continuousTextValues
        textField.attributedPlaceholder = NSAttributedString(string: "City name...", attributes: [NSForegroundColorAttributeName : UIColor(white: 0.7, alpha: 1)])
        textField.becomeFirstResponder()
    }
    
    func bindViewModel(_ viewModel: AutocompleteViewModel) {
        self.viewModel = viewModel
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        textField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    

}

extension AutocompleteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = viewModel.cellViewModelForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutocompleteCell", for: indexPath)
        cell.textLabel?.text = vm?.location
        return cell
    }
}

extension AutocompleteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.addNewLocationObserver.send(value: indexPath)
        textField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
}
