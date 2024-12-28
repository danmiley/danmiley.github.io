import React from 'react';
import { Exercise } from '../types';

interface ExerciseCardProps {
  exercise: Exercise;
  onNext: () => void;
  onPrev: () => void;
}

export const ExerciseCard: React.FC<ExerciseCardProps> = ({
  exercise,
  onNext,
  onPrev,
}) => {
  return (
    <div className="max-w-md mx-auto bg-white rounded-xl shadow-md overflow-hidden">
      <div className="p-8">
        <div className="uppercase tracking-wide text-sm text-indigo-500 font-semibold">
          {exercise.difficulty}
        </div>
        <h2 className="mt-1 text-xl font-medium text-gray-900">{exercise.title}</h2>
        <p className="mt-2 text-gray-500">{exercise.description}</p>
        <div className="mt-4">
          <h3 className="text-lg font-medium text-gray-900">Sets</h3>
          <p className="text-gray-500">{exercise.sets}</p>
        </div>
        <div className="mt-4">
          <h3 className="text-lg font-medium text-gray-900">Tips</h3>
          <p className="text-gray-500">{exercise.tips}</p>
        </div>
        <div className="mt-4">
          <h3 className="text-lg font-medium text-gray-900">Muscle Groups</h3>
          <div className="flex flex-wrap gap-2 mt-2">
            {exercise.muscleGroups.map((muscle) => (
              <span
                key={muscle}
                className="px-2 py-1 bg-gray-100 rounded-full text-sm text-gray-700"
              >
                {muscle}
              </span>
            ))}
          </div>
        </div>
      </div>
      <div className="px-8 pb-4 flex justify-between">
        <button
          onClick={onPrev}
          className="bg-gray-100 hover:bg-gray-200 text-gray-800 font-bold py-2 px-4 rounded-l"
        >
          Previous
        </button>
        <button
          onClick={onNext}
          className="bg-indigo-500 hover:bg-indigo-600 text-white font-bold py-2 px-4 rounded-r"
        >
          Next
        </button>
      </div>
    </div>
  );
};
