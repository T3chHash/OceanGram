#!/usr/bin/env bash
# ==============================================================================
# OceanGram — Modern Secure Real-time Messenger
# One-Line Ubuntu / Debian Production Installer
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

# Config Defaults
REPO_URL="https://github.com/T3chHash/OceanGram.git"
INSTALL_DIR="/opt/oceangram"
CLI_BIN="/usr/local/bin/oceangram"
DEFAULT_PORT="5174"
CLIENT_PORT="80"
SSL_PORT="443"

# ASCII Ocean Banner
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

# Ensure root privileges
check_privileges() {
  if [[ $EUID -ne 0 ]]; then
    log_error "This installer must be run as root or with sudo:"
    echo "  curl -fsSL https://raw.githubusercontent.com/T3chHash/OceanGram/main/install.sh | sudo bash"
    exit 1
  fi
}

# Detect OS
check_os() {
  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    OS_NAME="${ID:-unknown}"
    OS_VERSION="${VERSION_ID:-unknown}"
    if [[ "$OS_NAME" != "ubuntu" && "$OS_NAME" != "debian" ]]; then
      log_warn "Notice: Tested primarily on Ubuntu 20.04/22.04/24.04 and Debian 11/12."
    fi
  else
    log_warn "Could not verify /etc/os-release. Proceeding anyway..."
  fi
}

# Install essential dependencies (Docker, Docker Compose, Git, Curl, OpenSSL)
install_dependencies() {
  log_info "Updating system package index..."
  apt-get update -qq

  log_info "Installing required packages (curl, git, openssl, ca-certificates)..."
  apt-get install -y -qq curl git openssl ca-certificates gnupg lsb-release

  # Check Docker
  if ! command -v docker &> /dev/null; then
    log_info "Installing Docker Engine..."
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes
    chmod a+r /etc/apt/keyrings/docker.gpg

    UBUNTU_CODENAME="$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")"
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      ${UBUNTU_CODENAME} stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt-get update -qq
    apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    systemctl enable --now docker
    log_success "Docker installed successfully."
  else
    log_success "Docker is already installed."
  fi

  # Ensure docker compose is available
  if ! docker compose version &> /dev/null; then
    apt-get install -y -qq docker-compose-plugin
  fi
}

# Setup target directory & clone/pull repository
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

# Generate SSL certificates (Self-signed fallback or Let's Encrypt ready)
setup_certificates() {
  local cert_dir="$INSTALL_DIR/certs"
  mkdir -p "$cert_dir"

  if [[ ! -f "$cert_dir/cert.pem" || ! -f "$cert_dir/key.pem" ]]; then
    log_info "Generating SSL certificate for OceanGram..."
    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
      -keyout "$cert_dir/key.pem" \
      -out "$cert_dir/cert.pem" \
      -subj "/C=US/ST=Ocean/L=Pacific/O=OceanGram/CN=localhost" \
      -addext "subjectAltName=DNS:localhost,IP:127.0.0.1" \
      2>/dev/null
    chmod 600 "$cert_dir/key.pem"
    chmod 644 "$cert_dir/cert.pem"
    log_success "SSL certificates generated."
  fi
}

# Configure environment variables
setup_env() {
  cd "$INSTALL_DIR"
  if [[ ! -f ".env" ]]; then
    log_info "Configuring .env settings..."
    cp .env.example .env 2>/dev/null || touch .env

    # Generate cryptographically secure secrets
    local jwt_secret session_secret
    jwt_secret="$(openssl rand -hex 32)"
    session_secret="$(openssl rand -hex 32)"

    {
      echo "APP_ENV=production"
      echo "SERVER_PORT=5174"
      echo "CLIENT_PORT=443"
      echo "JWT_SECRET=${jwt_secret}"
      echo "SESSION_SECRET=${session_secret}"
      echo "SIGN_UP=true"
      echo "DB_CLIENT=sqlite3"
    } >> .env
    log_success "Environment configuration initialized."
  fi
}

# Setup CLI command helper (/usr/local/bin/oceangram)
setup_cli() {
  log_info "Installing global 'oceangram' management command..."
  cat << 'EOF' > "$CLI_BIN"
#!/usr/bin/env bash
set -e

DIR="/opt/oceangram"
if [[ ! -d "$DIR" ]]; then
  echo "OceanGram directory not found at $DIR"
  exit 1
fi

cd "$DIR"

case "${1:-status}" in
  start)
    echo "Starting OceanGram..."
    docker compose up -d
    ;;
  stop)
    echo "Stopping OceanGram..."
    docker compose down
    ;;
  restart)
    echo "Restarting OceanGram..."
    docker compose down
    docker compose up -d
    ;;
  status)
    docker compose ps
    ;;
  logs)
    shift
    docker compose logs -f "$@"
    ;;
  update)
    echo "Updating OceanGram to the latest release..."
    git pull origin main
    docker compose build --no-cache
    docker compose up -d
    echo "OceanGram successfully updated!"
    ;;
  *)
    echo "Usage: oceangram {start|stop|restart|status|logs|update}"
    exit 1
    ;;
esac
EOF
  chmod +x "$CLI_BIN"
  log_success "Installed global CLI command: 'oceangram'"
}

# Build and start services via Docker Compose
start_services() {
  cd "$INSTALL_DIR"
  log_info "Building and launching OceanGram containers (this may take 1-2 minutes on first run)..."
  docker compose build
  docker compose up -d

  log_info "Verifying healthcheck status..."
  local retries=15
  local running=false
  while [[ $retries -gt 0 ]]; do
    if docker compose ps --filter "status=running" | grep -q "oceangram"; then
      running=true
      break
    fi
    sleep 2
    ((retries--))
  done

  if [[ "$running" = true ]]; then
    log_success "OceanGram services are running!"
  else
    log_warn "Containers launched. Check logs with: oceangram logs"
  fi
}

# Main installer flow
main() {
  print_banner
  check_privileges
  check_os
  install_dependencies
  setup_repository
  setup_certificates
  setup_env
  setup_cli
  start_services

  # Detect public IP
  SERVER_IP="$(curl -s4 https://ifconfig.me || hostname -I | awk '{print $1}')"

  printf "\n%b=============================================================%b\n" "$C_GREEN" "$C_RESET"
  printf "%b  🎉 OceanGram Installation Complete!%b\n" "$C_BOLD" "$C_RESET"
  printf "%b=============================================================%b\n\n" "$C_GREEN" "$C_RESET"
  printf "Access OceanGram in your web browser:\n"
  printf "  %bhttps://%s%b  (or https://localhost)\n\n" "$C_CYAN" "$SERVER_IP" "$C_RESET"
  printf "Management Commands:\n"
  printf "  %boceangram status%b   - Check service status\n" "$C_BOLD" "$C_RESET"
  printf "  %boceangram logs%b     - Stream live application logs\n" "$C_BOLD" "$C_RESET"
  printf "  %boceangram restart%b  - Restart messenger services\n" "$C_BOLD" "$C_RESET"
  printf "  %boceangram update%b   - Pull updates & rebuild containers\n\n" "$C_BOLD" "$C_RESET"
}

main "$@"
