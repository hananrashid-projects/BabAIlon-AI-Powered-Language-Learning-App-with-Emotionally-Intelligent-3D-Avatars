import React from 'react'
import { Canvas } from '@react-three/fiber'
import { Loader } from '@react-three/drei'
import { Leva } from 'leva'
import { Experience as DebateAvatar } from './Experience3'   // your one avatar component
import './MinimalDebateUI.css'

export default function MinimalDebateUI() {
  return (
    <div className="minimal-debate-container">
      {/* show loading overlay while things load */}
      <Loader />
      {/* hide Leva controls */}
      <Leva hidden />

      {/* full-screen 3D canvas */}
      <Canvas shadows camera={{ position: [0, 0, 1], fov: 30 }}>
        {/* if your avatar needs an id prop, you can pass it here */}
        <DebateAvatar avatarId={1} />
      </Canvas>
    </div>
  )
}
