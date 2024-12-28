#!/bin/bash

# Create project structure
mkdir -p www
mkdir -p _data
mkdir -p src/components
mkdir -p src/styles
mkdir -p src/pages
mkdir -p public

# Create README.md
cat > README.md << 'EOF'
# Fitness Workout Cards

A web-based workout guide with swipeable exercise cards.

## Setup and Build Process

1. Ensure you have Node.js (v18 or later) and npm installed
2. Install dependencies:
   ```bash
   npm install
   ```
3. Start development server:
   ```bash
   npm run dev
   ```
4. Build for production:
   ```bash
   npm run build
   ```

## Development

- Exercise data is stored in `public/data/exercises.json`
- React components are in `src/components`
- Styles are in `src/styles`
- Built files will be in the `www` directory

## Deployment

The project is configured to deploy to GitHub Pages at https://danmiley.github.io/
EOF

# Create package.json with updated dependencies
cat > package.json << 'EOF'
{
  "name": "fitness-cards",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "serve": "npx serve www -p 3000",
    "lint": "next lint"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "next": "^14.1.0",
    "class-variance-authority": "^0.7.0",
    "clsx": "^2.1.0",
    "lucide-react": "^0.323.0",
    "tailwind-merge": "^2.2.0"
  },
  "devDependencies": {
    "@types/node": "^20.11.0",
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "autoprefixer": "^10.4.17",
    "postcss": "^8.4.33",
    "tailwindcss": "^3.4.1",
    "typescript": "^5.3.3"
  }
}
EOF

# Create exercises.json instead of YAML
mkdir -p public/data
cat > public/data/exercises.json << 'EOF'
{
  "exercises": [
    {
      "id": 1,
      "title": "Barbell Squat",
      "description": "A compound exercise targeting the lower body. Stand with feet shoulder-width apart, barbell across upper back. Lower your body until thighs are parallel to ground, then push back up.",
      "sets": "4 sets of 8-12 reps",
      "tips": "Keep chest up, core tight, and knees tracking over toes",
      "difficulty": "intermediate",
      "muscleGroups": ["quadriceps", "hamstrings", "glutes", "core"]
    },
    {
      "id": 2,
      "title": "Bench Press",
      "description": "Classic chest exercise. Lie on bench, grip barbell slightly wider than shoulders. Lower bar to chest, then press up with controlled movement.",
      "sets": "4 sets of 8-12 reps",
      "tips": "Keep wrists straight and elbows at 45-degree angle",
      "difficulty": "intermediate",
      "muscleGroups": ["chest", "triceps", "shoulders"]
    },
    {
      "id": 3,
      "title": "Deadlift",
      "description": "Full-body compound movement. Stand with feet hip-width apart, grip barbell with hands outside knees. Hinge at hips to lift bar, keeping back straight.",
      "sets": "3 sets of 6-8 reps",
      "tips": "Start with lighter weight to perfect form. Keep bar close to shins and thighs throughout movement",
      "difficulty": "advanced",
      "muscleGroups": ["back", "hamstrings", "glutes", "core"]
    }
  ]
}
EOF

# Create src/components/ExerciseCard.tsx
cat > src/components/ExerciseCard.tsx << 'EOF'
import React from 'react';
import { Exercise } from '../types';

interface ExerciseCardProps {
  exercise: Exercise;
  onNext: () => void;
  onPrev: () => void;
}

export const ExerciseCard: React.FC<ExerciseCardProps> = ({
  exercise,
  onNext,
  onPrev,
}) => {
  return (
    <div className="max-w-md mx-auto bg-white rounded-xl shadow-md overflow-hidden">
      <div className="p-8">
        <div className="uppercase tracking-wide text-sm text-indigo-500 font-semibold">
          {exercise.difficulty}
        </div>
        <h2 className="mt-1 text-xl font-medium text-gray-900">{exercise.title}</h2>
        <p className="mt-2 text-gray-500">{exercise.description}</p>
        <div className="mt-4">
          <h3 className="text-lg font-medium text-gray-900">Sets</h3>
          <p className="text-gray-500">{exercise.sets}</p>
        </div>
        <div className="mt-4">
          <h3 className="text-lg font-medium text-gray-900">Tips</h3>
          <p className="text-gray-500">{exercise.tips}</p>
        </div>
        <div className="mt-4">
          <h3 className="text-lg font-medium text-gray-900">Muscle Groups</h3>
          <div className="flex flex-wrap gap-2 mt-2">
            {exercise.muscleGroups.map((muscle) => (
              <span
                key={muscle}
                className="px-2 py-1 bg-gray-100 rounded-full text-sm text-gray-700"
              >
                {muscle}
              </span>
            ))}
          </div>
        </div>
      </div>
      <div className="px-8 pb-4 flex justify-between">
        <button
          onClick={onPrev}
          className="bg-gray-100 hover:bg-gray-200 text-gray-800 font-bold py-2 px-4 rounded-l"
        >
          Previous
        </button>
        <button
          onClick={onNext}
          className="bg-indigo-500 hover:bg-indigo-600 text-white font-bold py-2 px-4 rounded-r"
        >
          Next
        </button>
      </div>
    </div>
  );
};
EOF

