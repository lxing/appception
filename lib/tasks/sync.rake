task :sync => :environment do
  App.find_each do |app|
    puts "Synchronizing #{app.name}"
    market_app = AndroidMarketApplication.new(app.google_id)
    continue if market_app.nil?

    app.update_attributes({
      :name => market_app.name.present? ? market_app.name : app.name,
      :icon => market_app.icon.present? ? market_app.icon : app.icon,
      :description => market_app.description.present? ? market_app.description : app.description
    })
  end
  puts "Done."
end