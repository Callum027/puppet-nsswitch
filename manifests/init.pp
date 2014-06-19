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
	$module_type = 'none',
	$ensure      = 'present',
	
	$threads,
	$uid,
	$gid,

	$uri         = false,
	$base        = false,
	$ldap_version,
	$binddn,
	$bindpw,
	$rootpwmoddn,
	$rootpwmodpw,
	
	$sasl_mech,
	$sasl_realm,
	$sasl_authcid,
	$sasl_authzid,
	
	$sasl_secprops,
	$sasl_canonicalize,
	
	$krb5_ccname,
	
	$base,
	$scope,
	$deref,
	$referrals,
	$filter,
	$map,
	
	$bind_timelimit,
	$timelimit,
	$idle_timelimit,
	$reconnect_sleeptime,
	$reconnect_retrytime,
	
	$ssl,
	$tls_reqcert,
	$tls_cacertdir,
	$tls_cacertfile,
	$tls_randfile,
	$tls_cipher,
	$tls_cert,
	$tls_key,
	
	$pagesize,
	$nss_initgroups_ignoreusers,
	$nss_min_uid,
	$validnames,
	$ignorecase,
	$pam_authz_search,
	$pam_password_prohibit_message) {

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
