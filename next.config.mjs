/** @type {import('next').NextConfig} */
const nextConfig = {
  webpack: (config) => {
    // Add the MiniCssExtractPlugin
    // This is already registered by Next.js, so we don't need to add it again
    
    return config;
  },
  experimental: {
    optimizeFonts: true
  },
  assetPrefix: process.env.NODE_ENV === 'production' ? undefined : '',
  reactStrictMode: true
};

export default nextConfig;
