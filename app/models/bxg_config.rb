class BxgConfig < Settingslogic
  source "#{Rails.root}/config/application.yml"
  namespace Rails.env
  load!
end
