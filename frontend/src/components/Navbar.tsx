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
    <nav className="glass">
      <div className="logo">
        <Link href="/">Future Next.</Link>
      </div>
      <div style={{ display: 'flex', alignItems: 'center', gap: '20px' }}>
        <Link href="/" style={{ fontWeight: 600, color: 'var(--primary)' }}>Home</Link>
        {isLoggedIn ? (
          <>
            <Link href="/quiz" className="btn btn-primary">Take Quiz</Link>
            <button onClick={handleLogout} className="btn" style={{ fontWeight: 600, color: 'var(--coral)', background: 'transparent' }}>Logout</button>
          </>
        ) : (
          <>
            <Link href="/login" style={{ fontWeight: 600, color: 'var(--primary)' }}>Login</Link>
            <Link href="/signup" className="btn btn-primary">Sign Up</Link>
          </>
        )}
      </div>
    </nav>
  );
}
