"use client";

import { useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import styles from "./careers.module.css";
import { RIASEC_TYPES, type RiasecCode } from "@/lib/riasec";

type Career = {
  title: string;
  code: string;
  emoji: string;
  description: string;
  stream: string;
  salary: string;
  growth: string;
  education: string;
  skills: string[];
  riasec_codes?: string[];
};

type QuizResult = {
  scores: Record<string, number>;
  top_categories: string[];
  recommended_careers: Career[];
};

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

export default function Careers() {
  const router = useRouter();
  const [scores, setScores] = useState<Record<string, number>>({});
  const [hollandCode, setHollandCode] = useState("");
  const [careers, setCareers] = useState<Career[]>([]);
  const [selectedStream, setSelectedStream] = useState<"All" | "Science" | "Commerce" | "Arts">("All");
  const [activeCareer, setActiveCareer] = useState<Career | null>(null);

  useEffect(() => {
    const saved = localStorage.getItem("quizResult");
    if (!saved) {
      router.push("/");
      return;
    }

    const parsed = JSON.parse(saved) as QuizResult;
    setScores(parsed.scores ?? {});
    setHollandCode((parsed.top_categories ?? []).slice(0, 3).join(""));
    setCareers(parsed.recommended_careers ?? []);
  }, [router]);

  const filteredCareers = useMemo(() => {
    if (selectedStream === "All") return careers;
    return careers.filter((c) => c.stream === selectedStream);
  }, [careers, selectedStream]);

  const userPercent = useMemo(() => {
    const vals = Object.values(scores);
    const max = Math.max(...vals, 1);
    const codes = ["R", "I", "A", "S", "E", "C"] as RiasecCode[];
    const map: Record<RiasecCode, number> = {
      R: 0,
      I: 0,
      A: 0,
      S: 0,
      E: 0,
      C: 0,
    };
    codes.forEach((code) => {
      map[code] = ((scores[code] ?? 0) / max) * 100;
    });
    return map;
  }, [scores]);

  const calculateMatchScore = (career: Career) => {
    const riasecCodes = (career.riasec_codes ?? []).slice(0, 3);
    let score = 0;
    for (let i = 0; i < riasecCodes.length; i++) {
      const code = toRiasecCode(riasecCodes[i]);
      const userScore = userPercent[code] ?? 0;
      if (i === 0) score += userScore * 0.5;
      if (i === 1) score += userScore * 0.3;
      if (i === 2) score += userScore * 0.2;
    }
    return Math.max(0, Math.min(100, score));
  };

  const getMatchColor = (matchScore: number) => {
    if (matchScore > 80) return RIASEC_TYPES.I.color; // mint
    if (matchScore > 50) return RIASEC_TYPES.S.color; // accent
    return RIASEC_TYPES.R.color; // coral
  };

  const filters: Array<"All" | "Science" | "Commerce" | "Arts"> = ["All", "Science", "Commerce", "Arts"];

  const closeModal = () => setActiveCareer(null);

  return (
    <div className={styles.shell}>
      <div className={styles.hero}>
        <div className={styles.heroInner}>
          <button
            type="button"
            className={styles.backBtn}
            onClick={() => router.push("/results")}
            aria-label="Back to results"
          >
            ←
          </button>
          <div className={styles.heroKicker}>Based on your {hollandCode || "RIASEC"} personality</div>
          <div className={styles.heroTitle}>
            Careers Made
            {"\n"}
            For You ✨
          </div>
        </div>
      </div>

      <div className={styles.filterBar}>
        <div className={styles.filterList}>
          {filters.map((f) => {
            const selected = selectedStream === f;
            return (
              <button
                key={f}
                type="button"
                className={`${styles.filterChip} ${selected ? styles.filterChipSelected : ""}`}
                onClick={() => setSelectedStream(f)}
              >
                {selected && <span aria-hidden="true">✓</span>}
                {f}
              </button>
            );
          })}
        </div>
      </div>

      <div className={styles.grid}>
        {filteredCareers.map((career) => {
          const matchScore = calculateMatchScore(career);
          const matchColor = getMatchColor(matchScore);
          const streamColor =
            career.stream === "Science"
              ? RIASEC_TYPES.I.color
              : career.stream === "Commerce"
                ? RIASEC_TYPES.S.color
                : RIASEC_TYPES.A.color;
          return (
            <button
              key={career.code}
                type="button"
                onClick={() => setActiveCareer(career)}
                className={styles.careerCard}
                style={{ padding: 0 }}
            >
                <div className={styles.careerBox}>
                  <div className={styles.careerTop}>
                    <div className={styles.careerEmoji}>{career.emoji}</div>
                    <div
                      className={styles.matchBadge}
                      style={{
                        background: matchColor,
                        boxShadow: `0 10px 18px ${hexToRgba(matchColor, 0.35)}`,
                      }}
                    >
                      {Math.round(matchScore)}% Match
                    </div>
                  </div>

                  <div className={styles.careerBody}>
                    <div className={styles.careerTitle}>{career.title}</div>

                    <div className={styles.growthRow}>
                      <span className={styles.growthIcon} aria-hidden="true">
                        📈
                      </span>
                      {career.growth}
                    </div>

                    <div
                      className={styles.streamChip}
                      style={{
                        background: hexToRgba(streamColor, 0.12),
                        color: streamColor,
                      }}
                    >
                      {career.stream}
                    </div>
                  </div>
                </div>
              </button>
          );
        })}
      </div>

      {activeCareer && (
        <div
          className={styles.modalOverlay}
          role="dialog"
          aria-modal="true"
          onMouseDown={(e) => {
            if (e.target === e.currentTarget) closeModal();
          }}
        >
          <div className={styles.modalSheet}>
            <button type="button" className={styles.modalClose} onClick={closeModal} aria-label="Close">
              ✕
            </button>

            <div className={styles.modalTop}>
              <div className={styles.modalEmoji}>{activeCareer.emoji}</div>
              <div className={styles.modalTitle}>{activeCareer.title}</div>

              {(() => {
                const matchScore = calculateMatchScore(activeCareer);
                const matchColor = getMatchColor(matchScore);
                return (
                  <div
                    className={styles.modalMatch}
                    style={{
                      background: hexToRgba(matchColor, 0.1),
                      border: `1px solid ${hexToRgba(matchColor, 0.35)}`,
                      color: matchColor,
                    }}
                  >
                    {Math.round(matchScore)}% Personality Match
                  </div>
                );
              })()}
            </div>

            <div className={styles.modalSectionTitle}>What will you do?</div>
            <div className={styles.modalText}>{activeCareer.description}</div>

            <div className={styles.modalSectionTitle}>How to reach here? 🎓</div>
            <div className={styles.modalText}>{activeCareer.education}</div>

            <div className={styles.modalSectionTitle}>Skills you'll develop ✨</div>
            <div className={styles.skillChips}>
              {(activeCareer.skills ?? []).slice(0, 12).map((s) => (
                <div key={s} className={styles.skillChip}>
                  {s}
                </div>
              ))}
            </div>

            <button type="button" className={styles.modalPrimaryBtn} onClick={closeModal}>
              Save This Career 🔖
            </button>
          </div>
        </div>
      )}
    </div>
  );
}

