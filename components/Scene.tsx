import { useState, useEffect } from 'react'
import { Canvas } from '@react-three/fiber'
import { OrthographicCamera, PerspectiveCamera, Vector3 } from 'three'
import PCBModel from './PCB'
import Switch from './Switch'
import keyboards from '../keyboards'
import type { Keyboard, PCB, SwitchLayout } from '../keyboards'

interface Props {
  width: number
  height: number
}

const sunColor = 0xfff2e7

const Scene = ({ width, height }: Props) => {
  const [keyboard, setKeyboard] = useState<Keyboard | null>(null)
  const [pcb, setPcb] = useState<PCB | null>(null)
  const [switchLayout, setSwitchLayout] = useState<SwitchLayout | null>(null)

  useEffect(() => {
    if (keyboards.length === 1) {
      setKeyboard(keyboards[0])
    }
  }, [])

  useEffect(() => {
    if (keyboard && keyboard.pcbs.length === 1) {
      setPcb(keyboard.pcbs[0])
    }
  }, [keyboard])

  useEffect(() => {
    if (pcb && pcb.switches.length === 1) {
      setSwitchLayout(pcb.switches[0])
    }
  }, [pcb])

  // const camera = new PerspectiveCamera(45, width / height, 1, 1000)
  // camera.position.set(0, -20, 0)
  // camera.lookAt(new Vector3(0, 0, 0))
  const camera = new PerspectiveCamera(45, width / height, 1, 1000)
  camera.position.set(15, 7, 0)
  camera.lookAt(new Vector3(0, 0, 0))

  return (
    <Canvas camera={camera}>
      <ambientLight intensity={0.1} color={sunColor} />
      <pointLight position={[10, 10, 2]} color={sunColor} intensity={0.5} />
      {pcb && <PCBModel model={pcb.model} />}
      {switchLayout &&
        switchLayout.layout.map(({ position, rotation }, index) => (
          <Switch
            key={index}
            model={switchLayout.model}
            position={position}
            rotation={rotation}
          />
        ))}
    </Canvas>
  )
}

export default Scene
