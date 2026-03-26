"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { signupUser } from "@/lib/api";
import styles from "../auth/auth.module.css";

export default function Signup() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  const handleSignup = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError("");

    try {
      await signupUser(email, password);
      router.push("/login?registered=true");
    } catch (err: any) {
      setError(err.message || "Failed to sign up");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className={styles.page}>
      <a
        className={styles.backLink}
        href="#"
        onClick={(e) => {
          e.preventDefault();
          router.back();
        }}
      >
        <span aria-hidden="true">←</span> Back
      </a>

      <div className={styles.content}>
        <div style={{ height: 40 }} />
        <div className={styles.title}>Create Account</div>
        <div className={styles.subtitle}>Join thousands of students discovering their path</div>

        {error && <div className={styles.errorBox}>{error}</div>}

        <form onSubmit={handleSignup}>
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
            {loading ? <span className={styles.spinner} /> : "Sign Up"}
          </button>
        </form>

        <div className={styles.footerText}>
          Already have an account?{" "}
          <a className={styles.footerLink} href="/login">
            Sign in here
          </a>
        </div>
      </div>
    </div>
  );
}
