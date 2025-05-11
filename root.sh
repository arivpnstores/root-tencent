#!/bin/bash

# Ganti password root
echo "Masukkan password baru untuk root:"
read -s newpass
echo "root:$newpass" | chpasswd
echo "[✓] Password root berhasil diubah."

# Edit sshd_config: comment 'PermitEmptyPasswords no'
config_file="/etc/ssh/sshd_config"

# Backup dulu
cp "$config_file" "$config_file.bak"

# Comment PermitEmptyPasswords no
sed -i 's/^PermitEmptyPasswords[ \t]*no/#&/' "$config_file"

echo "[✓] Konfigurasi PermitEmptyPasswords telah dikomentari."

# Restart SSH service
if command -v systemctl &> /dev/null; then
    systemctl restart ssh || systemctl restart sshd
else
    service ssh restart || service sshd restart
fi

echo "[✓] SSH service telah direstart."
