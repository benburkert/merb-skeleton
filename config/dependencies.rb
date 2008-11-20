dependency "compass",      "0.1.0"  # From: http://github.com/chriseppstein/compass/
dependency "haml",         "2.1.0"  # From: http://github.com/nex3/haml/
dependency "ParseTree",    "3.0.2", :require_as => "parse_tree"
dependency "ruby2ruby",    "1.2.1"
dependency "ruby-openid",  "2.1.2", :require_as => "openid"
dependency "rack-cache",   "0.2.0", :require_as => "rack/cache"
dependency "system_timer", "1.0"
dependency "webrat",       "0.3.2"

# dependencies are generated using a strict version, don't forget to edit the dependency versions when upgrading.
merb_gems_version = "1.0.1"
dm_gems_version   = "0.9.7"

# For more information about each component, please read http://wiki.merbivore.com/faqs/merb_components
dependency "merb-action-args", merb_gems_version
dependency "merb-assets", merb_gems_version
#dependency "merb-cache", merb_gems_version
dependency "merb-haml", merb_gems_version
dependency "merb-helpers", merb_gems_version
#dependency "merb-mailer", merb_gems_version
dependency "merb-slices", merb_gems_version
dependency "merb-auth-core", merb_gems_version
dependency "merb-auth-more", merb_gems_version
dependency "merb-auth-slice-password", merb_gems_version
dependency "merb-param-protection", merb_gems_version
dependency "merb-exceptions", merb_gems_version

dependency "dm-core", dm_gems_version
#dependency "dm-aggregates", dm_gems_version
dependency "dm-constraints", dm_gems_version
#dependency "dm-migrations", dm_gems_version
#dependency "dm-timestamps", dm_gems_version
#dependency "dm-types", dm_gems_version
dependency "dm-validations", dm_gems_version
