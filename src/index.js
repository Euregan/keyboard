import { Elm } from './Main.elm'

const app = Elm.Main.init({
  node: document.querySelector('main'),
  flags: {
    pcbs: {
      corneClassic: {
        mesh: new URL('../assets/corne-classic.obj', import.meta.url).toString(),
        texture: new URL('../assets/corne-classic.png', import.meta.url).toString()
      }
    },
    switches: {
      cherryMx: new URL('../assets/cherry-mx.obj', import.meta.url).toString()
    }
  }
})
