class App < ActiveRecord::Base
  validates :name, :presence => true
  validates :google_id, :presence => true, :uniqueness => true

  has_and_belongs_to_many :users

  def self.sync(google_id)
    return if App.exists?(:google_id => google_id)
    begin
      market_app = AndroidMarketApplication.new(google_id)
      app = App.new({
        :google_id => google_id,
        :name => market_app.name,
        :icon => market_app.icon,
        :description => market_app.description
      })
      return app.save ? app : nil
    rescue Exception => e
      return nil
    end
  end

end
