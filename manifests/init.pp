class nginx (
    $nginxconfsrc = '/root/etc/nginx/nginx.conf'
){

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

    file { 'nginx-conf':
        path   => '/usr/local/etc/nginx/nginx.conf',
        ensure => file,
        owner  => 'root',
        group  => 'wheel',
        source => $nginxconfsrc,
        notify => Service['nginx']
    }

    service { $servicename:
        ensure => running,
        enable => true
    }
}
