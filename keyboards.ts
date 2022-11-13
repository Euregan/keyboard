export interface Keyboard {
  label: string
  pcbs: Array<PCB>
}

export interface PCB {
  label: string
  model: string
  switches: Array<SwitchLayout>
}

export interface SwitchLayout {
  model: string
  layout: Array<{
    key: string
    position: [number, number, number]
    rotation: [number, number, number]
  }>
}

const keyboards: Array<Keyboard> = [
  {
    label: 'Corne',
    pcbs: [
      {
        label: 'v2?',
        model: 'corne-classic.obj',
        switches: [
          {
            model: 'kaihl-low-profile.obj',
            layout: [
              {
                key: 'Shift',
                position: [2.46, 0.405, 5.35],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                key: 'z',
                position: [2.46, 0.405, 3.45],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                key: 'x',
                position: [2, 0.405, 1.55],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                key: 'c',
                position: [1.75, 0.405, -0.35],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                key: 'v',
                position: [1.97, 0.405, -2.26],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                key: 'b',
                position: [2.22, 0.405, -4.17],
                rotation: [0, Math.PI * 0.5, 0],
              },

              {
                key: 'Control',
                position: [0.55, 0.405, 5.35],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                key: 'a',
                position: [0.55, 0.405, 3.45],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                key: 's',
                position: [0.1, 0.405, 1.55],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                key: 'd',
                position: [-0.17, 0.405, -0.35],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                key: 'f',
                position: [0.1, 0.405, -2.26],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                key: 'g',
                position: [0.3, 0.405, -4.17],
                rotation: [0, Math.PI * 0.5, 0],
              },

              {
                key: 'Tab',
                position: [-1.36, 0.405, 5.35],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                key: 'q',
                position: [-1.37, 0.405, 3.45],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                key: 'w',
                position: [-1.81, 0.405, 1.55],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                key: 'e',
                position: [-2.08, 0.405, -0.35],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                key: 'r',
                position: [-1.84, 0.405, -2.26],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                key: 't',
                position: [-1.6, 0.405, -4.17],
                rotation: [0, Math.PI * 0.5, 0],
              },

              {
                key: 'Meta',
                position: [3.94, 0.405, -1.3],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                key: 'Fn',
                position: [4.24, 0.405, -3.44],
                rotation: [0, Math.PI * 0.4, 0],
              },
              {
                key: 'Enter',
                position: [4.63, 0.405, -5.65],
                rotation: [0, Math.PI * 0.85, 0],
              },
            ],
          },
        ],
      },
    ],
  },
]

export default keyboards
