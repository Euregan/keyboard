import { useState, useEffect } from 'react'
import type { NextPage } from 'next'
import Scene from '../components/Scene'

const Home: NextPage = () => {
  // Preventing SSR
  const [loaded, setLoaded] = useState(false)

  useEffect(() => {
    setLoaded(true)
  }, [])

  if (!loaded) {
    return <></>
  }

  return <Scene width={window.innerWidth} height={window.innerHeight} />
}

export default Home
