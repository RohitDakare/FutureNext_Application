"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import styles from "./results.module.css";
import { RIASEC_TYPES, type RiasecCode } from "@/lib/riasec";
import SimpleRadarChart from "@/components/SimpleRadarChart";
import ReactMarkdown from "react-markdown";

interface Career {
  title: string;
  code: string;
  emoji: string;
  description: string;
  stream: string;
  salary: string;
  growth: string;
  education: string;
  skills: string[];
}

interface QuizResult {
  scores: Record<string, number>;
  top_categories: string[];
  recommended_careers: Career[];
  career_guidance?: string;
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

export default function Results() {
  const [result, setResult] = useState<QuizResult | null>(null);
  const router = useRouter();

  useEffect(() => {
    const saved = localStorage.getItem("quizResult");
    if (!saved) {
      router.push("/");
    } else {
      setResult(JSON.parse(saved));
    }
  }, [router]);

  if (!result) return <div className="container" style={{paddingTop: '4rem', textAlign: 'center'}}>Loading results...</div>;

  const res = result;

  const topCodes = (res.top_categories ?? []).slice(0, 3);
  const hollandCode = topCodes.join("");
  const topTypes = topCodes.map((c) => RIASEC_TYPES[toRiasecCode(c)] ?? RIASEC_TYPES.R);
  const dominantType = topTypes[0] ?? RIASEC_TYPES.R;
  const topTypeNames = topTypes.map((t) => t.name).join("-");

  const streamCounts: Record<string, number> = {};
  res.recommended_careers?.forEach((c) => {
    if (c.stream) {
      streamCounts[c.stream] = (streamCounts[c.stream] || 0) + 1;
    }
  });

  let bestStream = dominantType.recommendedStream;
  let maxCount = 0;
  for (const [stream, count] of Object.entries(streamCounts)) {
    if (count > maxCount) {
      maxCount = count;
      bestStream = stream;
    }
  }
  const recommendedStream = bestStream;

  const handleShare = async () => {
    const nameStr = "my";
    const analysis = topTypes.map((t) => t.name).join("-");
    const text = `Hey! ${nameStr} Holland personality code is ${hollandCode} on FutureNex! Analysis: ${analysis}. Check it out!`;

    try {
      // Web Share API (mobile-friendly)
      if (navigator.share) {
        await navigator.share({ text });
        return;
      }
    } catch {
      // ignore and fallback to clipboard
    }

    try {
      await navigator.clipboard.writeText(text);
      alert("Share text copied to clipboard.");
    } catch {
      // final fallback
      window.prompt("Copy this text:", text);
    }
  };

  const retakeQuiz = () => {
    localStorage.removeItem("quizResult");
    router.push("/quiz");
  };

  return (
    <div className={styles.shell}>
      <button className={styles.shareBtn} onClick={handleShare} aria-label="Share results">
        ⇪
      </button>

      <div className={styles.header}>
        <div className={styles.kicker}>Your Holland Code</div>
        <div className={styles.hollandBadge}>{hollandCode}</div>

        <div className={styles.personalTitle}>Your Personal Holland Code</div>
        <div className={styles.personalText}>
          This means you are a {topTypeNames} personality!
        </div>
      </div>

      <div className={styles.radarWrap}>
        <SimpleRadarChart scores={res.scores} accentColor={dominantType.color} />
      </div>

      {res.career_guidance && (
        <div className={styles.aiCard}>
          <div className={styles.aiHeader}>
            <span aria-hidden="true">✨</span>
            <span>AI Personalized Guidance</span>
          </div>
          <div className={styles.aiBody}>
            <ReactMarkdown>{res.career_guidance || ""}</ReactMarkdown>
          </div>
        </div>
      )}

      <div className={styles.topTypes}>
        {topTypes.map((type) => (
          <div key={type.code} className={styles.riasecCard}>
            <div
              className={styles.riasecHeader}
              style={{
                background: `linear-gradient(135deg, ${type.color}, ${hexToRgba(type.color, 0.7)})`,
              }}
            >
              <div className={styles.riasecHeaderRow}>
                <div className={styles.riasecEmoji}>{type.emoji}</div>
                <div>
                  <div className={styles.riasecName}>{type.name}</div>
                  <div className={styles.riasecTagline}>{type.tagline}</div>
                </div>
              </div>
            </div>

            <div className={styles.riasecBody}>
              <div className={styles.riasecBodyTitle}>What this means for you:</div>
              <div className={styles.riasecDescription}>{type.description}</div>

              <div className={styles.traits}>
                {type.traits.map((trait) => (
                  <div
                    key={trait}
                    className={styles.traitChip}
                    style={{
                      background: hexToRgba(type.color, 0.1),
                      color: type.color,
                    }}
                  >
                    {trait}
                  </div>
                ))}
              </div>

              <div className={styles.activitiesTitle}>Activities you'd love:</div>
              <div className={styles.activitiesList}>
                {type.activities.map((act) => (
                  <div key={act} className={styles.activityRow}>
                    <div className={styles.activityIcon} style={{ color: type.color }} aria-hidden="true">
                      ✔
                    </div>
                    <div>{act}</div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        ))}
      </div>

      <div className={styles.streamCard}>
        <div className={styles.streamTitle}>🎓 Recommended Stream</div>
        <div className={styles.streamValue}>{recommendedStream}</div>
        <div className={styles.streamDesc}>
          Based on your dominant personality type, this stream will help you excel and stay happy in your studies!
        </div>
      </div>

      <div className={styles.cta}>
        <button
          className={styles.ctaPrimaryButton}
          onClick={() => router.push("/careers")}
          type="button"
        >
          Explore Your Careers ✨
        </button>

        <button className={styles.ctaTextButton} onClick={retakeQuiz} type="button">
          <span aria-hidden="true">↻</span> Retake Quiz
        </button>
      </div>
    </div>
  );
}

