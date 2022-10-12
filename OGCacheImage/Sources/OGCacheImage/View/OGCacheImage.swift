import UIKit
import Combine

public class OGCacheImage: UIImageView {

    private var viewModel: OGCacheImageViewModel
    private var cancellableSet = Set<AnyCancellable>()

    init(viewModel: OGCacheImageViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        bind()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension OGCacheImage {
    func bind() {
        viewModel.onSetImage
            .sink { [weak self] image in
                self?.image = image
            }
            .store(in: &cancellableSet)
    }
}
