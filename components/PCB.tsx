import { useState, useRef } from 'react'
import { useLoader, useGraph, useFrame } from '@react-three/fiber'
import type { Group, Mesh } from 'three'
import { OBJLoader } from 'three/examples/jsm/loaders/OBJLoader'

const easeOut = (x: number): number => Math.sin((x * Math.PI) / 2)

const animationDuration = 200

interface Props {
  model: string
}

const PCB = ({ model }: Props) => {
  const ref = useRef<Group | null>(null)
  const [startTime, setStartTime] = useState(-Infinity)

  useFrame(({ clock }) => {
    if (pcbScene && ref.current) {
      const elapsed = clock.getElapsedTime() * 1000
      if (startTime === -Infinity) {
        setStartTime(elapsed)
      } else if (elapsed - startTime < animationDuration) {
        ref.current.position.y =
          (1 - easeOut((elapsed - startTime) / animationDuration)) * 10
      }
    }
  })

  const pcbScene = useLoader(OBJLoader, `/${model}`)
  const { nodes } = useGraph(pcbScene)

  return (
    <mesh
      castShadow
      receiveShadow
      geometry={(nodes['Manual_PCB_Plane.003'] as Mesh).geometry}
      scale={100}
      position={[0, 0, 0]}
      rotation={[0, Math.PI * 1.5, 0]}
    >
      <meshStandardMaterial color={0} roughness={0.55} />
    </mesh>
  )
}

export default PCB
