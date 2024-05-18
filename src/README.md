<br />

<div align="center">
  <img src="../public/assets/home-page.png" alt="Logo" width="100%" height="100%">
  <p align="center">Home Page</p>
  <img src="../public/assets/mini-portal.png" alt="Logo" width="100%" height="100%">
  <p align="center">Mini Portal</p>
  <img src="../public/assets/detail-modal.png" alt="Logo" width="100%" height="100%">
  <p align="center">Detail Modal</p>
  <img src="../public/assets/grid-genre.png" alt="Logo" width="100%" height="100%">
  <p align="center">Grid Genre Page</p>
  <img src="../public/assets/watch.png" alt="Logo" width="100%" height="100%">
  <p align="center">Watch Page with control bar</p>
</div>

## Prerequests

- Create an account if you don't have one on [TMDB](https://www.themoviedb.org/).
  I use its free API to consume movie/tv data.
- Follow the [documentation](https://developers.themoviedb.org/3/getting-started/introduction) to create an API Key.
- If you use v3 of TMDB API, create a file named `.env`, and copy the content of `.env.example`.
  Then paste the API Key you created.

## Project Features

- How to create and use [Custom Hooks](https://reactjs.org/docs/hooks-custom.html)
- How to use [Context](https://reactjs.org/docs/context.html) and its provider
- How to use lazy and Suspense for [Code-Splitting](https://reactjs.org/docs/code-splitting.html)
- How to use the new [lazy](https://reactrouter.com/en/main/route/lazy) feature of react-router to reduce bundle size.
- How to use data [loader](https://reactrouter.com/en/main/route/loader) of react-router, and how to use redux dispatch in the loader to fetch data before rendering components.
- How to use [Portal](https://reactjs.org/docs/portals.html)
- How to use [Forwarding Refs](https://reactjs.org/docs/forwarding-refs.html) to make components reusable
- How to create and use [HOC](https://reactjs.org/docs/higher-order-components.html)
- How to customize the default theme of [MUI](https://mui.com/)
- How to use [RTK](https://redux-toolkit.js.org/introduction/getting-started)
- How to use [RTK Query](https://redux-toolkit.js.org/rtk-query/overview)
- How to customize the default classname of [MUI](https://mui.com/material-ui/experimental-api/classname-generator)
- Infinite Scrolling (using [Intersection Observer API](https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API))
- How to make an awesome carousel using [slick-carousel](https://react-slick.neostack.com)

## Third-Party Libraries

- [react-router-dom@v6.9](https://reactrouter.com/en/main)
- [MUI(Material UI)](https://mui.com/)
- [framer-motion](https://www.framer.com/docs/)
- [video.js](https://videojs.com)
- [react-slick](https://react-slick.neostack.com/)

## Install with Docker

```sh
docker build --build-arg TMDB_V3_API_KEY=your_api_key_here -t netflix-clone .

docker run --name netflix-clone-website --rm -d -p 80:80 netflix-clone
