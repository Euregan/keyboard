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
                position: [2.46, 0.205, 5.35],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                position: [2.46, 0.205, 3.45],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                position: [2, 0.205, 1.55],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                position: [1.75, 0.205, -0.35],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                position: [1.97, 0.205, -2.26],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                position: [2.22, 0.205, -4.17],
                rotation: [0, Math.PI * 0.5, 0],
              },

              {
                position: [0.55, 0.205, 5.35],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                position: [0.55, 0.205, 3.45],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                position: [0.1, 0.205, 1.55],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                position: [-0.17, 0.205, -0.35],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                position: [0.1, 0.205, -2.26],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                position: [0.3, 0.205, -4.17],
                rotation: [0, Math.PI * 0.5, 0],
              },

              {
                position: [-1.36, 0.205, 5.35],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                position: [-1.37, 0.205, 3.45],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                position: [-1.81, 0.205, 1.55],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                position: [-2.08, 0.205, -0.35],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                position: [-1.84, 0.205, -2.26],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                position: [-1.6, 0.205, -4.17],
                rotation: [0, Math.PI * 0.5, 0],
              },

              {
                position: [3.94, 0.205, -1.3],
                rotation: [0, Math.PI * 0.5, 0],
              },
              {
                position: [4.24, 0.205, -3.44],
                rotation: [0, Math.PI * 0.4, 0],
              },
              {
                position: [4.63, 0.205, -5.65],
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
