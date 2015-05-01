class Venue < ActiveRecord::Base
  def self._sync_columns; []; end      
  def _sync_columns; Venue._sync_columns; end  
  include DirtyColumns
  has_many :events  
end


