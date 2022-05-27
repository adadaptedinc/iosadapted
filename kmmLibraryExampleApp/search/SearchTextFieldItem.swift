import UIKit

class SearchTextFieldItem {
    var attributedTitle: NSMutableAttributedString?
    var attributedSubtitle: NSMutableAttributedString?
    var title: String
    var subtitle: String?
    var image: UIImage?
    var isSponsored: Bool = false

    init(title: String) {
        self.title = title
    }

    init(title: String, subtitle: String?) {
        self.title = title
        self.subtitle = subtitle
    }

    init(title: String, subtitle: String?, image: UIImage?) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
}
