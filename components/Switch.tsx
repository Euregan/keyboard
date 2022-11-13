import { useState, useRef } from 'react'
import { useLoader, useGraph, useFrame } from '@react-three/fiber'
import type { Group, Mesh, Vector3 } from 'three'
import { OBJLoader } from 'three/examples/jsm/loaders/OBJLoader'
import { useKeyPressed } from '../libs/hooks'
import { Text } from '@react-three/drei'
import { useSpring, animated } from '@react-spring/three'

const easeOut = (x: number): number => Math.sin((x * Math.PI) / 2)

const animationDuration = 200

const keyToLabel = (key: string) => {
  switch (key) {
    case 'Shift':
      return 'Shift'
    case 'Control':
      return 'Ctrl'
    case 'Tab':
      return 'Tab'
    default:
      return key.toUpperCase()
  }
}

interface Props {
  model: string
  character: string
  position: [number, number, number]
  rotation: [number, number, number]
}

const Switch = ({
  model,
  character: key,
  position: [positionX, positionY, positionZ],
  rotation: [rotationX, rotationY, rotationZ],
}: Props) => {
  const ref = useRef<Group | null>(null)
  const [startTime, setStartTime] = useState(-Infinity)

  const pressed = useKeyPressed(key)
  const { buttonPosition } = useSpring({
    buttonPosition: [positionX, positionY - (pressed ? 0.25 : 0), positionZ],
    config: {
      duration: 30,
    },
  })

  useFrame(({ clock }) => {
    if (switchScene && ref.current) {
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

  const switchScene = useLoader(OBJLoader, `/${model}`)
  const { nodes } = useGraph(switchScene)

  return (
    <>
      {/*<mesh
        castShadow
        receiveShadow
        geometry={nodes.cap_Solid.geometry}
        scale={100}
        position={[positionX, positionY, positionZ]}
        rotation={[rotationX, rotationY, rotationZ]}
      >
        <meshStandardMaterial color={'orange'} />
      </mesh>*/}
      <mesh
        castShadow
        receiveShadow
        geometry={(nodes.base_Solid001 as Mesh).geometry}
        scale={100}
        position={[positionX, positionY, positionZ]}
        rotation={[rotationX, rotationY, rotationZ]}
      >
        <meshStandardMaterial color={0} roughness={0.55} />
      </mesh>
      <animated.mesh
        castShadow
        receiveShadow
        geometry={(nodes.button_Solid008 as Mesh).geometry}
        scale={100}
        position={(buttonPosition as unknown) as Vector3}
        rotation={[rotationX, rotationY, rotationZ]}
      >
        <meshStandardMaterial color={0x583830} roughness={0.55} />
      </animated.mesh>
      <Text
        position={[
          positionX,
          positionY + 0.7 - (pressed ? 0.25 : 0),
          positionZ,
        ]}
        rotation={[rotationX + Math.PI * 1.5, 0, rotationZ + Math.PI * 0.5]}
        fontSize={0.8}
        color="orange"
      >
        {keyToLabel(key)}
      </Text>
    </>
  )
}

export default Switch
