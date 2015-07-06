maintainer       "Qubell Inc."
maintainer_email "abutovich@qubell.com"
license          "All rights reserved"
name		 "cookbook_qubell_jenkins"
description      "Provision Jenkins CI"
version          "0.1.6"

depends "java", "= 1.31.0" 
depends "openssl", "4.1.1"
depends 'jenkins', '= 2.3.1'
depends 'windows', '= 1.37.0'
