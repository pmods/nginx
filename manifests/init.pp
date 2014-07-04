class nginx {

    case $::operatingsystem {
        FreeBSD: {
            include pkgng

            $pkgname      = 'nginx'
            $servicename  = 'nginx'
            $pkg_provider = pkgng
        }
        default: {
            include pkgng

            $pkgname      = 'nginx'
            $servicename  = 'nginx'
            $pkg_provider = pkgng
        }
    }

    package { $pkgname:
        ensure => installed,
        provider => $pkg_provider
    }

    service { $servicename:
        ensure => running,
        enable => true
    }
}
