#!/usr/bin/env ruby
require 'bundler/setup'
require 'web_push'

vapid_key = WebPush.generate_key

puts "\n=== VAPID Keys Generated ==="
puts "\nAdd these to your Rails credentials:"
puts "rails credentials:edit"
puts "\nweb_push:"
puts "  vapid_public_key: #{vapid_key.public_key}"
puts "  vapid_private_key: #{vapid_key.private_key}"
puts "  contact_email: your-email@example.com"
puts "\n==========================="
