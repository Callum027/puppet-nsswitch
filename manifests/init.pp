# = Class: nsswitch
#
# This class handles the configuration for nsswitch
#
# == Parameters:
#   TODO

# == Actions:
#   TODO

# == Requires:
#
# == Tested/works on:
#   - Debian untested
#   - RHEL   5.2   / 5.4   / 5.5   / 6.1   / 6.2
#   - OVS    2.1.1 / 2.1.5 / 2.2.0 / 3.0.2 /
#
# == Sample Usage:
#
# class { 'nsswitch':
# module_type => 'none',
#}
#
# class { 'nsswitch':
# module_type => 'ldap',
#}
#

class nsswitch (
	$module_type                   = 'none',
	$ensure                        = 'present',
	
	$threads                       = false,
	$uid                           = 'nslcd',
	$gid                           = $::operatingsystem ? {
		/(?i:Redhat|CentOS)/	=> 'ldap',
		default			=> 'nslcd',
	},

	$uri                           = false,
	$base                          = false,
	$ldap_version                  = false,
	$binddn                        = false,
	$bindpw                        = false,
	$rootpwmoddn                   = false,
	$rootpwmodpw                   = false,
	
	$sasl_mech                     = false,
	$sasl_realm                    = false,
	$sasl_authcid                  = false,
	$sasl_authzid                  = false,
	
	$sasl_secprops                 = false,
	$sasl_canonicalize             = false,
	
	$krb5_ccname                   = false,
	
	$base                          = false,
	$scope                         = false,
	$deref                         = false,
	$referrals                     = false,
	$filter                        = false,
	$map                           = false,
	
	$bind_timelimit                = false,
	$timelimit                     = false,
	$idle_timelimit                = false,
	$reconnect_sleeptime           = false,
	$reconnect_retrytime           = false,
	
	$ssl                           = false,
	$tls_reqcert                   = false,
	$tls_cacertdir                 = false,
	$tls_cacertfile                = false,
	$tls_randfile                  = false,
	$tls_cipher                    = false,
	$tls_cert                      = false,
	$tls_key                       = false,
	
	$pagesize                      = false,
	$nss_initgroups_ignoreusers    = false,
	$nss_min_uid                   = false,
	$validnames                    = false,
	$ignorecase                    = false,
	$pam_authz_search              = false,
	$pam_password_prohibit_message = false) {

	include nsswitch::params
	
	package { $nsswitch::params::package:
		ensure => $ensure
	}
	
	service { $nsswitch::params::service:
		ensure     => $module_type ? {
				'ldap'  => running,
				default => stopped,
				},
		enable     => $module_type ? {
				'ldap'  => true,
				default => false,
				},
		name       => $nsswitch::params::script,
		pattern    => $nsswitch::params::pattern,
		hasstatus  => true,
		hasrestart => true,
		subscribe  => File[$nsswitch::params::service_cfg],
		require    => Package[$nsswitch::params::package],
	}
	
	include nsswitch::config
}
