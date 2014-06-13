maintainer       "Qubell Inc."
maintainer_email "abutovich@qubell.com"
license          "All rights reserved"
description      "Provision Jenkins CI"
version          "0.1.0"

depends "apt", "1.1.1"
depends "java", "1.5.2"
depends "openssl", "1.1.1"
depends "chef-solo-search", "0.4.0"
depends 'runit', '>= 1.0.0'
depends 'jenkins', '= 1.2.2'
depends 'ohai', '= 1.1.12'
##depends        "nginx", "2.0.5"
