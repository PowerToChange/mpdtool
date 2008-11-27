# Set the default place to find file_column files.
FILE_COLUMN_PREFIX = 'files'
module FileColumn
  module ClassMethods
    DEFAULT_OPTIONS[:root_path] = File.join(RAILS_ROOT, "public", FILE_COLUMN_PREFIX)
    DEFAULT_OPTIONS[:web_root] = "#{FILE_COLUMN_PREFIX}/"
  end
end