"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { loginUser } from "@/lib/api";
import styles from "../auth/auth.module.css";

export default function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError("");

    try {
      const data = await loginUser(email, password);
      localStorage.setItem("access_token", data.access_token);
      router.push("/");
      // force reload to update auth state across app if needed
      window.location.href = "/";
    } catch (err: any) {
      setError(err.message || "Failed to log in");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className={styles.page}>
      <div className={styles.content}>
        <div className={styles.logoCircle}>🧭</div>
        <div className={styles.title}>Welcome Back!</div>
        <div className={styles.subtitle}>Log in to continue your career journey</div>

        {error && <div className={styles.errorBox}>{error}</div>}

        <form onSubmit={handleLogin}>
          <div className={styles.fieldWrap}>
            <div className={styles.fieldIcon}>✉️</div>
            <input
              className={styles.input}
              type="email"
              required
              placeholder="Email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />
          </div>

          <div style={{ height: 14 }} />

          <div className={styles.fieldWrap}>
            <div className={styles.fieldIcon}>🔒</div>
            <input
              className={styles.input}
              type="password"
              required
              placeholder="Password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
          </div>

          <button type="submit" className={styles.primaryButton} disabled={loading}>
            {loading ? <span className={styles.spinner} /> : "Log In"}
          </button>
        </form>

        <div className={styles.footerText}>
          Don&apos;t have an account?{" "}
          <a className={styles.footerLink} href="/signup">
            Sign up
          </a>
        </div>
      </div>
    </div>
  );
}
