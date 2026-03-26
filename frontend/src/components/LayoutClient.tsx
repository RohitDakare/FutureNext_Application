"use client";

import { useEffect } from "react";
import { usePathname } from "next/navigation";
import type { ReactNode } from "react";
import Navbar from "./Navbar";

export default function LayoutClient({ children }: { children: ReactNode }) {
  const pathname = usePathname();

  useEffect(() => {
    const handleUnhandledRejection = (event: PromiseRejectionEvent) => {
      // Suppress annoying MetaMask extension errors that are not caused by our app
      if (
        event.reason?.message?.includes("MetaMask") ||
        event.reason?.includes?.("MetaMask") ||
        (event.reason?.stack && event.reason.stack.includes("chrome-extension"))
      ) {
        event.preventDefault();
        console.warn("Suppressed extension-related unhandled rejection:", event.reason?.message || event.reason);
      }
    };

    window.addEventListener("unhandledrejection", handleUnhandledRejection);
    return () => window.removeEventListener("unhandledrejection", handleUnhandledRejection);
  }, []);

  const hideChrome =
    pathname === "/login" ||
    pathname === "/signup";

  if (hideChrome) return <>{children}</>;

  return (
    <div className="container">
      <Navbar />
      <main className="animate-up">{children}</main>
    </div>
  );
}

