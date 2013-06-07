I18n.default_locale = "en-CA"
I18n.load_path.sort! do |a,b| 
  if a =~ /en-CA.rb/ then 1
  elsif b =~ /en-CA.rb/ then -1
  else a <=> b
  end
end
