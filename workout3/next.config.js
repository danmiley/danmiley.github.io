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
