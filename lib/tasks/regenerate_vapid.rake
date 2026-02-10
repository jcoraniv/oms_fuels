namespace :vapid do
  desc "Regenerate VAPID keys"
  task regenerate: :environment do
    vapid_keys = WebPush.generate_key
    
    puts "\n=== New VAPID Keys Generated ==="
    puts "\nPublic Key:"
    puts vapid_keys.public_key
    puts "\nPrivate Key:"
    puts vapid_keys.private_key
    puts "\n=== Add these to your credentials ==="
    puts "\nRun: EDITOR='nano' rails credentials:edit -e production"
    puts "\nAdd:"
    puts "web_push:"
    puts "  vapid_public_key: #{vapid_keys.public_key}"
    puts "  vapid_private_key: #{vapid_keys.private_key}"
    puts "  contact_email: admin@omsfuels.com"
  end
end
