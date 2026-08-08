# 🧰 toolbox

A personal collection of small, single-purpose shell and Python scripts —
network reconnaissance, security testing on my own systems, sysadmin
utilities, and a few odds and ends. Most scripts started as quick one-offs;
this repo organizes them, strips out anything sensitive, and documents
what each one actually does.

## ⚠️ Responsible use

Several scripts in `recon/`, `access-pivoting/`, and `web-testing/` are
network reconnaissance / security-testing tools (DNS snooping, LDAP/NFS
enumeration, proxy chaining, parameter fuzzing, login-form automation).
**Only run these against systems you own or have explicit written
authorization to test.** Using them against systems you don't control may
violate the Computer Fraud and Abuse Act (US), the Computer Misuse Act
(UK), or equivalent laws elsewhere. This repo is published for
educational/personal-reference purposes; you are responsible for how you
use it.

## 📁 Structure

```
toolbox/
├── recon/              # OSINT / network reconnaissance
├── access-pivoting/     # Proxies, port-knocking, encrypted transfer
├── web-testing/         # Web app / login-form testing
├── system-security/      # Local system checks & hardware-lock utilities
├── licensing/            # Offline/online time-lock license checks
├── terminal/             # Terminal color helpers
├── file-utils/           # Batch file/annotation utilities
├── network-utils/        # Basic connectivity checks
└── audio-over-ssh/       # Stream audio between machines over SSH
```

## 📜 Scripts

### recon/ — reconnaissance & OSINT
| Script | Description | Requires |
|---|---|---|
| `ip_geolocation.sh` | Geolocates an IPv4 address via ipwhois.app | `curl`, `jq` |
| `ip_range_reverse_lookup.py` | Reverse DNS (PTR) lookup for every IP in a CIDR range | `netaddr` |
| `whois_domain.sh` | WHOIS lookup on a domain | `whois` |
| `what_is_my_public_ipv4.sh` | Prints your public IPv4 | `curl` |
| `linkextractor.sh` | Lists all links on a webpage | `lynx` |
| `mail_extractor.py` | Crawls a site (following internal links) and collects email addresses | `requests`, `beautifulsoup4`, `html5lib` |
| `mail_extractor.sh` | Same idea, single-page version via `lynx` + `grep` | `lynx`, `curl` |
| `mail_header_parser.py` | Connects to an IMAP inbox and dumps message headers/payloads | `imaplib` (stdlib) |
| `dns_cache_snooping.sh` | Checks whether a DNS record is cached on a resolver | `dig` |
| `nfs_rpc_scan.sh` | Detects NFS via RPC and lists exports | `rpcinfo`, `showmount` |
| `ldap_enum.sh` | Queries an LDAP server / extracts a specific attribute | `ldapsearch` |

### access-pivoting/ — proxies, knocking, transfer
| Script | Description | Requires |
|---|---|---|
| `proxy.sh` | Pulls live HTTPS proxies and curls a target through each | `curl` |
| `proxy_chain.sh` | Pulls SOCKS5 proxies into `proxychains4.conf`, restarts Tor | `proxychains4`, root |
| `test_socks5.sh` | Tests a single SOCKS5 proxy against a target URL | `curl` |
| `knock_client.sh` | Sends a TCP port-knock sequence, then opens SSH | `nmap`, `ssh` |
| `secure_copy.sh` | AES-256-encrypts a file and `scp`s it to a remote host | `openssl`, `scp` |

### web-testing/
| Script | Description | Requires |
|---|---|---|
| `param_fuzzer.sh` | Sends a payload list as URL parameters against a page | `curl` |
| `login_form_test.py` | Automates submitting a login form | `mechanize` |
| `url_fetch.py` | Fetches a URL, prints status code + body | stdlib only |

### system-security/
| Script | Description |
|---|---|
| `check_user.sh` | Shows current UID/username and root status |
| `get_hardware_id.sh` | Compares this machine's DMI UUID against an expected value |
| `log_cleanup.sh` | Truncates `/var/log/messages` (for your own systems — see warning in file) |

### licensing/
| Script | Description |
|---|---|
| `offline_time_license.sh` | Encrypted local timestamp + expiry date, detects clock rollback |
| `online_auto_time.sh` | Checks expiry against a remote HTTP time source |

### terminal/
| Script | Description |
|---|---|
| `color.py` | ANSI color constants for Python scripts |
| `color.sh` | Prints a sample line in every standard terminal color |

### file-utils/
| Script | Description |
|---|---|
| `batch_update_xml_paths.py` | Rewrites `<filename>`/`<path>` tags across a folder of annotation XMLs |
| `batch_copy_files.py` | Copies a template file into destination names matching a folder of images |

### network-utils/
| Script | Description |
|---|---|
| `ping.sh` | Pings a host once, reports reachability |

### audio-over-ssh/
| Script | Description | Requires |
|---|---|---|
| `stream_mic_to_remote.sh` | Streams local mic → remote speakers over SSH | `arecord`, `aplay`, `ssh` |
| `stream_remote_mic_to_local.sh` | Streams remote mic → local speakers over SSH | `arecord`, `aplay`, `ssh` |
| `play_white_noise.sh` | Plays white noise via `/dev/urandom` | `aplay` |

## 🧹 What changed from the original versions

This repo is a cleaned-up version of scripts that were previously local-only.
Changes made before publishing:

- **Removed hardcoded credentials**: `mail_header_parser.py` (Gmail login),
  `ldap_enum.sh` (LDAP bind password), `login_form_test.py` (test login).
  All now read from environment variables or interactive/hidden prompts.
- **Removed hardcoded personal paths & local IPs**: `batch_update_xml_paths.py`,
  `batch_copy_files.py` (previously had a personal absolute path baked in),
  `secure_copy.sh`, `stream_mic_to_remote.sh`, `stream_remote_mic_to_local.sh`
  (previously had a hardcoded home-lab IP). All now take arguments.
- **Fixed a real crawl bug** in `mail_extractor.py` — the link-extraction
  logic was outside the `while` loop due to indentation, so it only ever
  processed the last URL instead of the whole crawl queue.
- **Fixed date-comparison bugs** in `offline_time_license.sh` and
  `online_auto_time.sh` — the originals compared human-readable date
  strings with bash's `<`/`>`, which is not chronologically correct.
  Both now compare Unix epoch integers.
- **Fixed a busy-loop** in `offline_time_license.sh` (no `sleep`, pegged a
  CPU core at 100%).
- **Corrected mislabeled ANSI color codes** in `color.py` (e.g. the
  variable named `cyan` pointed at code 93, which is actually yellow).
- **Renamed a few files** for accuracy — `sql_injection.py` was form-login
  automation (not SQLi), `sql_injection2.py` was a generic URL fetcher.
  See table above for current names.

## Requirements

Most Python scripts need packages from `pip`. There's no single shared
`requirements.txt` since each script is standalone; check the docstring
at the top of each `.py` file for what it needs.

## License

MIT — see `LICENSE`.
