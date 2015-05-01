class Election < ActiveRecord::Base
  def self._sync_columns; []; end      
  def _sync_columns; Election._sync_columns; end  
  include DirtyColumns
  has_one :campaigns
end
