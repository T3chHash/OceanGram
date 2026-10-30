#!/usr/bin/env bash
# ==============================================================================
# OceanGram — Modern Secure Real-time Messenger
# Interactive Ubuntu / Debian Production Installer
# Repository: https://github.com/T3chHash/OceanGram.git
# ==============================================================================

set -euo pipefail

# Colors
C_RESET=$'\033[0m'
C_CYAN=$'\033[1;36m'
C_BLUE=$'\033[1;34m'
C_GREEN=$'\033[1;32m'
C_YELLOW=$'\033[1;33m'
C_RED=$'\033[1;31m'
C_BOLD=$'\033[1m'

# Defaults
REPO_URL="https://github.com/T3chHash/OceanGram.git"
INSTALL_DIR="/opt/oceangram"
CLI_BIN="/usr/local/bin/oceangram"
DEFAULT_SERVER_PORT="5174"
CLIENT_PORT="443"
HTTP_PORT="80"

# Interactive State
USE_DOMAIN="false"
DOMAIN_NAME=""
ADMIN_EMAIL=""
DB_CHOICE="1"
POSTGRES_HOST="postgres"
POSTGRES_PORT="5432"
POSTGRES_DB="oceangram"
POSTGRES_USER="postgres"
POSTGRES_PASSWORD=""
ALLOW_SIGNUP="true"
COMPOSE_PROFILE=""

