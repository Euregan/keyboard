import { Canvas } from '@react-three/fiber'
import { PerspectiveCamera, Vector3 } from 'three'
import PCB from './PCB'

interface Props {
  width: number
  height: number
}

const sunColor = 0xfff2e7

const Scene = ({ width, height }: Props) => {
  const camera = new PerspectiveCamera(45, width / height, 1, 1000)
  camera.position.set(15, 7, 0)
  camera.lookAt(new Vector3(0, 0, 0))

  return (
    <Canvas camera={camera}>
      <ambientLight intensity={0.1} color={sunColor} />
      <pointLight position={[10, 10, 2]} color={sunColor} intensity={0.5} />
      <PCB />
    </Canvas>
  )
}

export default Scene
