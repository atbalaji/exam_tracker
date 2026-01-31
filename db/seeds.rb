# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

ssc = Exam.find_or_create_by!(name: "SSC CGL")

sections = [
  "Quant",
  "Reasoning",
  "English",
  "General Awareness"
]

sections.each do |sec_name|
  Section.find_or_create_by!(
    exam: ssc,
    name: sec_name
  )
end

User.find_or_create_by!(name: "Default User", email: "default@example.com")
