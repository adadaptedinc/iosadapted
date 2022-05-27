import aa_multiplatform_lib

class AddToListItemCache {
    var items: LiveData<[AddToListItem]>?

    func setListItems(listItems: [AddToListItem]) {
        items?.value = listItems
    }
}

class LiveData<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func observe(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
