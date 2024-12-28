export interface Exercise {
  id: number;
  title: string;
  description: string;
  sets: string;
  tips: string;
  difficulty: 'beginner' | 'intermediate' | 'advanced';
  muscleGroups: string[];
}
