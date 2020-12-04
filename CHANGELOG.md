# Changelog

All notable changes to this project will be documented in this file.  
Type of changes can be `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`.

## [1.0.1] - 2020-12-04

### Fixed

- Fixed issue where /etc/resolv.conf wasn't updated properly making all DNS lookups fail
- Added explicit listen directive in unbound for IPv6 address

### Changed

- Increased unbound cache memory usage by tweaking parameter unbound_rrset_cache_mb in playbook

## [1.0.0] - 2020-12-02

### Added

- Initial version of automated AhaDNS DNS server setup
- A CHANGELOG file to this project
- Initial version of a PR template
