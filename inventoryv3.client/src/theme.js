import { createTheme } from "@mui/material";

const theme = createTheme({
  spacing: 4,
  palette: {
    mode: "light",
  },
  typography: {
    fontFamily: '"Inter", Arial, sans-serif',
  },
  components: {
    MuiCssBaseline: {
      styleOverrides: {
        '@global': {
          '@font-face': {
            fontFamily: 'Inter',
            fontStyle: 'normal',
            fontWeight: 400,
            src: `url('./assets/fonts/Inter.ttf') format('truetype')`,
          },
        },
      },
    },
  },
});

export default theme;
