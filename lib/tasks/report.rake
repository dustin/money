namespace :test do
  namespace :report do
    task :rcov_units_params do
        RCOV_PARAMS = ENV['RCOV_PARAMS'] = "--sort=name"
        SHOW_ONLY = ENV['SHOW_ONLY'] = "app/models|lib"  
    end
    task :rcov_functionals_params do
      RCOV_PARAMS = ENV['RCOV_PARAMS'] = "--sort=name"
      SHOW_ONLY = ENV['SHOW_ONLY'] = "app/controllers|app/helpers"
    end
    desc 'Measures test coverage'
    task :coverage => [ 'test:units:rcov', 'test:functionals:rcov' ] 
  end
end

namespace :test do
  namespace :units do
    task :rcov => ['test:report:rcov_units_params']
  end
  namespace :functionals do
    task :rcov => ['test:report:rcov_functionals_params']
  end
end
  
