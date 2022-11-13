import { useEffect, useState } from 'react'

export const useKeyPressed = (key: string) => {
  const [pressed, setPressed] = useState(false)

  useEffect(() => {
    const down = (event: KeyboardEvent) => event.key === key && setPressed(true)
    const up = (event: KeyboardEvent) => event.key === key && setPressed(false)
    document.addEventListener('keydown', down)
    document.addEventListener('keyup', up)

    return () => {
      document.removeEventListener('keydown', down)
      document.removeEventListener('keyup', up)
    }
  }, [])

  return pressed
}
