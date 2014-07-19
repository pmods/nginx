class nginx (
    $nginxconfsrc = '/root/etc/nginx/nginx.conf',
    $sslcert      = '/root/etc/nginx/ssl-cert.pem',
    $sslkey       = '/root/etc/nginx/ssl-key.pem',
    $sslca        = '/root/etc/nginx/ssl-ca.crt',
){

    $nginxconfdir = '/usr/local/etc/nginx/conf.d'

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

    file { 'nginx-confd':
        path   => $nginxconfdir,
        ensure => directory,
        owner  => 'root',
        group  => 'wheel',
    }

    file { 'nginx-cert':
        path    => '/usr/local/etc/nginx/ssl-cert.pem',
        ensure  => file,
        owner   => 'root',
        group   => 'wheel',
        source  => $sslcert,
        require => Package[$pkgname],
        notify  => Service[$servicename]
    }

    file { 'nginx-key':
        path    => '/usr/local/etc/nginx/ssl-key.pem',
        ensure  => file,
        owner   => 'root',
        group   => 'wheel',
        source  => $sslkey,
        require => Package[$pkgname],
        notify  => Service[$servicename]
    }

    file { 'nginx-ca':
        path    => '/usr/local/etc/nginx/ssl-ca.crt',
        ensure  => file,
        owner   => 'root',
        group   => 'wheel',
        source  => $sslca,
        require => Package[$pkgname],
        notify  => Service[$servicename]
    }

    service { $servicename:
        ensure => running,
        enable => true
    }
}
