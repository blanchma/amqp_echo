require "cuba/render"
require "erb"

Cuba.plugin Cuba::Render
Cuba.settings[:render][:views] = "./app/views/"

class Admin < Cuba; end;

Admin.define do
  on get do
    on "admin" do
      puts "on admin"
      res.write view("admin")
    end
  end
end
