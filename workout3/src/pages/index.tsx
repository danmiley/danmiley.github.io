import { useEffect, useState } from 'react'
import { ExerciseCard } from '../components/ExerciseCard'
import type { Exercise } from '../types'

export default function Home() {
  const [exercises, setExercises] = useState<Exercise[]>([])
  const [currentIndex, setCurrentIndex] = useState(0)

  useEffect(() => {
    fetch('/data/exercises.json')
      .then(res => res.json())
      .then(data => setExercises(data.exercises))
  }, [])

  const handleNext = () => {
    setCurrentIndex((prev) => (prev + 1) % exercises.length)
  }

  const handlePrev = () => {
    setCurrentIndex((prev) => (prev - 1 + exercises.length) % exercises.length)
  }

  if (exercises.length === 0) return <div>Loading...</div>

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="container mx-auto px-4">
        <h1 className="text-3xl font-bold text-center mb-8">
          Workout Guide
        </h1>
        <ExerciseCard
          exercise={exercises[currentIndex]}
          onNext={handleNext}
          onPrev={handlePrev}
        />
      </div>
    </div>
  )
}
