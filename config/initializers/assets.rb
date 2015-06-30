# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w(dou.html 404.html bixuange.js dou.js bixuange.css bixuange.html dou.css)
Rails.application.config.assets.paths << Rails.root.join('app/assets/html')
Rails.application.config.assets.register_mime_type('text/html', '.html')
# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
