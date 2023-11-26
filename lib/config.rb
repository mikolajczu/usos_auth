# FIXME: Here documentation for Configuration file

module UsosAuth
  class Configuration
    def self.load_config
      config_path = File.join(File.dirname(__FILE__), "../../config/usos_auth.yml")

      YAML.safe_load(File.read(config_path))
    end
  end
end
