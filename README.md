# dns-server-setup

Ansible playbook to easily deploy new DNS servers.
This playbook is used to deploy all AhaDNS DNS server nodes.

## Intended usecase

This ansible playbook deploys a fully configured AhaDNS server instance (except securing SSH config) featuring:

- Blocking DNS server using [oisd](https://oisd.nl/) block list.
  - Block list automatically updated every 4 hours.
- [Unbound](https://nlnetlabs.nl/projects/unbound/about/) as recursive DNS server.
- DNS over HTTPS (DoH) using [NGINX](https://www.nginx.com/) and [m13253's DoH server](https://github.com/m13253/dns-over-https).
- DNS over TLS (DoT) using [NGINX](https://www.nginx.com/).
- Automatic SSL certificates for DoH & DoT by [Let's Encrypt](https://letsencrypt.org/).
- Locked-down firewall using IPTables.
- Optimized sysctl config.
- Automatic security updates enabled.
- DNS request statistics API from [AhaDNS/Aha.Dns.Statistics](https://github.com/AhaDNS/Aha.Dns.Statistics)
  - GET endpoint will be available at `https://{{ hostname }}/UnboundControlStats?api_key={{ ahaDnsStatisticsApiKey }}`

All configuration that will be applied can be found in the `files` directory.
The playbook is primarily created for AhaDNS but the public is of course welcome to use it as well.

## Disclaimer

Please, do not set up public DNS servers if you don't know what you're doing. This Ansible playbook have been created during late evenings and I do not take any responsibility of the outcome of the playbook execution. Feel free to improve the notebook and submit your changes in a PR.

## Prerequisites

1. You must own a Fully Qualified Domain Name (FQDN) for:
   - Server hostname i.e. `hostname.my.domain`
   - DoH endpoint i.e. `doh.hostname.my.domain`
   - DoT endpoint i.e. `dot.hostname.my.domain`
2. You must setup an A (and AAAA if IPv6 is desired) DNS zone for the three FQDN's mentioned above, pointing to the IP of the Linux server. Otherwise Let's Encrypt certificate creation will fail.

## Install instructions

1. Secure your SSH config to your preference on the host before running the playbook.
2. Install Ansible on the machine that will run the playbook.
3. Clone this repository using `git clone https://github.com/AhaDNS/dns-server-setup.git`
4. Edit the `hosts` file to reflect your setup, i.e. change vars. `playbook.yml` does NOT need to be changed.
5. Start playbook using `ansible-playbook playbook.yml -i hosts --ask-become-pass`

### Supported distros

- Ubuntu 20.04 LTS
- Debian 10 (untested)

## Usage instructions

This is a high performance setup and does not provide any graphical user interface for configuration. After installation, you might want to:

- Tune the unbound config to your system (edit `/etc/unbound/unbound.conf.d/ahadns.conf`)
- Learn how the block/white-list are created and updated (see `/etc/ahadns/unbound_update.sh`)
- Check your DNS request statistics by doing a GET query `curl https://{{ hostname }}/UnboundControlStats?api_key={{ ahaDnsStatisticsApiKey }}`
  - Change `{{ hostname }}` and `{{ ahaDnsStatisticsApiKey }}` with values used in the hosts file during setup

## Support

We do not provide any official support for this playbook, but you can always reach out to us at:

- [AhaDNS Community](https://t.me/pidns_community)
- [Reddit r/ahadns](http://reddit.com/r/ahadns)

And we'll try to hep you in best-effort.

## Uninstall instructions

We do not provide any uninstall instructions yet. For now, we recommend you to reinstall your OS to completely remove everything.

## Known issues

- Playbook stuck on `iptables restore v4` or `iptables restore v6`
  - Solution:
    - Stop the playbook execution (with ctrl + c), Then re-run the playbook.
- Got error message `Using a SSH password instead of a key is not possible because Host Key checking is enabled and sshpass does not support this. Please add this host's fingerprint to your known_hosts file to manage this host.`
  - Solution:
    - On the machine running ansible, run `export ANSIBLE_HOST_KEY_CHECKING=False`

## Acknowledgements

- [oisd](https://oisd.nl/) blocklist by sjhgvr.
- Inspired by [ansible-adguard](https://github.com/Freekers/ansible-adguard).

## License

Unless otherwise specified, all code in this repository is released under the GNU General Public License v3.0. See the [repository's LICENSE file](https://github.com/AhaDNS/dns-server-setup/blob/main/LICENSE) for details.
