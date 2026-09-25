/* Tailwind Play CDN theme — brand colors & fonts (loaded right after the CDN script, not deferred). */
tailwind.config = {
  theme: {
    extend: {
      colors: {
        ink:   { DEFAULT: '#0f1b2d', soft: '#3b4a5e' },
        ocean: { 50: '#effaf8', 100: '#d5f2ee', 200: '#aee4dd', 300: '#7dd0c7', 400: '#46b3a9', 500: '#24978e', 600: '#177a74', 700: '#15625e', 800: '#154f4c', 900: '#143f3d' },
        coral: { 50: '#fff4ed', 100: '#ffe6d4', 200: '#fecaa8', 300: '#fda571', 400: '#fb7a3c', 500: '#ea580c', 600: '#c93d0b', 700: '#a8320c', 800: '#8a2a10', 900: '#712510' },
        sand:  { 50: '#fdfaf4', 100: '#faf3e6', 200: '#f3e4c7', 300: '#e9cf9f' }
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', '-apple-system', 'Segoe UI', 'Roboto', 'sans-serif'],
        display: ['"Plus Jakarta Sans"', 'Inter', 'system-ui', 'sans-serif']
      }
    }
  }
};
