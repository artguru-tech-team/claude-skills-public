# Contabo Operations Reference

Troubleshooting, best practices, configuration variables, and cost snapshots for Contabo.

## Contents
- Troubleshooting
- Best Practices
- Configuration Reference
- Cost Comparison
- Known Issues
- Limitations

---

## Troubleshooting

<details>
<summary><strong>Instance creation fails</strong></summary>

**Common causes**:
1. Invalid region (check `cntb get datacenters`)
2. Invalid product ID (check `cntb get products --productType vps`)
3. Authentication issues (verify credentials)
4. SSH key format incorrect

**Fix**: Verify each component separately:
```bash
cntb get datacenters
cntb get products --productType vps
cntb get instances  # Test auth
cat ~/.ssh/id_rsa.pub | head -c 100  # Check key format
```

</details>

<details>
<summary><strong>Cannot SSH to instance</strong></summary>

**Checklist**:
1. Instance is running: `cntb get instance $INSTANCE_ID`
2. Wait 2-5 minutes (Contabo takes longer than other providers)
3. Correct SSH key used
4. IP address is correct

**Debug**:
```bash
# Check instance status
cntb get instance "$INSTANCE_ID"

# Try with verbose SSH
ssh -v root@$SERVER_IP
```

**Note**: Contabo doesn't have firewall API - configure firewall via their control panel or iptables on the server.

</details>

<details>
<summary><strong>Slow provisioning</strong></summary>

Contabo provisioning is slower than other providers (2-5 minutes vs 30-60 seconds).

This is normal for their pricing tier. Be patient and check status:
```bash
cntb get instance "$INSTANCE_ID" --output json | jq '.status'
```

</details>

---

## Best Practices

<details>
<summary><strong>Always do</strong></summary>

- Use NVMe plans (SP suffix) for better I/O
- Configure firewall via iptables or ufw (no API firewall)
- Use SSH keys (not password auth)
- Choose region closest to your users
- Enable object storage auto-scaling limits

</details>

<details>
<summary><strong>Never do</strong></summary>

- Expect instant provisioning (2-5 min is normal)
- Share API credentials across projects
- Leave all ports open (configure iptables)
- Expect managed firewall API (configure manually)

</details>

---

## Configuration Reference

<details>
<summary><strong>cntb CLI configuration</strong></summary>

The `cntb` CLI stores credentials in a YAML config file. **Do not use `CNTB_OAUTH2_*` environment variables** — they are unreliable and produce `clientId is empty` errors.

```bash
# Configure credentials (writes to ~/.cntb.yaml or %USERPROFILE%\.cntb.yaml)
cntb config set-credentials \
  --oauth2-clientid "your_client_id" \
  --oauth2-client-secret "your_client_secret" \
  --oauth2-user "your_email" \
  --oauth2-password 'your_password'

# Verify
cntb config view
```

Config file locations:
- **Linux/WSL**: `~/.cntb.yaml`
- **Windows**: `%USERPROFILE%\.cntb.yaml`
- **System-wide**: `/etc/.cntb.yml`

Merge priority (highest wins): CLI args > env vars > `~/.cntb.yaml` > `/etc/.cntb.yml`

> **Special characters**: If your API password contains `*`, `^`, `!`, or other shell metacharacters, wrap it in single quotes.

</details>

<details>
<summary><strong>Deployment environment variables</strong></summary>

```bash
# Deployment configuration (used in scripts, not by cntb itself)
CONTABO_REGION=EU                # Region code
CONTABO_PRODUCT_ID=V48           # Product ID (V48 verified working)
SERVER_NAME=my-server            # Display name

# Outputs (set after deployment)
SERVER_IP=...                    # Public IP
SSH_USER=root                    # SSH username
SSH_KEY_PATH=~/.ssh/id_rsa       # Local private key path
```

</details>

<details>
<summary><strong>Plan reference</strong></summary>

**Performance (NVMe) - SP Plans**:
| Plan | vCPU | RAM | Disk | Price/month |
|------|------|-----|------|-------------|
| VPS 10 SP | 4 | 8GB | 100GB NVMe | €5 |
| VPS 20 SP | 6 | 18GB | 150GB NVMe | €8 |
| VPS 30 | 8 | 24GB | 200GB | €14 |