# Banner
print_banner() {
  cat << "EOF"

  ___                         ____                 
 / _ \  ___ ___  __ _ _ __   / ___|_ __ __ _ _ __  
| | | |/ __/ _ \/ _` | '_ \ | |  _| '__/ _` | '_ \ 
| |_| | (_|  __/ (_| | | | || |_| | | | (_| | | | |
 \___/ \___\___|\__,_|_| |_(_)____|_|  \__,_|_| |_|
       Modern Secure Real-Time Messenger
EOF
  printf "%b─────────────────────────────────────────────────────────────%b\n" "$C_CYAN" "$C_RESET"
}

log_info() {
  printf "%b[OceanGram]%b %s\n" "$C_CYAN" "$C_RESET" "$1"
}

log_success() {
  printf "%b[OceanGram] ✓%b %s\n" "$C_GREEN" "$C_RESET" "$1"
}

log_warn() {
  printf "%b[OceanGram] ⚠%b %s\n" "$C_YELLOW" "$C_RESET" "$1"
}

log_error() {
  printf "%b[OceanGram] ✖%b %s\n" "$C_RED" "$C_RESET" "$1" >&2
}

# Prompt helper that supports piped curl bash (reads from /dev/tty)
prompt_user() {
  local prompt_msg="$1"
  local default_val="$2"
  local user_input=""

  if [[ -r /dev/tty ]]; then
    printf "%b%s%b " "$C_BOLD" "$prompt_msg" "$C_RESET" > /dev/tty
    read -r user_input < /dev/tty || true
  fi

  if [[ -z "$user_input" ]]; then
    echo "$default_val"
  else
    echo "$user_input"
  fi
}

# Clean any broken/leftover docker.com repos from previous failed attempts
clean_legacy_docker_repos() {
  log_info "Cleaning up any broken/geoblocked apt repository lists..."
  rm -f /etc/apt/sources.list.d/docker*.list
  rm -f /etc/apt/keyrings/docker*.gpg
}

# Ensure anti-sanction DNS is available if needed
setup_dns_fallback() {
  if ! grep -q "178.22.122.100" /etc/resolv.conf 2>/dev/null; then
    cp /etc/resolv.conf /etc/resolv.conf.bak 2>/dev/null || true
    {
      echo "nameserver 178.22.122.100"
      echo "nameserver 185.51.200.2"
      echo "nameserver 10.202.10.202"
      cat /etc/resolv.conf.bak 2>/dev/null || true
    } | awk '!seen[$0]++' > /etc/resolv.conf 2>/dev/null || true
  fi
}

# Free ports 80 and 443 from host processes (apache2, host nginx)
free_host_web_ports() {
  log_info "Releasing ports 80 and 443 on host..."
  if systemctl is-active --quiet apache2 2>/dev/null; then
    systemctl stop apache2 2>/dev/null || true
    systemctl disable apache2 2>/dev/null || true
  fi

  if systemctl is-active --quiet nginx 2>/dev/null; then
    systemctl stop nginx 2>/dev/null || true
    systemctl disable nginx 2>/dev/null || true
  fi

  if command -v fuser &>/dev/null; then
    fuser -k 80/tcp 2>/dev/null || true
    fuser -k 443/tcp 2>/dev/null || true
  fi
}

# Clean Public IP Detection (Never outputs HTML 403 pages)
get_public_ip() {
  local ip=""
  ip="$(curl -s4 --max-time 3 https://api.ipify.org 2>/dev/null || true)"
  if [[ -z "$ip" || "$ip" == *"html"* || "$ip" == *"403"* || "$ip" == *"Error"* ]]; then
    ip="$(curl -s4 --max-time 3 https://icanhazip.com 2>/dev/null || true)"
  fi
  if [[ -z "$ip" || "$ip" == *"html"* || "$ip" == *"403"* || "$ip" == *"Error"* ]]; then
    ip="$(curl -s4 --max-time 3 https://checkip.amazonaws.com 2>/dev/null || true)"
  fi
  if [[ -z "$ip" || "$ip" == *"html"* || "$ip" == *"403"* || "$ip" == *"Error"* ]]; then
    ip="$(hostname -I 2>/dev/null | awk '{print $1}')"
  fi
  echo "${ip:-127.0.0.1}" | tr -d '[:space:]'
}

# Interactive Setup Wizard
interactive_configuration() {
  printf "\n%b================ Setup Configuration Wizard ================%b\n" "$C_CYAN" "$C_RESET"

  # Domain Setup
  local domain_choice
  domain_choice="$(prompt_user "Configure a custom domain with automatic Let's Encrypt SSL? (y/N):" "n")"
  if [[ "$domain_choice" =~ ^[Yy]$ ]]; then
    USE_DOMAIN="true"
    DOMAIN_NAME="$(prompt_user "Enter your Domain Name (e.g. chat.example.com):" "")"
    while [[ -z "$DOMAIN_NAME" ]]; do
      log_warn "Domain cannot be blank when custom domain is enabled."
      DOMAIN_NAME="$(prompt_user "Enter your Domain Name (e.g. chat.example.com):" "")"
    done
    ADMIN_EMAIL="$(prompt_user "Enter email for Let's Encrypt notifications (e.g. admin@$DOMAIN_NAME):" "admin@$DOMAIN_NAME")"
  else
    USE_DOMAIN="false"
    DOMAIN_NAME="$(get_public_ip)"
  fi

  # Database Setup
  printf "\n%bSelect Database Engine:%b\n" "$C_CYAN" "$C_RESET"
  printf "  1) %bSQLite3%b (Embedded, zero-config, in-memory + WAL persistence) [Recommended]\n" "$C_BOLD" "$C_RESET"
  printf "  2) %bPostgreSQL%b (Automated Docker container)\n" "$C_BOLD" "$C_RESET"
  printf "  3) %bExternal PostgreSQL%b (Custom remote host/credentials)\n" "$C_BOLD" "$C_RESET"
  DB_CHOICE="$(prompt_user "Choose database (1/2/3) [Default 1]:" "1")"

  if [[ "$DB_CHOICE" == "2" ]]; then
    COMPOSE_PROFILE="--profile postgres"
    POSTGRES_PASSWORD="$(openssl rand -hex 16)"
    log_info "PostgreSQL Docker container will be provisioned."
  elif [[ "$DB_CHOICE" == "3" ]]; then
    POSTGRES_HOST="$(prompt_user "PostgreSQL Host:" "127.0.0.1")"
    POSTGRES_PORT="$(prompt_user "PostgreSQL Port:" "5432")"
    POSTGRES_DB="$(prompt_user "PostgreSQL Database Name:" "oceangram")"
    POSTGRES_USER="$(prompt_user "PostgreSQL Username:" "postgres")"
    POSTGRES_PASSWORD="$(prompt_user "PostgreSQL Password:" "")"
  fi

  # User Signups
  local signup_choice
  signup_choice="$(prompt_user "Allow public user sign-ups? (Y/n):" "y")"
  if [[ "$signup_choice" =~ ^[Nn]$ ]]; then
    ALLOW_SIGNUP="false"
  else
    ALLOW_SIGNUP="true"
  fi

  printf "%b─────────────────────────────────────────────────────────────%b\n\n" "$C_CYAN" "$C_RESET"
}

# Install essential dependencies
install_dependencies() {
  clean_legacy_docker_repos
  setup_dns_fallback

  log_info "Updating system package index..."
  apt-get update -qq || true

  log_info "Installing core packages (curl, git, openssl, ca-certificates, certbot, psmisc)..."
  apt-get install -y -qq curl git openssl ca-certificates gnupg lsb-release psmisc certbot

  free_host_web_ports

  # Install Docker
  if ! command -v docker &> /dev/null; then
    log_info "Installing Docker Engine..."
    if apt-get install -y -qq docker.io docker-compose-v2 2>/dev/null; then
      log_success "Docker installed via apt (docker.io + docker-compose-v2)."
    elif apt-get install -y -qq docker.io docker-compose 2>/dev/null; then
      log_success "Docker installed via apt (docker.io + docker-compose)."
    elif apt-get install -y -qq docker.io 2>/dev/null; then
      log_success "Docker installed via apt (docker.io)."
    else
      curl -fsSL https://get.docker.com | sh 2>/dev/null || true
    fi
    systemctl enable --now docker 2>/dev/null || service docker start 2>/dev/null || true
  else
    log_success "Docker is already installed."
  fi

  # Ensure compose command
  if ! docker compose version &> /dev/null; then
    if command -v docker-compose &> /dev/null; then
      mkdir -p /usr/local/lib/docker/cli-plugins 2>/dev/null || true
      ln -sf "$(command -v docker-compose)" /usr/local/lib/docker/cli-plugins/docker-compose 2>/dev/null || true
    else
      apt-get install -y -qq docker-compose-plugin 2>/dev/null || apt-get install -y -qq docker-compose 2>/dev/null || true
    fi
  fi

  # Configure Docker Registry Mirrors
  mkdir -p /etc/docker
  log_info "Configuring Docker registry mirrors (sanction-safe)..."
  cat << 'EOF' > /etc/docker/daemon.json
{
  "registry-mirrors": [
    "https://docker.arvancloud.ir",
    "https://mirror.gcr.io",
    "https://dockerproxy.com"
  ]
}
EOF
  systemctl restart docker 2>/dev/null || service docker restart 2>/dev/null || true
}

# Resolve Compose Command
get_compose_cmd() {
  local cmd="docker compose"
  if ! docker compose version &> /dev/null; then
    if command -v docker-compose &> /dev/null; then
      cmd="docker-compose"
    fi
  fi
  if [[ -n "$COMPOSE_PROFILE" ]]; then
    echo "$cmd $COMPOSE_PROFILE"
  else
    echo "$cmd"
  fi
}

# Setup target repository
setup_repository() {
  if [[ -d "$INSTALL_DIR/.git" ]]; then
    log_info "Existing OceanGram installation detected at $INSTALL_DIR. Updating..."
    git -C "$INSTALL_DIR" fetch origin main
    git -C "$INSTALL_DIR" reset --hard origin/main
  else
    log_info "Cloning OceanGram to $INSTALL_DIR..."
    mkdir -p "$(dirname "$INSTALL_DIR")"
    rm -rf "$INSTALL_DIR"
    git clone "$REPO_URL" "$INSTALL_DIR"
  fi
  cd "$INSTALL_DIR"
}

# SSL Certificates (Let's Encrypt for Domain, Self-Signed for IP)
setup_certificates() {
  local cert_dir="$INSTALL_DIR/certs"
  mkdir -p "$cert_dir"

  free_host_web_ports

  if [[ "$USE_DOMAIN" == "true" && -n "$DOMAIN_NAME" ]]; then
    log_info "Obtaining Let's Encrypt SSL certificate for $DOMAIN_NAME..."
    if certbot certonly --standalone --non-interactive --agree-tos \
      -m "$ADMIN_EMAIL" -d "$DOMAIN_NAME" \
      --keep-until-expiring 2>/dev/null; then
      cp "/etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem" "$cert_dir/cert.pem"
      cp "/etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem" "$cert_dir/key.pem"
      chmod 644 "$cert_dir/cert.pem"
      chmod 600 "$cert_dir/key.pem"
      log_success "Let's Encrypt SSL successfully installed for $DOMAIN_NAME!"

      # Setup automatic certbot renewal hook
      local renew_hook="/etc/letsencrypt/renewal-hooks/deploy/oceangram-reload.sh"
      mkdir -p "$(dirname "$renew_hook")"
      cat << EOF > "$renew_hook"
#!/usr/bin/env bash
cp "/etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem" "$cert_dir/cert.pem"
cp "/etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem" "$cert_dir/key.pem"
docker restart oceangram-nginx 2>/dev/null || true
EOF
      chmod +x "$renew_hook"
      return 0
    else
      log_warn "Certbot standalone failed (DNS might not point to this server yet). Falling back to SAN SSL."
    fi
  fi

  log_info "Generating high-grade SSL certificates for IP ($DOMAIN_NAME)..."
  openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
    -keyout "$cert_dir/key.pem" \
    -out "$cert_dir/cert.pem" \
    -subj "/C=US/ST=Ocean/L=Pacific/O=OceanGram/CN=$DOMAIN_NAME" \
    -addext "subjectAltName=DNS:localhost,DNS:$DOMAIN_NAME,IP:127.0.0.1,IP:$(get_public_ip)" \
    2>/dev/null
  chmod 600 "$cert_dir/key.pem"
  chmod 644 "$cert_dir/cert.pem"
  log_success "SSL certificates generated."
}

# Configure environment variables
setup_env() {
  cd "$INSTALL_DIR"
  log_info "Configuring OceanGram .env settings..."

  local jwt_secret session_secret
  jwt_secret="$(openssl rand -hex 32)"
  session_secret="$(openssl rand -hex 32)"

  local db_client="sqlite3"
  if [[ "$DB_CHOICE" == "2" || "$DB_CHOICE" == "3" ]]; then
    db_client="postgres"
  fi

  cat << EOF > .env
APP_ENV=production
SERVER_PORT=5174
BIND_ADDRESS=0.0.0.0
CLIENT_PORT=443
SIGN_UP=${ALLOW_SIGNUP}
DB_CLIENT=${db_client}
POSTGRES_HOST=${POSTGRES_HOST}
POSTGRES_PORT=${POSTGRES_PORT}
POSTGRES_DB=${POSTGRES_DB}
POSTGRES_USER=${POSTGRES_USER}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
JWT_SECRET=${jwt_secret}
SESSION_SECRET=${session_secret}
EOF
  log_success "Environment configured successfully."
}

# Global CLI management command
setup_cli() {
  log_info "Installing global 'oceangram' management command..."
  cat << EOF > "$CLI_BIN"
#!/usr/bin/env bash
set -e

DIR="/opt/oceangram"
if [[ ! -d "\$DIR" ]]; then
  echo "OceanGram directory not found at \$DIR"
  exit 1
fi

cd "\$DIR"

if docker compose version &> /dev/null; then
  DC="docker compose $COMPOSE_PROFILE"
elif command -v docker-compose &> /dev/null; then
  DC="docker-compose $COMPOSE_PROFILE"
else
  DC="docker compose $COMPOSE_PROFILE"
fi

case "\${1:-status}" in
  start)
    echo "Starting OceanGram..."
    \$DC up -d
    ;;
  stop)
    echo "Stopping OceanGram..."
    \$DC down
    ;;
  restart)
    echo "Restarting OceanGram..."
    \$DC down
    \$DC up -d
    ;;
  status)
    \$DC ps
    ;;
  logs)
    shift
    \$DC logs -f "\$@"
    ;;
  update)
    echo "Updating OceanGram to the latest release..."
    git pull origin main
    \$DC build --no-cache
    \$DC up -d
    echo "OceanGram successfully updated!"
    ;;
  cert-renew)
    echo "Renewing certificates..."
    certbot renew --quiet
    ;;
  *)
    echo "Usage: oceangram {start|stop|restart|status|logs|update|cert-renew}"
    exit 1
    ;;
