export type RiasecCode = "R" | "I" | "A" | "S" | "E" | "C";

export type RiasecType = {
  code: RiasecCode;
  name: string;
  emoji: string;
  tagline: string;
  description: string;
  traits: string[];
  activities: string[];
  recommendedStream: string;
  color: string; // hex, e.g. #FF6B6B
};

// Ported from Flutter's `lib/data/onet_data.dart` + `lib/models/riasec_type.dart`.
export const RIASEC_TYPES: Record<RiasecCode, RiasecType> = {
  R: {
    code: "R",
    name: "Builder",
    emoji: "🛠️",
    tagline: "The Realistic Doer",
    description:
      "You love physical activity and working with tools, machines, or animals. You prefer practical and hands-on tasks over words or theories.",
    traits: ["Practical", "Persistent", "Genuine", "Adventurous"],
    activities: ["Fixing electronics", "Playing sports", "Gardening", "Woodworking"],
    recommendedStream: "Science or Vocational",
    color: "#FF6B6B",
  },
  I: {
    code: "I",
    name: "Thinker",
    emoji: "🔍",
    tagline: "The Investigative Researcher",
    description:
      "You are curious and love to solve puzzles. You enjoy analyzing data, conducting experiments, and exploring how things work.",
    traits: ["Analytical", "Curious", "Independent", "Precise"],
    activities: ["Coding", "Reading science news", "Solving puzzles", "Observing nature"],
    recommendedStream: "Science",
    color: "#4ECDC4",
  },
  A: {
    code: "A",
    name: "Creator",
    emoji: "🎨",
    tagline: "The Artistic Imagineer",
    description:
      "You are expressive and imaginative. You prefer working in unstructured environments where you can use your creativity to design or perform.",
    traits: ["Creative", "Expressive", "Idealistic", "Original"],
    activities: ["Painting", "Writing stories", "Playing music", "Graphic design"],
    recommendedStream: "Arts or Design",
    color: "#9B5DE5",
  },
  S: {
    code: "S",
    name: "Helper",
    emoji: "🤝",
    tagline: "The Social Supporter",
    description:
      "You are kind and love working with people. You enjoy teaching, healing, training, or providing care to others in your community.",
    traits: ["Empathetic", "Friendly", "Generous", "Cooperative"],
    activities: ["Volunteering", "Teaching friends", "Social work", "Counseling"],
    recommendedStream: "Arts or Commerce",
    color: "#FFB627",
  },
  E: {
    code: "E",
    name: "Leader",
    emoji: "⚡",
    tagline: "The Enterprising Persuader",
    description:
      "You are confident and natural at leading. You enjoy influencing others, running projects, and making big decisions to achieve goals.",
    traits: ["Ambitious", "Energetic", "Extroverted", "Optimistic"],
    activities: ["Debating", "Selling things", "Starting projects", "Public speaking"],
    recommendedStream: "Commerce",
    color: "#FF8E3C",
  },
  C: {
    code: "C",
    name: "Organizer",
    emoji: "📋",
    tagline: "The Conventional Planner",
    description:
      "You are methodical and detail-oriented. You love organizing data, following clear instructions, and ensuring everything is in order.",
    traits: ["Efficient", "Methodical", "Orderly", "Thorough"],
    activities: ["Managing money", "Organizing files", "Planning events", "Editing documents"],
    recommendedStream: "Commerce",
    color: "#90A4AE",
  },
};

