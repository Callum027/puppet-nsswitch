
class nsswitch::config {

  $module_type = $nsswitch::module_type
    
  file { $nsswitch::params::config:
    ensure  => present,
    owner   => $nsswitch::params::owner,
    group   => $nsswitch::params::group,
    mode    => 0644,
    content => template("nsswitch/nsswitch.conf.erb")
  }
    
  case $::operatingsystem {
    /(?i:Redhat|CentOS|Debian|Ubuntu)/: {
      if ($module_type == 'ldap') {
        file { '/etc/nslcd.conf':
          ensure  => present,
          owner   => 'root',
          group   => 'root',
          mode    => 0640,
          content => template("nsswitch/nslcd.conf.erb"),
          notify  => Service[$nsswitch::params::service],
          require => Package[$nsswitch::params::service_pkg],
        }
      } elsif ($module_type == 'none') {
        file { '/etc/nslcd.conf':
          ensure => absent,
          notify => Service[$nsswitch::params::service],
        }
      }
    }

    /(?i:OpenSuSE|SLES)/: {
      if($module_type == 'ldap') {
        Class['ldap'] -> Class['nsswitch']
      }
    }
  }
}

