import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: 'standalone',
  // Fix Turbopack root inference when the repo contains multiple package-lock.json files.
  turbopack: {
    root: __dirname,
  },
  // If you access the dev server via LAN IP (192.168.x.x), allow that origin for HMR.
  allowedDevOrigins: ["192.168.126.1"],
};

export default nextConfig;
