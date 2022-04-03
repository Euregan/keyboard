import { Elm } from './Main.elm'

const app = Elm.Main.init({
  node: document.querySelector('main'),
  flags: {
    pcbs: {
      corneClassic: new URL('../assets/corne-classic.obj', import.meta.url).toString()
    },
    switches: {
      cherryMx: new URL('../assets/cherry-mx.obj', import.meta.url).toString()
    }
  }
})
