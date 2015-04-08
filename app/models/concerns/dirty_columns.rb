module DirtyColumns
  extend ActiveSupport::Concern

  included do
    @sync_columns = self.columns.map(&:name) - ["id", "rwu_id", "created_at", "updated_at", "dirty"]
    
    include FlagShihTzu
    
    has_flags lambda {
      h = {}; i = 1
      @sync_columns.each do |col|
        h[i] = "#{col}_dirty".to_sym
        i += 1
      end
      h[:column] = 'dirty'
      h 
    }.call
        
    before_update :dirty_fields
  end
  
  private
  
  def dirty_fields
    (self.class.columns.map(&:name) - ["id", "rwu_id", "created_at", "updated_at", "dirty"]).each do |col|
      self.send("#{col}_dirty=", true) if self.send("#{col}_changed?")
    end
  end
end

