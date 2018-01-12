Pod::Spec.new do |s|
	# info
	s.name			= 'CompoundFetchedResultsController'
	s.version		= '1.0.1'
	s.summary		= 'Fetched results controller wrapper that allows joining multiple FRCs'
	s.description	= 'This framework provides fetched results controller subclasses for static data and joining multiple FRCs together into one.'
	s.homepage		= 'https://github.com/djbe/CompoundFetchedResultsController'
	s.license		= 'MIT'
	s.author		= { 'David Jennes' => 'david.jennes@gmail.com' }
	
	# configuration
	s.platform		= :ios, '8.0'
	s.swift_version = '4.0'
	
	# files
	s.frameworks	= 'Foundation', 'CoreData'
	s.source		= { :git => 'https://github.com/djbe/CompoundFetchedResultsController.git', :tag => "#{s.version}" }
	s.source_files	= 'Source/*.{swift}'
end
