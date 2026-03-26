"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import styles from "./quiz.module.css";
import { fetchDynamicQuestions, submitQuizAnswers } from "@/lib/api";
import { RIASEC_TYPES, type RiasecCode } from "@/lib/riasec";

interface QuestionOption {
  text: string;
  category: string;
}

interface Question {
  id: string;
  text: string;
  emoji: string;
  category?: string;
  options?: QuestionOption[];
}

function toRiasecCode(code: string | undefined): RiasecCode {
  const normalized = (code ?? "R").toUpperCase();
  if (normalized === "R") return "R";
  if (normalized === "I") return "I";
  if (normalized === "A") return "A";
  if (normalized === "S") return "S";
  if (normalized === "E") return "E";
  if (normalized === "C") return "C";
  return "R";
}

function hexToRgba(hex: string, alpha: number) {
  const clean = hex.replace("#", "");
  const full = clean.length === 3 ? clean.split("").map((c) => c + c).join("") : clean;
  const r = parseInt(full.slice(0, 2), 16);
  const g = parseInt(full.slice(2, 4), 16);
  const b = parseInt(full.slice(4, 6), 16);
  return `rgba(${r}, ${g}, ${b}, ${alpha})`;
}

export default function Quiz() {
  const [questions, setQuestions] = useState<Question[]>([]);
  const [answers, setAnswers] = useState<Record<string, string | number>>({});
  const [currentIndex, setCurrentIndex] = useState(0);
  const [loading, setLoading] = useState(true);
  const router = useRouter();
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const token = localStorage.getItem("access_token");
    if (!token) {
      router.push("/login");
      return;
    }

    fetchDynamicQuestions([])
      .then(data => {
        setQuestions(data);
        setLoading(false);
      })
      .catch(err => {
        setError("Could not load dynamic questions. Check your Gemini API key.");
        setLoading(false);
      });
  }, [router]);

  const handleAnswer = (val: string | number) => {
    const activeQ = questions[currentIndex];
    const newAnswers = { ...answers, [activeQ.id]: val };
    setAnswers(newAnswers);

    if (currentIndex < questions.length - 1) {
      setCurrentIndex(currentIndex + 1);
    } else {
      submitQuiz(newAnswers);
    }
  };

  const submitQuiz = async (finalAnswers: Record<string, string | number>) => {
    try {
      setLoading(true);
      const result = await submitQuizAnswers(finalAnswers);
      localStorage.setItem("quizResult", JSON.stringify(result));
      router.push("/results");
    } catch (err) {
      setError("Failed to submit results.");
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className={styles.loadingShell}>
        <div>
          <div className={styles.loadingSpinner} />
          <div style={{ fontWeight: 800, color: "rgba(255, 255, 255, 0.75)" }}>Loading your questions...</div>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className={styles.loadingShell}>
        <div style={{ color: "var(--coral)", fontWeight: 800 }}>{error}</div>
      </div>
    );
  }

  if (questions.length === 0) return null;

  const currentQ = questions[currentIndex];
  const riasecCode = toRiasecCode(currentQ.category ?? currentQ.options?.[0]?.category);
  const riasecType = RIASEC_TYPES[riasecCode] ?? RIASEC_TYPES.R;
  const progress = ((currentIndex + 1) / questions.length) * 100;
  const borderColor = hexToRgba(riasecType.color, 0.25);

  return (
    <div className={styles.shell}>
      <header className={styles.appBar} style={{ backgroundColor: riasecType.color }}>
        <div className={styles.appBarLeft}>
          <button
            className={styles.iconBtn}
            onClick={() => setCurrentIndex((i) => Math.max(0, i - 1))}
            disabled={currentIndex === 0}
            aria-label="Previous question"
          >
            ←
          </button>
        </div>
        <div className={styles.appBarTitle}>{riasecType.name}</div>
        <div className={styles.appBarIndex}>
          {currentIndex + 1}/{questions.length}
        </div>
      </header>

      <div className={styles.progressBarWrap}>
        <div className={styles.progressBar}>
          <div className={styles.progressFill} style={{ width: `${progress}%` }} />
        </div>
      </div>

      <div className={styles.content}>
        <div className={styles.questionCard}>
          <div className={styles.topStrip} style={{ backgroundColor: riasecType.color }} />
          <div className={styles.questionBody}>
            <div className={styles.emoji}>{currentQ.emoji}</div>

            <div className={styles.questionText}>{currentQ.text}</div>

            <div className={styles.options}>
              {currentQ.options && currentQ.options.length > 0 ? (
                currentQ.options.map((opt, idx) => (
                  <button
                    key={`${opt.text}-${idx}`}
                    className={styles.optionBtn}
                    style={{ borderColor }}
                    onClick={() => handleAnswer(opt.category)}
                  >
                    {opt.text}
                  </button>
                ))
              ) : (
                [1, 2, 3, 4, 5].map((num) => (
                  <button
                    key={num}
                    className={styles.optionBtn}
                    style={{ borderColor }}
                    onClick={() => handleAnswer(num)}
                  >
                    {num}
                  </button>
                ))
              )}
            </div>
          </div>
        </div>

        <div className={styles.tagline} style={{ color: riasecType.color }}>
          {riasecType.tagline}
        </div>
      </div>
    </div>
  );
}