# Create src/types.ts
cat > src/types.ts << 'EOF'
export interface Exercise {
  id: number;
  title: string;
  description: string;
  sets: string;
  tips: string;
  difficulty: 'beginner' | 'intermediate' | 'advanced';
  muscleGroups: string[];
}
EOF

# Create src/pages/_app.tsx
cat > src/pages/_app.tsx << 'EOF'
import '../styles/globals.css'
import type { AppProps } from 'next/app'

export default function App({ Component, pageProps }: AppProps) {
  return <Component {...pageProps} />
}
EOF

# Create src/pages/index.tsx
cat > src/pages/index.tsx << 'EOF'
import { useEffect, useState } from 'react'
import { ExerciseCard } from '../components/ExerciseCard'
import type { Exercise } from '../types'

export default function Home() {
  const [exercises, setExercises] = useState<Exercise[]>([])
  const [currentIndex, setCurrentIndex] = useState(0)

  useEffect(() => {
    fetch('/data/exercises.json')
      .then(res => res.json())
      .then(data => setExercises(data.exercises))
  }, [])

  const handleNext = () => {
    setCurrentIndex((prev) => (prev + 1) % exercises.length)
  }

  const handlePrev = () => {
    setCurrentIndex((prev) => (prev - 1 + exercises.length) % exercises.length)
  }

  if (exercises.length === 0) return <div>Loading...</div>

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="container mx-auto px-4">
        <h1 className="text-3xl font-bold text-center mb-8">
          Workout Guide
        </h1>
        <ExerciseCard
          exercise={exercises[currentIndex]}
          onNext={handleNext}
          onPrev={handlePrev}
        />
      </div>
    </div>
  )
}
EOF

# Create next.config.js
cat > next.config.js << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  distDir: 'www',
  images: {
    unoptimized: true
  },
  basePath: process.env.NEXT_PUBLIC_BASE_PATH || '',
}

module.exports = nextConfig
EOF

# Create tailwind.config.js
cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx}',
    './src/components/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

# Create CSS file
cat > src/styles/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
# dependencies
/node_modules
/.pnp
.pnp.js

# testing
/coverage

# next.js
/.next/
/out/
/www

# production
/build

# misc
.DS_Store
*.pem

# debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# local env files
.env*.local

# typescript
*.tsbuildinfo
next-env.d.ts
EOF

# Create GitHub Actions workflow for deployment
mkdir -p .github/workflows
cat > .github/workflows/deploy.yml << 'EOF'
name: Deploy to GitHub Pages

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Build
        run: npm run build
        env:
          NEXT_PUBLIC_BASE_PATH: /your-repo-name
          
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./www
EOF

# Print setup instructions
echo "==============================================="
echo "Project setup complete! Please run these commands in order:"
echo "==============================================="
echo "1. Clean up any existing installation:"
echo "   rm -rf node_modules package-lock.json .next www"
echo ""
echo "2. Install dependencies:"
echo "   npm install"
echo ""
echo "3. Start development server:"
echo "   npm run dev"
echo ""
echo "4. For production build:"
echo "   npm run build"
echo "   npm run serve"
echo ""
echo "View the development site at: http://localhost:3000"
echo ""
echo "Key Improvements:"
echo "- Added TypeScript support"
echo "- Updated to Next.js 14"
echo "- Converted YAML to JSON for better compatibility"
echo "- Added GitHub Actions workflow for automated deployment"
echo "- Improved component structure with separate ExerciseCard component"
echo "- Added proper typing for better development experience"
echo "- Enhanced exercise data structure with additional fields"
echo "==============================================="
