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
      <div className="nav-actions">
        <Link href="/" className="nav-link home-link">Home</Link>
        {isLoggedIn ? (
          <>
            <Link href="/quiz" className="btn btn-primary nav-btn">Take Quiz</Link>
            <button onClick={handleLogout} className="btn nav-logout">Logout</button>
          </>
        ) : (
          <>
            <Link href="/login" className="nav-link login-link">Login</Link>
            <Link href="/signup" className="btn btn-primary nav-btn">Sign Up</Link>
          </>
        )}
      </div>
    </nav>
  );
}
