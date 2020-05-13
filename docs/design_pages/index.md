# SSSD feature design pages

A design of every major change to the SSSD codebase should be discussed before implementing the code. A design page helps other developers, who will be later reviewing the code understand how the change helps the SSSD, the scope of the changes and how the change would be tested.

## Blank template

When writing a design page, please start from the blank template.

<div class="toctree">

blank_template

</div>

## Implemented in 2.0.x

<div class="toctree">

certmaps_for_LDAP_AD_file smartcard_authentication_require prompting_configuration

</div>

## Implemented in 1.16.x

<div class="toctree">

kdcinfo_multiple_servers auto_private_groups hybrid_private_groups uid_negative_global_catalog smartcard_multiple_certificates enhanced_nss_api attestation_report kdcinfo_improvements posix_attrs_detection chpass_without_exop.rst

</div>

## Implemented in 1.15.x

<div class="toctree">

matching_and_mapping_certificates subdomain_configuration kcm non_posix_support shortnames systemd_activatable_responders fleet_commander_integration files_provider smartcard_authentication_pkinit smartcards_and_multiple_identities socket_activatable_responders

</div>

## Implemented in 1.14.x

<div class="toctree">

config_check_tool config_enhancements data_provider libini_config_file_checks lookup_users_by_certificate_part2 one_fourteen_performance_improvements prompting_for_multiple_authentication_types secrets_service sssctl sudo_caching_rules_invalidate sysdb_fully_qualified_names

</div>

## Implemented in 1.13.x

<div class="toctree">

cached_authentication dbus_cached_objects dbus_domains dbus_multiplier_interfaces dbus_users_and_groups ddns_messages_update idmap_auto_assign_new_slices lookup_users_by_certificate one_way_trusts otp_related_improvements pam_conversation_for_otp smartcards smartcard_authentication_step1 smartcard_authentication_testing_with_ad sudo_ipa_schema use_ad_homedir wildcard_refresh

</div>

## Implemented in 1.12.x

<div class="toctree">

active_directory_fixed_dns_site active_directory_gpo_integration cwrap_ldap dbus_responder dbus_simple_api integrate_sssd_with_cifs_client kerberos_principal_mapping_to_proxy_users not_root_sssd nss_responder_id_mapping_calls nss_with_kerberos_principal open_lmi_provider restrict_domains_in_pam rpc_idmapd_plugin

</div>

## Implemented in 1.11.x

<div class="toctree">

active_directory_access_control ipa_server_mode

</div>

## Implemented in 1.10.x

<div class="toctree">

active_directory_dns_sites active_directory_dns_updates global_catalog_lookups periodical_refresh_of_expired_entries periodic_tasks recognize_trusted_domains_in_ad_provider

</div>

## Implemented in 1.9.x

<div class="toctree">

fast_nss_cache local_group_members_for_rfc2307 subdomains sudo_caching_rules sudo_integration_new_approach sudo_responder_cache_behaviour sudo_support

</div>

## Implemented in 1.8.x

<div class="toctree">

autofs_integration multiple_search_bases

</div>

## Not implemented

<div class="toctree">

accounts_service async_winbind dbus_signal_property_changed kerberos_locator_redesign ldap_referrals member_of_v1 member_of_v2 one_fifteen_code_refactoring sockets_for_domains sssd_two_point_oh sudo_integration sudo_support_plugin_wire_protocol usr_account_mgmt_consolidation

</div>

## Assorted old (pre-1.8) design documents

<div class="toctree">

backend_dns_helpers netgroups sigchld

</div>
