task :default => [:server]

task :generate do
  sh "jekyll"
end

task :server do
  sh "jekyll serve --watch "
end

task :deploy => [:generate] do
  sh "rsync -av --rsh='ssh -p 2683' _site/ dlimiter@dlimiter.net:public_html/"
end

task :deploy_to_test => [:generate] do
  sh "rsync -av --rsh='ssh -p 2683' _site/ dlimiter@dlimiter.net:public_html/test/"
end
