import React from "react";

export function FaqSingle({ title, description }) {
  const [expanded, setExpanded] = React.useState(false);
  return (
    <>
      <div className="pt-6">
        <dt className="text-lg">
          <button
            onClick={() => setExpanded(!expanded)}
            className="text-left w-full flex justify-between items-start text-gray-400"
          >
            <span className="font-medium text-gray-900">{title}</span>
            <span className="ml-6 h-7 flex items-center">
              <svg
                className={"h-6 w-6 transform " + (expanded ? "-rotate-180" : "")}
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth="2"
                  d="M19 9l-7 7-7-7"
                />
              </svg>
            </span>
          </button>
        </dt>
        <dd className={'mt-2 pr-12 ' + (expanded ? '' : 'hidden')}>
          <p className="text-base text-gray-500">
            {description}
          </p>
        </dd>
      </div>
    </>
  );
}

export function FaqSection() {
  return (
    <>
      <div className="bg-gray-50">
        <div className="max-w-7xl mx-auto py-12 px-4 sm:py-16 sm:px-6 lg:px-8">
          <div className="max-w-3xl mx-auto divide-y-2 divide-gray-200">
            <h2 className="text-center text-3xl font-extrabold text-gray-900 sm:text-4xl">
              Frequently asked questions
            </h2>
            <dl className="mt-6 space-y-6 divide-y divide-gray-200">
              <FaqSingle
                title="What does this do?"
                description="This is a mobile app which lets you pinch zoom into photographs and turn the motion into a video/gif."
              />
              <FaqSingle
                title="Why even bother?"
                description="Something I always wanted to make, as I couldn't find something that did it."
              />
            </dl>
          </div>
        </div>
      </div>
    </>
  );
}
