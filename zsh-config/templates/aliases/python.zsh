# ~/.config/zsh/aliases/python.zsh
# Python aliases

# Python version shortcuts
alias py='python3'
alias pip='pip3'

# Virtual environment
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'
alias deactivate='deactivate'

# Quick venv creation and activation
mkvenv() {
  python3 -m venv "${1:-.venv}"
  source "${1:-.venv}/bin/activate"
  pip install --upgrade pip
}

# Freeze requirements
alias freeze='pip freeze > requirements.txt'

# Install from requirements
alias pipr='pip install -r requirements.txt'

# List installed packages
alias pipl='pip list'

# Run Python HTTP server
alias serve='python3 -m http.server'

# Run pytest with coverage
alias pyt='pytest --cov=. --cov-report=html'
