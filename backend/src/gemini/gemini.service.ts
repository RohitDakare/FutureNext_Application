import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { GoogleGenerativeAI } from '@google/generative-ai';

@Injectable()
export class GeminiService {
  private genAI: GoogleGenerativeAI;
  private model: any;

  constructor(private configService: ConfigService) {
    const apiKey = this.configService.get<string>('GEMINI_API_KEY') || 'dummy_key';
    this.genAI = new GoogleGenerativeAI(apiKey);
    this.model = this.genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });
  }

  async generateDynamicQuestions(previousQuestions: string[]) {
    const prompt = `
    You are an expert career counselor. Generate exactly 25 unique multiple-choice questions for a career interest test.
    Each question should be a scenario or preference question.
    Each question should have 4 unique options.
    Each option must be associated with one of the 6 RIASEC categories (Realistic, Investigative, Artistic, Social, Enterprising, Conventional).
    
    Please return ONLY a JSON array of objects.
    Each object must have the following keys:
    "id": a unique string identifier
    "text": the question text (e.g. "What kind of project would you enjoy most?")
    "emoji": a relevant emoji
    "options": an array of 4 objects, each with:
        "text": the option text (e.g. "Repairing a broken engine")
        "category": the category it represents ("R", "I", "A", "S", "E", or "C")

    IMPORTANT: Do NOT repeat any concepts from the following previous questions (if any):
    ${JSON.stringify(previousQuestions)}

    Ensure the response is raw JSON without Markdown formatting backticks.
    `;

    try {
      const result = await this.model.generateContent(prompt);
      const response = await result.response;
      let text = response.text().trim();
      
      // Remove markdown backticks if present
      if (text.startsWith('```json')) text = text.substring(7);
      if (text.startsWith('```')) text = text.substring(3);
      if (text.endsWith('```')) text = text.substring(0, text.length - 3);

      const parsed = JSON.parse(text);
      if (Array.isArray(parsed)) return parsed.slice(0, 25);
      throw new Error('Invalid JSON format from AI');
    } catch (error) {
      console.error('Error generating questions:', error);
      // First 25-question Fallback set (RIASEC balanced)
      return [
        { id: 'fb_1', text: 'Which activity would you prefer on a weekend morning?', emoji: '🎨', options: [{ text: 'Fixing a bike or building something', category: 'R' }, { text: 'Reading a science journal', category: 'I' }, { text: 'Painting or playing music', category: 'A' }, { text: 'Helping at a community shelter', category: 'S' }] },
        { id: 'fb_2', text: 'In a group meeting, you are the one who:', emoji: '🤝', options: [{ text: 'Focuses on the practical assembly', category: 'R' }, { text: 'Analyzes the data for errors', category: 'I' }, { text: 'Doodles and suggests creative ideas', category: 'A' }, { text: 'Ensures everyone is feeling included', category: 'S' }] },
        { id: 'fb_3', text: 'What kind of project excites you most?', emoji: '🚀', options: [{ text: 'A technical repair job', category: 'R' }, { text: 'A complex research study', category: 'I' }, { text: 'A branding or design project', category: 'A' }, { text: 'A team-building workshop', category: 'S' }] },
        { id: 'fb_4', text: 'Which work environment do you prefer?', emoji: '🏢', options: [{ text: 'A workshop with machines', category: 'R' }, { text: 'A quiet laboratory', category: 'I' }, { text: 'A startup with high energy', category: 'E' }, { text: 'An organized business office', category: 'C' }] },
        { id: 'fb_5', text: 'If you were to start a business, it would be:', emoji: '👔', options: [{ text: 'Manufacturing or construction', category: 'R' }, { text: 'Software or data analytics', category: 'I' }, { text: 'Advertising or creative arts', category: 'A' }, { text: 'Consulting or management', category: 'E' }] },
        { id: 'fb_6', text: 'How do you handle a new gadget?', emoji: '📱', options: [{ text: 'Take it apart to see how it works', category: 'R' }, { text: 'Read the technical specifications', category: 'I' }, { text: 'Compare its aesthetic design', category: 'A' }, { text: 'Find features to manage my schedule', category: 'C' }] },
        { id: 'fb_7', text: 'What is your favorite way to learn?', emoji: '📚', options: [{ text: 'Hands-on practice', category: 'R' }, { text: 'Observation and theory', category: 'I' }, { text: 'Creative experimentation', category: 'A' }, { text: 'Listening to a teacher', category: 'S' }] },
        { id: 'fb_8', text: 'In a theater production, what is your role?', emoji: '🎭', options: [{ text: 'Building the set and lighting', category: 'R' }, { text: 'Writing the script/play', category: 'A' }, { text: 'Leading the cast as a director', category: 'E' }, { text: 'Managing the budget and tickets', category: 'C' }] },
        { id: 'fb_9', text: 'Which tool are you most comfortable with?', emoji: '🛠️', options: [{ text: 'A hammer or wrench', category: 'R' }, { text: 'A microscope or database', category: 'I' }, { text: 'A brush or camera', category: 'A' }, { text: 'A spreadsheet or planner', category: 'C' }] },
        { id: 'fb_10', text: 'What do you value most in a job?', emoji: '💎', options: [{ text: 'Tangible results', category: 'R' }, { text: 'Intellectual growth', category: 'I' }, { text: 'Self-expression', category: 'A' }, { text: 'Making an impact on others', category: 'S' }] },
        { id: 'fb_11', text: 'During a crisis, you are mostly:', emoji: '🆘', options: [{ text: 'The one who fixes the physical problem', category: 'R' }, { text: 'The one who investigates the cause', category: 'I' }, { text: 'The one who manages the team', category: 'E' }, { text: 'The one who ensures protocol is followed', category: 'C' }] },
        { id: 'fb_12', text: 'Which magazine would you subscribe to?', emoji: '📰', options: [{ text: 'Popular Mechanics', category: 'R' }, { text: 'Scientific American', category: 'I' }, { text: 'Art & Design Monthly', category: 'A' }, { text: 'Business Weekly', category: 'E' }] },
        { id: 'fb_13', text: 'What kind of gifts do you prefer to give?', emoji: '🎁', options: [{ text: 'Something handmade', category: 'R' }, { text: 'A book on a niche topic', category: 'I' }, { text: 'A piece of art', category: 'A' }, { text: 'An experience or donation', category: 'S' }] },
        { id: 'fb_14', text: 'What is your ideal workspace?', emoji: '🧺', options: [{ text: 'Outdoors in the nature', category: 'R' }, { text: 'A quiet library', category: 'I' }, { text: 'A vibrant studio', category: 'A' }, { text: 'A classroom setting', category: 'S' }] },
        { id: 'fb_15', text: 'How do you organize your day?', emoji: '⏰', options: [{ text: 'I just start doing things', category: 'R' }, { text: 'I follow a strict schedule', category: 'C' }, { text: 'I focus on one big task', category: 'I' }, { text: 'I go where I’m needed most', category: 'S' }] },
        { id: 'fb_16', text: 'Which of these is most interesting?', emoji: '🦒', options: [{ text: 'Learning how animals behave', category: 'I' }, { text: 'Designing a zoo exhibit', category: 'A' }, { text: 'Training the animals', category: 'S' }, { text: 'Running the zoo business', category: 'E' }] },
        { id: 'fb_17', text: 'What would you do on a Mars colony?', emoji: '👨‍🚀', options: [{ text: 'Maintain the life support systems', category: 'R' }, { text: 'Study the Martian soil and atmosphere', category: 'I' }, { text: 'Lead the settlement expeditions', category: 'E' }, { text: 'Manage the colony records and food', category: 'C' }] },
        { id: 'fb_18', text: 'Your favorite school subject was:', emoji: '🏫', options: [{ text: 'Woodshop or PE', category: 'R' }, { text: 'Physics or Biology', category: 'I' }, { text: 'Art or Literature', category: 'A' }, { text: 'Social Studies', category: 'S' }] },
        { id: 'fb_19', text: 'If you won the lottery, you would:', emoji: '💰', options: [{ text: 'Buy tools and a ranch', category: 'R' }, { text: 'Fund a scientific expedition', category: 'I' }, { text: 'Build a gallery or studio', category: 'A' }, { text: 'Start a charitable foundation', category: 'S' }] },
        { id: 'fb_20', text: 'How do you like to solve problems?', emoji: '🔧', options: [{ text: 'Using physical tools', category: 'R' }, { text: 'Using logic and data', category: 'I' }, { text: 'Using creative intuition', category: 'A' }, { text: 'Through collaboration', category: 'S' }] },
        { id: 'fb_21', text: 'Which of these career titles sounds best?', emoji: '🏷️', options: [{ text: 'Engineer', category: 'R' }, { text: 'Researcher', category: 'I' }, { text: 'Illustrator', category: 'A' }, { text: 'Accountant', category: 'C' }] },
        { id: 'fb_22', text: 'What kind of apps do you have most?', emoji: '📱', options: [{ text: 'Utility and DIY guides', category: 'R' }, { text: 'News and educational apps', category: 'I' }, { text: 'Photo and video editors', category: 'A' }, { text: 'Social media and chat', category: 'S' }] },
        { id: 'fb_23', text: 'If you were a superhero, you would:', emoji: '🦸', options: [{ text: 'Build cool gadgets', category: 'R' }, { text: 'Be the brilliant strategist', category: 'I' }, { text: 'Be the charismatic leader', category: 'E' }, { text: 'Protect the innocent and heal', category: 'S' }] },
        { id: 'fb_24', text: 'What do you enjoy at museums?', emoji: '🏛️', options: [{ text: 'Interactive exhibits', category: 'R' }, { text: 'Detailed historical texts', category: 'I' }, { text: 'The art pieces', category: 'A' }, { text: 'The guided group tours', category: 'S' }] },
        { id: 'fb_25', text: 'How do you contribute to a team?', emoji: '⛹️', options: [{ text: 'Execution and labor', category: 'R' }, { text: 'Planning and analysis', category: 'I' }, { text: 'Innovation and design', category: 'A' }, { text: 'Motivation and harmony', category: 'S' }] }
      ];
    }
  }

  async generateCareerGuidance(scores: any, topCategories: string[], recommendedCareers: any[]) {
    const careersDetails = recommendedCareers.map((c) => `- ${c.title}: ${c.description} (Stream: ${c.stream})`).join('\n');
    const prompt = `
    You are an expert career counselor. A high school student has just completed a RIASEC career aptitude test.
    Their scores are: Realistic: ${scores.R || 0}, Investigative: ${scores.I || 0}, Artistic: ${scores.A || 0}, Social: ${scores.S || 0}, Enterprising: ${scores.E || 0}, Conventional: ${scores.C || 0}.
    Their dominant personality types (Holland Codes) are: ${topCategories.join(', ')}.
    
    We matched them with these specific careers from our list:
    ${careersDetails}

    Please provide a highly personalized, warm, and professional career guidance summary.
    1. Acknowledge their unique combination of strengths based on their top RIASEC codes.
    2. Explain why the recommended careers (especially the top 2-3) are a perfect match for their specific personality mix.
    3. Suggest a clear "Career Pathway" (e.g., choice of stream in Class 11/12 and potential college degrees).
    4. Provide 3 specific, actionable "Action Steps" they can take right now to explore these fields (e.g., specific online courses, projects, or competitions).

    Format the output in clean Markdown with bold headings and bullet points. Keep it around 400 words.
    Use an encouraging and aspirational tone.
    `;

    try {
      const result = await this.model.generateContent(prompt);
      const response = await result.response;
      return response.text().trim();
    } catch (error) {
      console.error('Error generating guidance:', error);
      return 'Based on your results, you have strong inclinations towards your top categories. We recommend exploring the suggested careers above, which align with your unique interests and strengths!';
    }
  }
}
