# sshorizon-installer
Passo 1: Criar um Repositório no GitHub

1. Acesse github.com e faça login
2. Clique em "New repository"
3. Nomeie como sshorizon-installer (ou qualquer nome)
4. Deixe como "Public" (ou Private, se preferir)
5. Clique em "Create repository"

Passo 2: Fazer Upload dos Arquivos

No repositório criado, faça upload de:

1. O arquivo ZIP do backup (renomeado para algo simples):
   · sshorizon_chacal_site.zip
2. Um script de instalação chamado install.sh:

```bash
#!/bin/bash
# INSTALADOR PERSONALIZADO - SSHorizon (chacal.site)

echo "========================================="
echo "  INSTALANDO SSHORIZON - chacal.site"
echo "========================================="

# Baixar o backup do GitHub
echo "📥 Baixando arquivos..."
curl -s -L -o /root/sshorizon_install.zip \
  https://raw.githubusercontent.com/SEU_USUARIO/sshorizon-installer/main/sshorizon_chacal_site.zip

# Extrair e instalar
echo "📦 Instalando sistema..."
apt update && apt install -y unzip
unzip /root/sshorizon_install.zip -d /root/bkp/
cd /root/bkp/
tar -xzf sshorizon_backup_20260816_161641.tar.gz -C /opt/
cp -r binarios/* /usr/local/bin/
chmod +x /usr/local/bin/ssh_auth.py /usr/local/bin/checkuser
mkdir -p /opt/sshorizon
cp -r credenciais/* /opt/sshorizon/
mkdir -p /root/.ssh
cp credenciais/authorized_keys /root/.ssh/
cp servicos/*.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now sshorizon-bot proxy443 proxy80 checkuser ssh-auth-api

# Limpeza
rm -rf /root/sshorizon_install.zip /root/bkp/

echo "========================================="
echo "✅ INSTALAÇÃO CONCLUÍDA!"
echo "👉 Digite 'menu' para acessar o painel"
echo "========================================="