**Standard (More Storage)**:
| Plan | vCPU | RAM | Disk | Price/month |
|------|------|-----|------|-------------|
| VPS S | 4 | 8GB | 200GB SSD | €8 |
| VPS M | 6 | 16GB | 400GB SSD | €14 |
| VPS L | 8 | 30GB | 800GB SSD | €26 |
| VPS XL | 10 | 60GB | 1600GB SSD | €39 |

</details>

---

## Cost Comparison

_Prices below are snapshots and may change; verify in the Contabo console._

| Provider | 6 vCPU, 16-18GB RAM | Monthly |
|----------|---------------------|---------|
| **Contabo VPS 20 SP** | 6 vCPU, 18GB | **€8** |
| Hetzner CX42 | 8 vCPU, 16GB | €20 |
| OCI A1.Flex | 4 OCPU, 24GB | Free* |
| DigitalOcean | 8 vCPU, 16GB | $96 |
| Vultr | 6 vCPU, 16GB | $96 |

*OCI Free Tier has capacity limitations.

Contabo is the **best value paid option** when OCI capacity is unavailable.

---

## Known Issues

<details>
<summary><strong>Product ID V45 may not work</strong></summary>

Error: `Error while creating instance: 400 - Bad Request No offer was found for product ID 'V45' and period '1'`

Contabo has restructured their product offerings. Some documented product IDs no longer work.

**Verified working (Feb 2026)**: V12, V48, V92, V101
**May not work**: V45, V39 (SP line may be discontinued)

**Solution**: Use V48 (VPS M, 6 vCPU/16GB, €14), V12 (VPS S NVMe, 4 vCPU/8GB, €5), V92 (Cloud VPS 10 SSD, 4 vCPU/8GB), or V101 (Cloud VPS 40 SSD, 12 vCPU/48GB). Run `cntb get products --productType vps` for the current list.

</details>

<details>
<summary><strong>CLI cancel command crashes</strong></summary>

`cntb cancel instance` may crash with nil pointer dereference.

**Workaround**: Cancel instances via web panel at https://my.contabo.com/

</details>

<details>
<summary><strong>SSH key registration</strong></summary>

The `--sshKeys` parameter expects the SSH public key content directly, not a key ID.

```bash
# Correct usage
cntb create instance ... --sshKeys "$(cat ~/.ssh/id_rsa.pub)"
```

</details>

<details>
<summary><strong>SSH fails on freshly provisioned instance</strong></summary>

Freshly provisioned Contabo instances may have a broken `sshd` service due to missing host keys. Symptoms:
- Port 22 open but connection refused or immediately closed
- `sshd.service` / `ssh.service` failed in `systemctl status`
- `sshd -t` reports missing host key files

**Fix** (requires VNC access from Contabo control panel):
```bash
ssh-keygen -A && systemctl restart ssh
```

This regenerates all missing host keys (`/etc/ssh/ssh_host_*`) and restarts the SSH daemon.

> **Tip**: Contabo provides VNC console access at https://my.contabo.com/ under the instance details. Use the root password from your instance creation.

</details>

<details>
<summary><strong>CNTB_OAUTH2_* environment variables don't work</strong></summary>

Despite being documented, the `CNTB_OAUTH2_CLIENT_ID`, `CNTB_OAUTH2_CLIENT_SECRET`, `CNTB_OAUTH2_USER`, and `CNTB_OAUTH2_PASS` environment variables may produce `clientId is empty` errors.

**Fix**: Use the config file approach instead:
```bash
cntb config set-credentials \
  --oauth2-clientid "your_client_id" \
  --oauth2-client-secret "your_client_secret" \
  --oauth2-user "your_email" \
  --oauth2-password 'your_password'
```

</details>

---

## Limitations

- **No Firewall API**: Configure firewall via iptables/ufw on server
- **Slower Provisioning**: 2-5 minutes (vs 30-60 seconds for others)
- **No Kubernetes Service**: Manual K8s setup required
- **Limited Auto-scaling**: Only for object storage, not compute
- **Product ID instability**: Some documented IDs may not work (see Known Issues)

Despite limitations, Contabo's pricing makes it ideal for:
- Development/staging environments
- Cost-sensitive production workloads
- Resource-intensive applications on a budget

