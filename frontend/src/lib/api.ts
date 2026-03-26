const API_BASE = process.env.NEXT_PUBLIC_API_URL || "http://localhost:8000/api";

export function getAuthHeader(): Record<string, string> {
  const token = typeof window !== 'undefined' ? localStorage.getItem("access_token") : null;
  return token ? { Authorization: `Bearer ${token}` } : {};
}

export async function fetchQuestions() {
  const res = await fetch(`${API_BASE}/questions`, { cache: 'no-store' });
  if (!res.ok) throw new Error("Failed to fetch questions");
  return res.json();
}

export async function fetchDynamicQuestions(previous_questions: string[] = []) {
  const res = await fetch(`${API_BASE}/questions/generate`, {
    method: "POST",
    headers: { "Content-Type": "application/json", ...(getAuthHeader() as Record<string, string>) },
    body: JSON.stringify({ previous_questions }),
  });
  if (!res.ok) throw new Error("Failed to fetch dynamic questions");
  return res.json();
}

export async function submitQuizAnswers(answers: Record<string, string | number>) {
  const res = await fetch(`${API_BASE}/quiz/submit`, {
    method: "POST",
    headers: { "Content-Type": "application/json", ...(getAuthHeader() as Record<string, string>) },
    body: JSON.stringify({ answers }),
  });
  if (!res.ok) throw new Error("Failed to submit quiz results");
  return res.json();
}

export async function loginUser(email: string, password: string) {
  const formData = new URLSearchParams();
  formData.append("username", email);
  formData.append("password", password);

  const res = await fetch(`${API_BASE}/login`, {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: formData.toString()
  });
  if (!res.ok) throw new Error("Login failed");
  return res.json();
}

export async function signupUser(email: string, password: string) {
  const res = await fetch(`${API_BASE}/signup`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, password }),
  });
  if (!res.ok) throw new Error("Signup failed: Email might be taken");
  return res.json();
}
