"use client";

export default function Error({
  error,
  reset,
}: {
  error: globalThis.Error & { digest?: string };
  reset: () => void;
}) {
  // `error.tsx` is a special Next.js file. Keep it client-side because we
  // call `reset()` via an event handler.
  console.error(error);

  return (
    <div className="container" style={{ paddingTop: "6rem", textAlign: "center" }}>
      <h2 style={{ color: "var(--coral)", fontSize: "2rem", marginBottom: "1rem" }}>Something went wrong!</h2>
      <p style={{ marginBottom: "2rem", color: "var(--secondary-text)" }}>
        We encountered an unexpected error while loading this page.
      </p>
      <button
        className="btn btn-primary"
        onClick={() => reset()}
      >
        Try again
      </button>
    </div>
  );
}