esac
EOF
  chmod +x "$CLI_BIN"
  log_success "Installed global CLI command: 'oceangram'"
}

# Build and start services
start_services() {
  cd "$INSTALL_DIR"
  local DC
  DC="$(get_compose_cmd)"

  free_host_web_ports
  $DC down 2>/dev/null || true

  log_info "Building and launching OceanGram containers with $DC..."
  $DC build
  $DC up -d

  log_info "Verifying services status..."
  sleep 3
  if $DC ps | grep -q "oceangram"; then
    log_success "OceanGram services are running!"
  else
    log_warn "Containers launched. Check logs with: oceangram logs"
  fi
}

main() {
  print_banner

  if [[ $EUID -ne 0 ]]; then
    log_error "This installer must be run as root or with sudo:"
    echo "  curl -fsSL https://raw.githubusercontent.com/T3chHash/OceanGram/main/install.sh | sudo bash"
    exit 1
  fi

  clean_legacy_docker_repos
  interactive_configuration
  install_dependencies
  setup_repository
  setup_certificates
  setup_env
  setup_cli
  start_services

  local final_url="https://$DOMAIN_NAME"
  if [[ "$USE_DOMAIN" != "true" ]]; then
    final_url="https://$DOMAIN_NAME"
  fi

  printf "\n%b=============================================================%b\n" "$C_GREEN" "$C_RESET"
  printf "%b  🎉 OceanGram Installation Complete!%b\n" "$C_BOLD" "$C_RESET"
  printf "%b=============================================================%b\n\n" "$C_GREEN" "$C_RESET"
  printf "Access OceanGram in your web browser:\n"
  printf "  %b%s%b\n\n" "$C_CYAN" "$final_url" "$C_RESET"
  printf "Database: %b%s%b\n" "$C_BOLD" "${DB_CHOICE/1/SQLite3 (Built-in)}" "$C_RESET"
  printf "Registrations: %b%s%b\n\n" "$C_BOLD" "${ALLOW_SIGNUP}" "$C_RESET"
  printf "Management Commands:\n"
  printf "  %boceangram status%b   - Check service status\n" "$C_BOLD" "$C_RESET"
  printf "  %boceangram logs%b     - Stream live application logs\n" "$C_BOLD" "$C_RESET"
  printf "  %boceangram restart%b  - Restart messenger services\n" "$C_BOLD" "$C_RESET"
  printf "  %boceangram update%b   - Pull updates & rebuild containers\n\n" "$C_BOLD" "$C_RESET"
}

main "$@"
