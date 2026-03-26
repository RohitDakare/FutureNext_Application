"use client";

import { usePathname } from "next/navigation";
import type { ReactNode } from "react";
import Navbar from "./Navbar";

export default function LayoutClient({ children }: { children: ReactNode }) {
  const pathname = usePathname();

  const hideChrome =
    pathname === "/login" ||
    pathname === "/signup" ||
    pathname === "/quiz" ||
    pathname === "/results" ||
    pathname === "/careers";

  if (hideChrome) return <>{children}</>;

  return (
    <div className="container">
      <Navbar />
      <main className="animate-up">{children}</main>
    </div>
  );
}

