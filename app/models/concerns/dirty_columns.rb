module DirtyColumns
  extend ActiveSupport::Concern
    
  included do
    include FlagShihTzu
    
    has_flags lambda {
      h = {}; i = 1
      _sync_columns.each do |col|
        h[i] = "#{col}_dirty".to_sym
        i += 1
      end
      h[:column] = 'dirty'
      h 
    }.call
  
    before_update :dirty_fields
  end

  SYNC = '_sync?'
  def method_missing(method, *args, &block)
    if method.to_s.ends_with?(SYNC)
      self._sync_columns.include?(method.to_s.sub(SYNC, '')) and !self.rwu_id.nil? and self.rwu_id > 0
    else
      super(method, *args, &block)
    end
  end
  
  def self._sync_columns
    raise "must be implemented by the class including this concern"
  end
  
  def sync_columns
    self._sync_columns
  end
  
  def clean_save!(updated_fields)
    transaction do
      self.save!
      updated_fields.each do |field|
        self.update_attribute("#{field}_dirty", false)
      end
    end
  end
  
  private
  
  def dirty_fields
    self._sync_columns.each do |col|
      self.send("#{col}_dirty=", true) if self.send("#{col}_changed?")
    end
  end  
end

