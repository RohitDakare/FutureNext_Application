import { RIASEC_TYPES, type RiasecCode } from "@/lib/riasec";

const ORDER: RiasecCode[] = ["R", "I", "A", "S", "E", "C"];

export default function SimpleRadarChart({
  scores,
  accentColor = "#4ECDC4",
}: {
  scores: Record<string, number>;
  accentColor?: string;
}) {
  const values = ORDER.map((code) => Number(scores[code] ?? 0));
  const max = Math.max(...values, 1);
  const normalized = values.map((v) => v / max);

  // Simple 6-axis radar chart (not a full-featured chart library).
  const cx = 160;
  const cy = 120;
  const r = 95;
  const step = (Math.PI * 2) / ORDER.length;
  const startAngle = -Math.PI / 2;

  const pointForIndex = (i: number, scale: number) => {
    const angle = startAngle + i * step;
    const rr = r * scale;
    const x = cx + rr * Math.cos(angle);
    const y = cy + rr * Math.sin(angle);
    return { x, y };
  };

  const dataPoints = normalized.map((s, i) => pointForIndex(i, s));
  const dataPolygon = dataPoints.map((p) => `${p.x.toFixed(2)},${p.y.toFixed(2)}`).join(" ");

  const gridPolygons = [0.25, 0.5, 0.75, 1].map((scale) =>
    ORDER.map((_, i) => pointForIndex(i, scale)).map((p) => `${p.x.toFixed(2)},${p.y.toFixed(2)}`).join(" ")
  );

  return (
    <svg width="100%" height="100%" viewBox="0 0 320 240" role="img" aria-label="Radar chart">
      <defs>
        <linearGradient id="radarFill" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stopColor={accentColor} stopOpacity="0.35" />
          <stop offset="100%" stopColor="#4ECDC4" stopOpacity="0.15" />
        </linearGradient>
      </defs>

      {gridPolygons.map((poly, idx) => (
        <polygon
          key={idx}
          points={poly}
          fill="none"
          stroke="rgba(13, 27, 42, 0.12)"
          strokeWidth={1}
        />
      ))}

      {/* Axis lines */}
      {ORDER.map((code, i) => {
        const p = pointForIndex(i, 1);
        return <line key={code} x1={cx} y1={cy} x2={p.x} y2={p.y} stroke="rgba(13, 27, 42, 0.1)" strokeWidth={1} />;
      })}

      <polygon points={dataPolygon} fill="url(#radarFill)" stroke={accentColor} strokeWidth={2} />

      {/* Axis labels (emoji + code) */}
      {ORDER.map((code, i) => {
        const p = pointForIndex(i, 1.12);
        const t = RIASEC_TYPES[code];
        return (
          <text
            key={code}
            x={p.x}
            y={p.y}
            textAnchor="middle"
            dominantBaseline="middle"
            fontSize="12"
            fontWeight={800}
            fill="rgba(26, 26, 46, 0.55)"
          >
            {t.emoji}
          </text>
        );
      })}
    </svg>
  );
}

