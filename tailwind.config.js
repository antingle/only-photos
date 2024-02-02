/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{html,leaf,js,}"],
  theme: {
    extend: {
      colors: {
        systemGray: {
          600: "#48484a",
          700: "#3a3a3c",
          800: "#2c2c2e",
          900: "#1c1c1e",
        },
      },
    },
  },
  plugins: [],
};
