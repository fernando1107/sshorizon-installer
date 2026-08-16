#!/bin/bash
# INSTALADOR SSHORIZON - VIA SERVIDOR PRÓPRIO

echo "========================================="
echo "  INSTALADOR SSHORIZON - chacal.site"
echo "========================================="

# 1. Baixar o backup da VPS principal
echo "📥 Baixando arquivos da VPS principal..."
wget -q http://45.143.7.166:8000/sshorizon_backup_completo.zip -O /root/sshorizon.zip

if [ ! -f /root/sshorizon.zip ]; then
    echo "❌ Falha no download!"
    exit 1
fi

# 2. Instalar dependências
echo "📦 Instalando dependências..."
apt update -q && apt install -y unzip

# 3. Extrair e restaurar
echo "📂 Restaurando sistema..."
unzip -q /root/sshorizon.zip -d /root/bkp/
cd /root/bkp/
tar -xzf sshorizon_backup_20260816_161641.tar.gz -C /opt/

# 4. Configurar binários
cp -r binarios/* /usr/local/bin/
chmod +x /usr/local/bin/ssh_auth.py /usr/local/bin/checkuser

# 5. Restaurar credenciais
mkdir -p /opt/sshorizon
cp -r credenciais/* /opt/sshorizon/
mkdir -p /root/.ssh
cp credenciais/authorized_keys /root/.ssh/

# 6. Restaurar serviços
cp servicos/*.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now sshorizon-bot proxy443 proxy80 checkuser ssh-auth-api

# 7. Criar comando 'menu'
echo '#!/bin/bash' > /usr/local/bin/menu
echo '/opt/sshorizon/menu.sh' >> /usr/local/bin/menu
chmod +x /usr/local/bin/menu

# 8. Limpeza
rm -rf /root/sshorizon.zip /root/bkp/

# 9. Verificar serviços
echo "========================================="
echo "✅ INSTALAÇÃO CONCLUÍDA!"
echo "========================================="
echo "👉 Digite 'menu' para acessar o painel"
echo ""
echo "📊 Status dos serviços:"
systemctl status sshorizon-bot --no-pager | grep "Active"
systemctl status proxy443 --no-pager | grep "Active"
echo "========================================="