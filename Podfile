platform :ios, '13.0'

def reactive
  pod 'RxSwift', '6.1.0'
  pod 'RxCocoa', '6.1.0'
end

def utilities
  pod 'Kingfisher', '6.3.0'
  pod 'ReachabilitySwift', '5.0.0'
end

target 'GithubUsers' do
  use_frameworks!

  reactive
  utilities
  
  inhibit_all_warnings!
  target 'GithubUsersTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GithubUsersUITests' do
    # Pods for testing
  end

end
