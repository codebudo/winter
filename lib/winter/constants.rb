
#@wf_dir = File.dirname(File.expand_path File.dirname(__FILE__))
WINTERFELL_DIR = ENV['WINTERFELL_DIR'] || '.'
RUN_DIR = File.join(WINTERFELL_DIR,"run") || 'run'

SERVICES_DIR        = "services"
#RUN_DIR             = "run"
DEFAULT_CONF_DIR    = "defaults"
TEMPLATES_DIR       = "templates"
DAEMONTOOLS_DIR     = "/service"
OPT_BUNDLE_DIR      = "bundle.dir"
F_CONFIG_PROPERTIES = "config.properties"
F_SYSTEM_PROPERTIES = "system.properties"
F_LOGGER_PROPERTIES = "logger_bundle.properties"
F_LOG4J_PROPERTIES  = "log4j.properties"