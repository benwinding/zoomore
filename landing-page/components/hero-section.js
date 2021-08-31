export function HeroSection() {
  const playstoreLink = "https://play.google.com/store/apps/details?id=com.benwinding.zoomore";
  const appStoreLink = "https://apps.apple.com/us/app/zoomore/id1579048457";

  return (
    <>
      <div className="relative bg-white overflow-hidden">
        <div className="max-w-7xl mx-auto">
          <div className="relative z-10 pb-8 bg-white sm:pb-16 md:pb-20 lg:max-w-2xl lg:w-full lg:pb-28 xl:pb-32">
            <svg
              className="hidden lg:block absolute right-0 inset-y-0 h-full w-48 text-white transform translate-x-1/2"
              fill="currentColor"
              viewBox="0 0 100 100"
              preserveAspectRatio="none"
              aria-hidden="true"
            >
              <polygon points="50,0 100,0 50,100 0,100" />
            </svg>

            <main className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
              <div className="sm:text-center lg:text-left pt-10">
                <span className="">
                  <a href="/">
                    <span className="block text-6xl font-checkbk xl:inline">
                      <span className="text-gray-900">Zoom</span>
                      <span className="text-blue-500">ore</span>
                    </span>
                  </a>
                  <span className="block text-3xl text-gray-400">
                    Turn pictures into videos
                  </span>
                </span>
                <p className="mt-3 text-base text-gray-500 sm:mt-5 sm:text-lg sm:max-w-xl sm:mx-auto md:mt-5 md:text-xl lg:mx-0">
                  Zoom, pan and rotate your image to make an entertaining video.
                </p>
                <div className="mt-5 sm:mt-8 sm:flex sm:justify-center lg:justify-start">
                  <div className="rounded-md shadow">
                    <a
                      target="_blank"
                      href={playstoreLink}
                      className="w-full flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-white bg-green-400 hover:bg-green-700 md:py-4 md:text-lg md:px-10"
                    >
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        version="1.1"
                        width="32"
                        height="32"
                        className="fill-current mr-2"
                        viewBox="0 0 128 128"
                      >
                        <g
                          data-width="18"
                          data-height="16"
                          className="iconic-sm iconic-container"
                          transform="scale(8) translate(1)"
                        >
                          <g className="iconic-platform-android">
                            <path
                              d="M.987 5.175c-.545 0-.987.443-.987.987l.001 4.135c0 .547.442.988.988.988s.988-.441.987-.988v-4.136c0-.545-.443-.987-.988-.987"
                              className="iconic-platform-android-arm iconic-platform-android-arm-left iconic-property-fill"
                            ></path>
                            <path
                              d="M13.543 6.161c0-.545-.442-.987-.988-.987-.545 0-.987.442-.987.988l.001 4.135c0 .546.442.987.988.987.545 0 .987-.441.987-.988l-.001-4.136z"
                              className="iconic-platform-android-arm iconic-platform-android-arm-right iconic-property-fill"
                            ></path>
                            <path
                              d="M2.358 5.362l.002 6.409c0 .583.471 1.053 1.054 1.054h.718l.001 2.188c0 .545.443.988.987.988.546 0 .988-.443.988-.988l-.001-2.188h1.333l.001 2.188c0 .544.443.988.987.987.546 0 .988-.443.988-.988l-.001-2.187.72-.001c.581 0 1.054-.471 1.054-1.054l-.001-6.409-8.829.002z"
                              className="iconic-platform-android-body iconic-property-fill"
                            ></path>
                            <path
                              d="M8.951 1.462l.689-1.259c.037-.066.013-.149-.054-.187-.067-.036-.15-.012-.186.055l-.696 1.272c-.586-.261-1.241-.407-1.935-.406-.692-.001-1.347.145-1.931.404l-.697-1.268c-.036-.067-.12-.091-.186-.055-.067.036-.092.12-.054.186l.69 1.258c-1.355.699-2.27 2.029-2.27 3.557l8.895-.001c0-1.527-.913-2.855-2.266-3.556zm-4.205 1.945c-.205 0-.372-.167-.372-.373 0-.205.167-.373.372-.373.206 0 .373.169.373.373 0 .206-.167.373-.374.373zm4.05-.001c-.206 0-.373-.167-.373-.373.001-.204.167-.373.373-.374.204.001.372.169.372.374.001.206-.167.373-.372.373z"
                              className="iconic-platform-android-head iconic-property-fill"
                            ></path>
                          </g>
                        </g>
                      </svg>
                      Play Store
                    </a>
                  </div>
                  <div className="mt-3 sm:mt-0 sm:ml-3">
                    <a
                      target="_blank"
                      href={appStoreLink}
                      className="w-full flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 md:py-4 md:text-lg md:px-10"
                    >
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        version="1.1"
                        width="32"
                        height="32"
                        className="fill-current mr-1 pb-1"
                        viewBox="0 0 128 128"
                      >
                        <g
                          data-width="14"
                          data-height="16"
                          className="iconic-sm iconic-container"
                          transform="scale(8) translate(1)"
                        >
                          <g className="iconic-platform-apple">
                            <path
                              d="M12.599 5.236c-1.139.859-1.706 1.891-1.703 3.097.004 1.441.712 2.545 2.125 3.312-.376 1.162-.921 2.176-1.637 3.038-.715.866-1.37 1.297-1.963 1.3-.28 0-.661-.096-1.144-.289l-.232-.092c-.474-.2-.894-.293-1.257-.293-.344.002-.721.079-1.129.234l-.291.112-.367.158c-.288.123-.58.186-.875.188-.693.002-1.46-.599-2.301-1.809-1.212-1.728-1.82-3.617-1.825-5.66-.004-1.453.369-2.624 1.119-3.514.751-.889 1.746-1.336 2.987-1.34.465-.001.898.088 1.303.267l.277.118.291.126c.259.115.469.173.628.173.205 0 .432-.051.68-.153l.382-.159.284-.111c.453-.176.954-.264 1.502-.267 1.303-.005 2.351.516 3.146 1.565z"
                              className="iconic-platform-apple-body iconic-property-fill"
                            ></path>
                            <path
                              d="M9.503 0c.015.184.024.327.025.427.002.914-.311 1.716-.937 2.408s-1.355 1.037-2.188 1.038c-.024-.206-.038-.354-.038-.444-.002-.777.288-1.507.87-2.19.58-.683 1.255-1.083 2.022-1.202.055-.009.137-.024.246-.039z"
                              className="iconic-platform-apple-leaf iconic-property-fill"
                            ></path>
                          </g>
                        </g>
                      </svg>
                      App Store
                    </a>
                  </div>
                </div>
              </div>
            </main>
          </div>
        </div>
        <div className="lg:absolute lg:inset-y-0 lg:right-0 lg:w-1/2">
          <img
            className="h-56 w-full object-cover sm:h-72 md:h-96 lg:w-full lg:h-full"
            src="/hero.jpg"
            alt=""
          />
        </div>
      </div>
    </>
  );
}
