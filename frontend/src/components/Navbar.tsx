"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";

export default function Navbar() {
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const router = useRouter();

  useEffect(() => {
    const token = localStorage.getItem("access_token");
    setIsLoggedIn(!!token);
  }, []);

  const handleLogout = () => {
    localStorage.removeItem("access_token");
    setIsLoggedIn(false);
    router.push("/login");
  };

  return (
    <nav>
      <Link href="/" className="logo-wrapper">
        <div className="logo-icon">🧭</div>
        <div className="logo-text">
          Future<span>Next</span><span className="logo-dot">.</span>
        </div>
      </Link>
      <div style={{ display: 'flex', alignItems: 'center', gap: '32px' }}>
        <Link href="/" className="nav-link">Home</Link>
        {isLoggedIn ? (
          <>
            <Link href="/quiz" className="btn btn-primary">Take Quiz</Link>
            <button onClick={handleLogout} className="btn" style={{ fontWeight: 700, color: 'var(--coral)', background: 'transparent', padding: '0 8px' }}>Logout</button>
          </>
        ) : (
          <>
            <Link href="/login" className="nav-link">Login</Link>
            <Link href="/signup" className="btn btn-primary">Sign Up</Link>
          </>
        )}
      </div>
    </nav>
  );
}
