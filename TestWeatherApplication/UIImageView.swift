
import ReactiveSwift
import Kingfisher
import UIKit

extension Reactive where Base: UIImageView {
    public var url: BindingTarget<URL?> {
        return makeBindingTarget { $0.kf.setImage(with: $1)}
    }
}
