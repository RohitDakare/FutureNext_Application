import Link from "next/link";
import styles from "./page.module.css";

export default function Home() {
  return (
    <div className={styles.hero}>
      <h1 className={styles.title}>Unlock Your Future Next.</h1>
      <p className={styles.subtitle}>
        Identify your professional DNA and embark on a career journey that matches your personality, interests, and potential.
      </p>
      
      <div className={styles.features}>
        <div className="card">
          <div className={styles.icon}>🎯</div>
          <h3>RIASEC Framework</h3>
          <p>Utilize globally recognized psychological models to map your unique personality traits to success.</p>
        </div>
        <div className="card">
          <div className={styles.icon}>💡</div>
          <h3>Smart Insights</h3>
          <p>Access deep data on salaries, top-tier global colleges, and the essential skills for your dream career.</p>
        </div>
        <div className="card">
          <div className={styles.icon}>✨</div>
          <h3>AI Guidance</h3>
          <p>Receive personalized career roadmaps and expert guidance tailored precisely to your specific goals.</p>
        </div>
      </div>

      <div className={styles.cta}>
        <Link href="/quiz" className="btn btn-primary" style={{ padding: "1.2rem 3rem", fontSize: "1.25rem" }}>
          Begin Your Discovery
        </Link>
      </div>
    </div>
  );
}
