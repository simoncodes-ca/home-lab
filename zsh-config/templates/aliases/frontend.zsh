# ~/.config/zsh/aliases/frontend.zsh
# TypeScript/Angular/React specific aliases

# Angular CLI
alias ng='npx ng'
alias ngs='ng serve'
alias ngb='ng build'
alias ngt='ng test'
alias ngg='ng generate'

# React
alias cra='npx create-react-app'
alias cra-ts='npx create-react-app --template typescript'

# Next.js
alias next-dev='npm run dev'
alias next-build='npm run build'
alias next-start='npm run start'

# TypeScript
alias tsc='npx tsc'
alias tsw='npx tsc --watch'
alias tsi='npx tsc --init'

# Prettier
alias prettier='npx prettier'
alias pf='npx prettier --write .'

# ESLint
alias lint='npx eslint'
alias lintfix='npx eslint --fix'

# Check types + lint + format
alias check='npm run type-check && npm run lint && npm run format'

# Clean build artifacts
alias clean='rm -rf dist build .next out coverage'

# Bundle analyzer
alias analyze='npm run build -- --stats && npx webpack-bundle-analyzer dist/stats.json'

# Quick component generator (React)
mkcomp() {
  local name=$1
  local dir=${2:-src/components}
  mkdir -p "$dir/$name"
  cat > "$dir/$name/$name.tsx" <<EOF
import React from 'react';
import './$name.css';

interface ${name}Props {
  // Props interface
}

export const $name: React.FC<${name}Props> = (props) => {
  return (
    <div className="$name">
      <h2>$name Component</h2>
    </div>
  );
};
EOF
  cat > "$dir/$name/$name.css" <<EOF
.$name {
  /* Component styles */
}
EOF
  echo "Created component: $dir/$name"
}
