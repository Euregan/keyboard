import { useState, useRef } from 'react'
import { useLoader, useFrame } from '@react-three/fiber'
import type { Group } from 'three'
import { OBJLoader } from 'three/examples/jsm/loaders/OBJLoader'

const easeOut = (x: number): number => Math.sin((x * Math.PI) / 2)

const animationDuration = 200

const PCB = () => {
  const ref = useRef<Group | null>(null)
  const [startTime, setStartTime] = useState(-Infinity)

  useFrame(({ clock }) => {
    if (pcb && ref.current) {
      const elapsed = clock.getElapsedTime() * 1000
      if (startTime === -Infinity) {
        setStartTime(elapsed)
      } else if (elapsed - startTime < animationDuration) {
        ref.current.position.y =
          (1 - easeOut((elapsed - startTime) / animationDuration)) * 10
      }
    }
  })

  const pcb = useLoader(OBJLoader, '/corne-classic.obj')

  return (
    <primitive
      ref={ref}
      object={pcb}
      scale={100}
      position={[0, 10, 0]}
      rotation={[0, Math.PI * 1.5, 0]}
    />
  )
}

export default PCB
