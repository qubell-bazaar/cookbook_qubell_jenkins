maintainer       "Qubell Inc."
maintainer_email "abutovich@qubell.com"
license          "All rights reserved"
description      "Provision Jenkins CI"
version          "0.1.3"

depends "apt", "1.1.1"
depends "java", "1.23.0"
depends "openssl", "1.1.1"
depends "chef-solo-search", "0.4.0"
depends 'runit', '>= 1.0.0'
depends 'jenkins', '= 1.2.2'
depends 'ohai', '= 1.1.12'
depends 'yum', '= 2.4.4'
depends 'windows', '= 1.30.2'
