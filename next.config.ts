import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Las server actions serializan el `File` del avatar completo en el body.
  // El default de Next (1 MB) queda por debajo del límite de dominio
  // AVATAR_MAX_BYTES (2 MB, spec 02): un avatar válido de hasta 2 MB fallaría
  // con "Body exceeded 1 MB limit". 3 MB deja margen de overhead.
  experimental: {
    serverActions: {
      bodySizeLimit: "3mb",
    },
  },
};

export default nextConfig;
