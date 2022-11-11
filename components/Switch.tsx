import { useMemo, useState, useRef } from 'react'
import { useLoader, useGraph, useFrame } from '@react-three/fiber'
import type { Group } from 'three'
import { OBJLoader } from 'three/examples/jsm/loaders/OBJLoader'

const easeOut = (x: number): number => Math.sin((x * Math.PI) / 2)

const animationDuration = 200

interface Props {
  model: string
  position: [number, number, number]
  rotation: [number, number, number]
}

const Switch = ({
  model,
  position: [positionX, positionY, positionZ],
  rotation: [rotationX, rotationY, rotationZ],
}: Props) => {
  const ref = useRef<Group | null>(null)
  const [startTime, setStartTime] = useState(-Infinity)

  useFrame(({ clock }) => {
    if (pcb && ref.current) {
      const elapsed = clock.getElapsedTime() * 1000
      if (startTime === -Infinity) {
        setStartTime(elapsed)
      } else if (elapsed - startTime < animationDuration) {
        ref.current.position.y =
          (1 - easeOut((elapsed - startTime) / animationDuration)) * 10 +
          positionY
      }
    }
  })

  const pcb = useLoader(OBJLoader, `/${model}`)
  const { nodes, materials } = useGraph(pcb)

  // console.log(nodes.base_Solid001.geometry)

  // const clonedPcb = useMemo(() => pcb.clone(true), [pcb])

  // return (
  //   <primitive
  //     object={clonedPcb}
  //     scale={100}
  //     position={[0, 0, 0]}
  //     rotation={[0, 0, 0]}
  //   />
  // )

  return (
    <>
      <mesh
        geometry={nodes.cap_Solid.geometry}
        scale={100}
        position={[positionX, positionY, positionZ]}
        rotation={[rotationX, rotationY, rotationZ]}
      >
        <meshStandardMaterial color={'orange'} />
      </mesh>
      <mesh
        geometry={nodes.base_Solid001.geometry}
        scale={100}
        position={[positionX, positionY, positionZ]}
        rotation={[rotationX, rotationY, rotationZ]}
      >
        <meshStandardMaterial color={'orange'} />
      </mesh>
      <mesh
        geometry={nodes.button_Solid008.geometry}
        scale={100}
        position={[positionX, positionY, positionZ]}
        rotation={[rotationX, rotationY, rotationZ]}
      >
        <meshStandardMaterial color={'orange'} />
      </mesh>
    </>
  )

  // return (
  //   <primitive
  //     ref={ref}
  //     object={pcb}
  //     scale={100}
  //     position={[positionX, ref?.current?.position.y || 10, positionZ]}
  //     rotation={[rotationX, rotationY, rotationZ]}
  //   />
  // )
}

export default Switch