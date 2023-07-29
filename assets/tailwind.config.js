// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration
const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex'
  ],
  theme: {
    screens: {
      'xs': '360px',
      ...defaultTheme.screens,
    },
    extend: {
      position: ['sticky'], // Added position property for sticky
      screens: {
        'md': '740px',
        'lg': '1000px',
      },
      fontFamily: {
        'tiempos': ['Tiempos'],
        'tiempos-bold': ['Tiempos Bold'],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms')
  ]
}
