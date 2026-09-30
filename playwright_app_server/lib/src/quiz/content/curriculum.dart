import '../../generated/protocol.dart';
import 'curriculum_builder.dart';

/// The full learning path, from absolute beginner to expert.
///
/// Content lives in code so it is versioned together with the app. Options are
/// shuffled by the app on every attempt, so the order here does not matter.
final List<Tier> curriculum = _assignOrder([
  Tier(
    id: 'beginner',
    order: 0,
    difficulty: 'Beginner',
    title: 'Act I · Rehearsal',
    description: 'Never automated a browser? Start here.',
    lessons: [_meetPlaywright, _firstTest, _locators],
  ),
  Tier(
    id: 'intermediate',
    order: 1,
    difficulty: 'Intermediate',
    title: 'Act II · Opening Night',
    description: 'Click, type and check pages like a real user.',
    lessons: [_actions, _assertions, _organizing],
  ),
  Tier(
    id: 'advanced',
    order: 2,
    difficulty: 'Advanced',
    title: 'Act III · On Tour',
    description: 'Debug tests, reuse code and control the network.',
    lessons: [_debugging, _pageObjects, _network],
  ),
  Tier(
    id: 'expert',
    order: 3,
    difficulty: 'Expert',
    title: 'Act IV · Standing Ovation',
    description: 'Log in once, run fast in CI, handle tricky pages.',
    lessons: [_authState, _parallelCi, _proTechniques],
  ),
]);

/// All lessons in play order.
final List<Lesson> allLessons = [for (final t in curriculum) ...t.lessons];

List<Tier> _assignOrder(List<Tier> tiers) {
  var order = 0;
  for (final tier in tiers) {
    for (final l in tier.lessons) {
      l.tierId = tier.id;
      l.order = order++;
    }
  }
  return tiers;
}

// ---------------------------------------------------------------------------
// Act I · Beginner
// ---------------------------------------------------------------------------

final _meetPlaywright = lesson(
  'b1',
  title: 'Meet Playwright',
  summary: 'What Playwright is and what it can check on a website for you.',
  conceptTitle: 'Robots that use your website',
  conceptBody:
      'An automated end-to-end (E2E) test is a script that opens a real '
      'browser and uses your app like a person would: it visits pages, '
      'clicks buttons, types text and then checks that the right things '
      'happened.\n\n'
      'Playwright is an open-source framework from Microsoft for exactly '
      'that. One API drives Chromium (Chrome, Edge), Firefox and WebKit '
      '(the engine behind Safari). You can write tests in TypeScript/'
      'JavaScript, Python, Java or C#.\n\n'
      'To start a new project, run the init command. It installs the test '
      'runner, downloads the browsers and creates an example test and a '
      'playwright.config.ts file.',
  conceptCode: '''# Create a new Playwright project
npm init playwright@latest

# Run all tests (headless by default)
npx playwright test

# Watch the browser while tests run
npx playwright test --headed''',
  proTip:
      'Run `npx playwright test --headed` the first few times so you can '
      'actually see what your test is doing.',
  questions: [
    mc(
      'b1-q1',
      'What is Playwright mainly used for?',
      options: [
        'Automating real browsers for end-to-end testing',
        'Designing UI mockups',
        'Hosting websites',
        'Managing SQL databases',
      ],
      answer: 0,
      explain:
          'Playwright drives real browsers so you can test web apps the way '
          'users experience them.',
    ),
    mc(
      'b1-q2',
      'Which browser engines does Playwright support out of the box?',
      options: [
        'Chromium, Firefox and WebKit',
        'Only Google Chrome',
        'Only Internet Explorer',
        'Chromium and Opera only',
      ],
      answer: 0,
      explain:
          'Playwright ships with Chromium, Firefox and WebKit. WebKit is the '
          'engine behind Safari, so you can test Safari-like behaviour even '
          'on Windows or Linux.',
      hint: 'Think of the three big browser families.',
    ),
    mc(
      'b1-q3',
      'Which command scaffolds a brand-new Playwright project?',
      options: [
        'npm init playwright@latest',
        'npm install selenium-webdriver',
        'npx create-react-app',
        'npx playwright open',
      ],
      answer: 0,
      explain:
          '`npm init playwright@latest` installs @playwright/test, downloads '
          'browsers and generates a config file plus example tests.',
    ),
    mc(
      'b1-q4',
      'Which command runs your Playwright tests?',
      options: [
        'npx playwright test',
        'npm start',
        'node tests.js',
        'npx playwright run-all',
      ],
      answer: 0,
      explain:
          '`npx playwright test` finds your test files and runs them with the '
          'Playwright test runner.',
    ),
    tf(
      'b1-q5',
      'Playwright tests can only be written in JavaScript.',
      answer: false,
      explain:
          'Playwright has official libraries for TypeScript/JavaScript, '
          'Python, Java and .NET (C#). TypeScript is the most popular choice.',
    ),
    mc(
      'b1-q6',
      'When you run `npx playwright test`, how do browsers run by default?',
      options: [
        'Headless: no visible browser window',
        'Headed: a visible window pops up',
        'Only in incognito mode on your desktop',
        'In mobile emulation',
      ],
      answer: 0,
      explain:
          'Tests run headless by default, which is faster and works on CI '
          'servers. Add `--headed` to watch them.',
    ),
    tf(
      'b1-q7',
      'An end-to-end test checks a feature through the real user interface, '
          'from the user\'s point of view.',
      answer: true,
      explain:
          'E2E tests exercise the whole stack (UI, backend, database) the way '
          'a user would, which catches bugs unit tests can miss.',
    ),
  ],
);

final _firstTest = lesson(
  'b2',
  title: 'Your First Test',
  summary: 'test(), the page fixture, goto and expect.',
  conceptTitle: 'Anatomy of a test',
  conceptBody:
      'A test is a function passed to `test()`. Playwright hands it '
      '"fixtures" such as `page`: a fresh, isolated browser tab created just '
      'for this test.\n\n'
      'Browser actions take time, so they return Promises. Put `await` in '
      'front of every action and assertion so each step finishes before the '
      'next one starts.\n\n'
      '`expect` checks that something is true. If it is not, the test fails '
      'with a clear message.',
  conceptCode: '''import { test, expect } from '@playwright/test';

test('homepage has the right title', async ({ page }) => {
  await page.goto('https://playwright.dev/');
  await expect(page).toHaveTitle(/Playwright/);
});''',
  proTip:
      'Forgetting `await` is the #1 beginner bug. Enable the '
      '`@typescript-eslint/no-floating-promises` lint rule to catch it.',
  questions: [
    blank(
      'b2-q1',
      'Complete the import every Playwright test file starts with.',
      code: "import { test, ____ } from '@playwright/test';",
      options: ['expect', 'assert', 'check', 'verify'],
      answer: 0,
      explain:
          '`test` declares tests and `expect` makes assertions. Both come '
          'from @playwright/test.',
    ),
    mc(
      'b2-q2',
      'In `async ({ page }) => { ... }`, what is `page`?',
      code: "test('demo', async ({ page }) => { /* ... */ });",
      options: [
        'A fixture: an isolated browser tab provided for this test',
        'A global variable you must create yourself',
        'The HTML source code of the site',
        'A CSS selector',
      ],
      answer: 0,
      explain:
          'Playwright creates a fresh `page` for every test and closes it '
          'afterwards, so tests never share state.',
    ),
    blank(
      'b2-q3',
      'Fill in the method that opens a URL.',
      code: "await page.____('https://example.com');",
      options: ['goto', 'open', 'visit', 'navigate'],
      answer: 0,
      explain:
          '`page.goto(url)` navigates and waits for the page\'s load event by '
          'default.',
      hint: 'Two words squashed together: "go" + "to".',
    ),
    mc(
      'b2-q4',
      'Why do we write `await` before `page.goto()` and `expect(...)`?',
      options: [
        'Browser actions are asynchronous; await waits for each to finish',
        'It makes tests run faster',
        'It is only needed on the first line of a test',
        'It turns off auto-waiting',
      ],
      answer: 0,
      explain:
          'Without `await`, the next line would run before the browser has '
          'finished, and the test might end before anything is checked.',
    ),
    tf(
      'b2-q5',
      'Each test gets its own browser context, so cookies from one test do '
          'not leak into another.',
      answer: true,
      explain:
          'Test isolation is built in: every test gets a brand-new context, '
          'like a fresh incognito profile.',
    ),
    blank(
      'b2-q6',
      'Complete the assertion that checks the page title.',
      code: 'await expect(page).____(/Playwright/);',
      options: ['toHaveTitle', 'toBeTitle', 'hasTitle', 'toContainTitle'],
      answer: 0,
      explain:
          '`toHaveTitle` accepts a string or a regular expression and retries '
          'until the title matches.',
    ),
    mc(
      'b2-q7',
      'Which file names does Playwright treat as tests by default?',
      options: [
        'Files ending in .spec.ts or .test.ts (or .js)',
        'Any file inside node_modules',
        'Only files named test.js',
        'Files ending in .pw',
      ],
      answer: 0,
      explain:
          'The default `testMatch` picks up `*.spec.*` and `*.test.*` files, '
          'e.g. `login.spec.ts`.',
    ),
  ],
);

final _locators = lesson(
  'b3',
  title: 'Finding Elements',
  summary: 'Locators: getByRole, getByLabel, getByText and friends.',
  conceptTitle: 'Locators: how tests find things',
  conceptBody:
      'Before you can click or check something, you need to find it. A '
      'locator describes how to find an element.\n\n'
      'Prefer locators that match what a user sees: its role and accessible '
      'name, its label, placeholder or text. These survive redesigns far '
      'better than CSS classes or XPath.\n\n'
      'Locators are lazy: creating one does not search the page. Playwright '
      'looks up the element fresh every time you act on it, which avoids '
      '"stale element" errors.',
  conceptCode: '''await page.getByRole('button', { name: 'Sign in' }).click();
await page.getByLabel('Email').fill('ada@example.com');
await page.getByPlaceholder('Search').fill('shoes');
await page.getByText('Welcome back').isVisible();
await page.getByTestId('cart-count').textContent();''',
  proTip:
      'Stuck finding the right locator? Run `npx playwright codegen <url>` '
      'and hover over elements: it suggests the best locator for you.',
  questions: [
    mc(
      'b3-q1',
      'Which locator does Playwright recommend trying first?',
      options: [
        'getByRole',
        "page.locator('#some-id')",
        'An XPath expression',
        'A CSS nth-child selector',
      ],
      answer: 0,
      explain:
          '`getByRole` finds elements the way assistive technology and users '
          'perceive them, e.g. "the button named Submit".',
    ),
    blank(
      'b3-q2',
      'Click the button labelled "Submit".',
      code: "await page.getByRole('____', { name: 'Submit' }).click();",
      options: ['button', 'btn', 'submit', 'clickable'],
      answer: 0,
      explain:
          'Roles use ARIA names: button, link, textbox, checkbox, heading, '
          'and so on.',
    ),
    mc(
      'b3-q3',
      'Given this HTML, which is the best locator for the input?',
      code: '''<label for="email">Email</label>
<input id="email" type="email" />''',
      options: [
        "page.getByLabel('Email')",
        "page.getByText('input')",
        "page.locator('input:nth-of-type(3)')",
        "page.getByRole('label')",
      ],
      answer: 0,
      explain:
          'Form fields are best found by their label, just like a user reads '
          'the label to know which box to type in.',
    ),
    mc(
      'b3-q4',
      'The element has `data-testid="checkout"`. How do you locate it?',
      options: [
        "page.getByTestId('checkout')",
        "page.getById('checkout')",
        "page.getByData('checkout')",
        "page.getByTest('checkout')",
      ],
      answer: 0,
      explain:
          '`getByTestId` matches the `data-testid` attribute. Great for '
          'elements with no meaningful text or role.',
    ),
    tf(
      'b3-q5',
      'Creating a locator immediately searches the page and throws if '
          'nothing is found.',
      code: "const btn = page.getByRole('button', { name: 'Save' });",
      answer: false,
      explain:
          'Locators are lazy. The search only happens when you perform an '
          'action or assertion, and Playwright waits for the element then.',
    ),
    mc(
      'b3-q6',
      'Why prefer `getByRole(...)` over a CSS selector like '
          '`.btn-primary > span`?',
      options: [
        'It reflects what users see, so it survives styling and markup changes',
        'CSS selectors are not supported in Playwright',
        'It is shorter to type',
        'It skips auto-waiting, making tests faster',
      ],
      answer: 0,
      explain:
          'Class names change during redesigns; a button\'s role and name '
          'rarely do. That means fewer broken tests.',
    ),
    blank(
      'b3-q7',
      'Locate an input with placeholder "Search products".',
      code: "await page.____('Search products').fill('mug');",
      options: ['getByPlaceholder', 'getByHint', 'getByInput', 'getByPrompt'],
      answer: 0,
      explain: '`getByPlaceholder` matches the input\'s placeholder attribute.',
    ),
  ],
);

// ---------------------------------------------------------------------------
// Act II · Intermediate
// ---------------------------------------------------------------------------

final _actions = lesson(
  'i1',
  title: 'Taking Action',
  summary: 'click, fill, press, check, selectOption and more.',
  conceptTitle: 'Act like a user',
  conceptBody:
      'Once you have a locator, call an action on it: `click()`, `fill()`, '
      '`press()`, `check()`, `selectOption()`, `hover()`, '
      '`setInputFiles()`...\n\n'
      'Before every action Playwright runs actionability checks: it waits '
      'until the element is attached, visible, stable (not animating), '
      'enabled and able to receive clicks. No manual waiting needed.',
  conceptCode: '''await page.getByLabel('Username').fill('ada');
await page.getByLabel('Password').fill('s3cret');
await page.getByLabel('Password').press('Enter');

await page.getByLabel('Remember me').check();
await page.getByLabel('Country').selectOption('Malaysia');
await page.getByLabel('Avatar').setInputFiles('avatar.png');''',
  proTip:
      'Use `fill()` for text inputs. Only reach for `pressSequentially()` '
      'when the page reacts to each key press (e.g. autocomplete).',
  questions: [
    mc(
      'i1-q1',
      'What is the recommended way to set the text of an input?',
      options: ['fill()', 'setValue()', 'write()', 'typeText()'],
      answer: 0,
      explain:
          '`fill()` focuses the field, clears it and enters the text in one '
          'fast, reliable step.',
    ),
    blank(
      'i1-q2',
      'Pick "Large" from a <select> dropdown.',
      code: "await page.getByLabel('Size').____('Large');",
      options: ['selectOption', 'select', 'choose', 'pick'],
      answer: 0,
      explain:
          '`selectOption()` accepts an option\'s value or label (or an array '
          'for multi-selects).',
    ),
    mc(
      'i1-q3',
      'Which action guarantees a checkbox ends up ticked?',
      options: ['check()', 'click()', 'toggle()', 'tick()'],
      answer: 0,
      explain:
          '`check()` does nothing if the box is already checked, and verifies '
          'it became checked. `click()` would un-tick an already ticked box.',
    ),
    blank(
      'i1-q4',
      'Press the Enter key in a textbox.',
      code: "await page.getByRole('textbox').____('Enter');",
      options: ['press', 'key', 'hit', 'keyboard'],
      answer: 0,
      explain:
          '`press()` accepts key names like Enter, Tab, ArrowDown or '
          'combinations like Control+A.',
    ),
    mc(
      'i1-q5',
      'How do you upload a file through an <input type="file">?',
      options: [
        'setInputFiles()',
        'upload()',
        'attachFile()',
        'fill() with the file path',
      ],
      answer: 0,
      explain:
          '`setInputFiles(path)` sets files on the input directly, without '
          'opening the OS file picker.',
    ),
    tf(
      'i1-q6',
      'Before `click()`, Playwright automatically waits for the element to be '
          'visible, stable and enabled.',
      answer: true,
      explain:
          'These actionability checks are why Playwright tests rarely need '
          'manual waits.',
    ),
    mc(
      'i1-q7',
      'An autocomplete box reacts to each individual key press. Which action '
          'fits best?',
      options: ['pressSequentially()', 'fill()', 'check()', 'hover()'],
      answer: 0,
      explain:
          '`pressSequentially()` types one character at a time, firing '
          'keydown/keyup for every key, just like a human typing.',
    ),
  ],
);

final _assertions = lesson(
  'i2',
  title: 'Assertions That Wait',
  summary: 'Web-first assertions, auto-retry, not and soft.',
  conceptTitle: 'Web-first assertions',
  conceptBody:
      'Web pages change over time: data loads, spinners disappear. '
      'Playwright\'s web-first assertions keep retrying until the condition '
      'is met or the timeout (5 seconds by default) runs out.\n\n'
      'Always `await` them and pass a locator or page, not a value you '
      'already read. Add `.not` to invert, and use `expect.soft` to record a '
      'failure without stopping the test.',
  conceptCode: r'''await expect(page.getByText('Welcome back')).toBeVisible();
await expect(page).toHaveURL(/dashboard/);
await expect(page.getByRole('listitem')).toHaveCount(3);
await expect(page.getByTestId('total')).toHaveText('$42.00');
await expect(page.getByRole('alert')).not.toBeVisible();
await expect.soft(page.getByTestId('status')).toHaveText('Active');''',
  proTip:
      'Write `await expect(locator).toHaveText(x)`, not '
      '`expect(await locator.textContent()).toBe(x)`. Only the first one '
      'retries.',
  questions: [
    mc(
      'i2-q1',
      'What makes `expect(locator).toBeVisible()` "web-first"?',
      options: [
        'It automatically retries until it passes or times out',
        'It only runs in Chromium',
        'It compares against a screenshot',
        'It runs before the page loads',
      ],
      answer: 0,
      explain:
          'Web-first assertions poll the page, so they handle slow loading '
          'without any extra waits.',
    ),
    mc(
      'i2-q2',
      'What is the default timeout for `expect` assertions?',
      options: ['5 seconds', '1 second', '30 seconds', 'No timeout'],
      answer: 0,
      explain:
          'Assertions default to 5s. Tests themselves default to 30s. Both '
          'are configurable in playwright.config.ts.',
    ),
    blank(
      'i2-q3',
      'Check the element shows exactly "\$42.00".',
      code: r"await expect(page.getByTestId('total')).____('$42.00');",
      options: ['toHaveText', 'toEqual', 'toBe', 'toMatchText'],
      answer: 0,
      explain:
          '`toHaveText` checks the full text (use `toContainText` for a '
          'substring) and retries until it matches.',
    ),
    blank(
      'i2-q4',
      'Assert that the list has exactly 3 items.',
      code: "await expect(page.getByRole('listitem')).____(3);",
      options: ['toHaveCount', 'toHaveLength', 'toBeCount', 'toEqual'],
      answer: 0,
      explain:
          '`toHaveCount` counts how many elements the locator matches and '
          'retries until it equals the expected number.',
    ),
    mc(
      'i2-q5',
      'How do you assert that an error banner is NOT visible?',
      options: [
        'await expect(banner).not.toBeVisible()',
        'await expect(!banner).toBeVisible()',
        'await expect(banner).never.toBeVisible()',
        'await expect(banner).toBeVisible(false)',
      ],
      answer: 0,
      explain:
          'Chain `.not` before any matcher to invert it. `toBeHidden()` is an '
          'equivalent alternative.',
    ),
    tf(
      'i2-q6',
      "`expect(await locator.textContent()).toBe('Hi')` retries "
          'automatically, just like `toHaveText`.',
      answer: false,
      explain:
          'Here you read the text once and compare a plain string. Nothing is '
          're-read, so it can fail if the page was still updating.',
    ),
    mc(
      'i2-q7',
      'What does `expect.soft(...)` do?',
      options: [
        'Records the failure but lets the test keep running',
        'Makes the assertion optional; it never fails the test',
        'Uses a shorter timeout',
        'Only prints a console warning',
      ],
      answer: 0,
      explain:
          'Soft assertions still mark the test as failed at the end, but let '
          'you collect several failures in one run.',
    ),
    mc(
      'i2-q8',
      'After logging in, how do you check you landed on the dashboard?',
      options: [
        'await expect(page).toHaveURL(/dashboard/)',
        'await expect(page.url).toBeVisible()',
        "await page.checkUrl('/dashboard')",
        "await expect(page).toBeAt('/dashboard')",
      ],
      answer: 0,
      explain:
          '`toHaveURL` accepts a string or regex and waits for navigation to '
          'finish.',
    ),
  ],
);

final _organizing = lesson(
  'i3',
  title: 'Organizing Tests',
  summary: 'describe, hooks, only/skip, tags and the config file.',
  conceptTitle: 'Keep your suite tidy',
  conceptBody:
      'Group related tests with `test.describe`. Use hooks to share setup: '
      '`beforeEach` runs before every test in the group, `beforeAll` once '
      'per worker.\n\n'
      'playwright.config.ts holds shared settings: `baseURL` (so you can '
      'write `page.goto(\'/shop\')`), timeouts, and `projects` to run the '
      'same tests across browsers or devices.\n\n'
      'Tags like `@smoke` let you run a subset with `--grep`.',
  conceptCode: '''test.describe('Cart', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/shop');
  });

  test('adds an item', { tag: '@smoke' }, async ({ page }) => {
    await page.getByRole('button', { name: 'Add to cart' }).click();
    await expect(page.getByTestId('cart-count')).toHaveText('1');
  });
});

// playwright.config.ts
export default defineConfig({
  use: { baseURL: 'http://localhost:3000' },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'webkit', use: { ...devices['Desktop Safari'] } },
  ],
});''',
  proTip:
      'Name tests as behaviours ("adds an item to the cart") so a failing '
      'report reads like a bug description.',
  questions: [
    blank(
      'i3-q1',
      'Group related tests together.',
      code: "test.____('Checkout', () => { /* tests */ });",
      options: ['describe', 'group', 'suite', 'context'],
      answer: 0,
      explain:
          '`test.describe` groups tests; hooks inside it only apply to that '
          'group.',
    ),
    mc(
      'i3-q2',
      'Which hook runs before every single test in a group?',
      options: [
        'test.beforeEach',
        'test.beforeAll',
        'test.setup',
        'test.init',
      ],
      answer: 0,
      explain:
          '`beforeEach` runs before each test; `beforeAll` runs once per '
          'worker before all tests in the group.',
    ),
    mc(
      'i3-q3',
      'While debugging, you want to run just one test. What do you use?',
      options: ['test.only', 'test.solo', 'test.focus', 'test.single'],
      answer: 0,
      explain:
          '`test.only` runs only the marked test(s). Remember to remove it '
          'before committing!',
    ),
    mc(
      'i3-q4',
      "Why does `page.goto('/shop')` work with a relative URL?",
      code: "await page.goto('/shop');",
      options: [
        'baseURL is set in playwright.config.ts',
        'Playwright guesses the domain',
        'Relative URLs always go to localhost:3000',
        'It does not work; URLs must be absolute',
      ],
      answer: 0,
      explain:
          'With `use: { baseURL }` configured, relative paths are resolved '
          'against it. Switching environments becomes a one-line change.',
    ),
    mc(
      'i3-q5',
      'What are `projects` in the config commonly used for?',
      options: [
        'Running the same tests on different browsers or devices',
        'Splitting code into separate git repositories',
        'Defining the database schema',
        'Storing passwords',
      ],
      answer: 0,
      explain:
          'Each project can have its own browser, device, baseURL or '
          'storageState, and all projects run from one command.',
    ),
    mc(
      'i3-q6',
      'How do you run only the tests tagged @smoke?',
      options: [
        'npx playwright test --grep @smoke',
        'npx playwright test --tag smoke',
        'npx playwright test --only smoke',
        'npx playwright test --filter=@smoke',
      ],
      answer: 0,
      explain:
          '`--grep` filters by title and tags; `--grep-invert` excludes '
          'matches.',
    ),
    tf(
      'i3-q7',
      '`test.skip()` marks a test as skipped so it is not executed.',
      answer: true,
      explain:
          'Skipped tests appear in the report as skipped. `test.fixme()` is '
          'similar but signals the test is known to be broken.',
    ),
  ],
);

// ---------------------------------------------------------------------------
// Act III · Advanced
// ---------------------------------------------------------------------------

final _debugging = lesson(
  'a1',
  title: 'Waiting & Debugging',
  summary: 'No hard waits, UI mode, Inspector, traces and codegen.',
  conceptTitle: 'When tests misbehave',
  conceptBody:
      'Hard waits like `page.waitForTimeout(3000)` are a guess: too short and '
      'the test flakes, too long and it is slow. Instead, wait for a real '
      'condition with an assertion or `page.waitForResponse`.\n\n'
      'Playwright ships great debugging tools: UI mode (`--ui`) to watch and '
      'time-travel through tests, the Inspector (`--debug`) to step line by '
      'line, and the Trace Viewer to replay a failed CI run with DOM '
      'snapshots, network and console logs.',
  conceptCode: '''# Watch mode with time-travel debugging
npx playwright test --ui

# Step through a test with the Inspector
npx playwright test login.spec.ts --debug

# Record actions and generate code
npx playwright codegen https://demo.playwright.dev/todomvc

# playwright.config.ts
use: { trace: 'on-first-retry' }''',
  proTip:
      'Add `await page.pause()` anywhere in a test to stop there and open '
      'the Inspector.',
  questions: [
    mc(
      'a1-q1',
      'Why should you avoid `await page.waitForTimeout(3000)`?',
      options: [
        'It is a fixed guess: slow when too long, flaky when too short',
        'It is deprecated and always throws',
        'It only works in Firefox',
        'It clears the cookies',
      ],
      answer: 0,
      explain:
          'Wait for something meaningful (an element, a URL, a response) '
          'instead of a number of milliseconds.',
    ),
    mc(
      'a1-q2',
      'Which command records your clicks and generates test code?',
      options: [
        'npx playwright codegen',
        'npx playwright record',
        'npx playwright generate',
        'npx playwright capture',
      ],
      answer: 0,
      explain:
          'Codegen opens a browser plus a window that writes the matching '
          'Playwright code as you interact.',
    ),
    mc(
      'a1-q3',
      'Which flag opens the Playwright Inspector to step through a test?',
      options: ['--debug', '--inspect-only', '--step', '--verbose'],
      answer: 0,
      explain:
          '`--debug` runs headed, with no timeout, and pauses before the '
          'first action so you can step through.',
    ),
    mc(
      'a1-q4',
      'What does a Playwright trace let you do?',
      options: [
        'Replay each action with DOM snapshots, network and console logs',
        'Re-run the test twice as fast',
        'Encrypt your test data',
        'Deploy your app',
      ],
      answer: 0,
      explain:
          'Open it with `npx playwright show-trace trace.zip` or from the HTML '
          'report. It is invaluable for CI-only failures.',
    ),
    blank(
      'a1-q5',
      'A popular CI setting: record a trace only when a failed test is '
          'retried.',
      code: "use: { trace: '____' }",
      options: ['on-first-retry', 'always-on-fail', 'retry-only', 'if-failed'],
      answer: 0,
      explain:
          "'on-first-retry' keeps runs fast but captures a trace exactly when "
          "you need it. 'retain-on-failure' is another common choice.",
    ),
    mc(
      'a1-q6',
      'How do you open UI mode?',
      options: [
        'npx playwright test --ui',
        'npx playwright ui-mode',
        'npx playwright test --gui',
        'npx playwright watch',
      ],
      answer: 0,
      explain:
          'UI mode gives you a watch mode, a timeline and a locator picker in '
          'one window.',
    ),
    blank(
      'a1-q7',
      'After clicking "Save", you need the /api/orders call to finish. '
          'Which is best?',
      code: '''const responsePromise = page.____;
await page.getByRole('button', { name: 'Save' }).click();
await responsePromise;''',
      options: [
        "waitForResponse('**/api/orders')",
        'waitForTimeout(5000)',
        'pause()',
        'reload()',
      ],
      answer: 0,
      explain:
          'Start waiting before the click so you cannot miss a fast response, '
          'then await it afterwards.',
    ),
    tf(
      'a1-q8',
      'Thanks to auto-waiting and web-first assertions, you rarely need '
          'explicit waits.',
      answer: true,
      explain:
          'If you find yourself adding waits, there is usually an assertion '
          'that expresses the condition better.',
    ),
  ],
);

final _pageObjects = lesson(
  'a2',
  title: 'Page Objects & Fixtures',
  summary: 'Structure large suites for readability and reuse.',
  conceptTitle: 'Write it once, use it everywhere',
  conceptBody:
      'The Page Object Model (POM) wraps a page\'s locators and actions in a '
      'class. Tests then read like a story (`loginPage.login(...)`) and when '
      'the UI changes, you fix one file instead of fifty tests.\n\n'
      'Fixtures take this further: `test.extend` lets you define your own '
      'fixtures that tests request by name. Code before `use()` is setup, '
      'code after it is teardown.',
  conceptCode: '''// login-page.ts
export class LoginPage {
  constructor(private readonly page: Page) {}

  async login(email: string, password: string) {
    await this.page.getByLabel('Email').fill(email);
    await this.page.getByLabel('Password').fill(password);
    await this.page.getByRole('button', { name: 'Sign in' }).click();
  }
}

// fixtures.ts
export const test = base.extend<{ loginPage: LoginPage }>({
  loginPage: async ({ page }, use) => {
    await page.goto('/login');
    await use(new LoginPage(page));
  },
});

// login.spec.ts
test('logs in', async ({ loginPage, page }) => {
  await loginPage.login('ada@example.com', 'secret');
  await expect(page).toHaveURL(/dashboard/);
});''',
  proTip:
      'Keep assertions in tests and actions in page objects. It keeps page '
      'objects reusable across very different tests.',
  questions: [
    mc(
      'a2-q1',
      'What is the main benefit of the Page Object Model?',
      options: [
        'Locators and actions live in one place: readable, maintainable tests',
        'Tests automatically run in parallel',
        'It replaces the need for assertions',
        'It makes the browser render faster',
      ],
      answer: 0,
      explain:
          'POM is about maintainability: one change in the UI means one '
          'change in your code.',
    ),
    mc(
      'a2-q2',
      'The "Sign in" button is renamed to "Log in". With POM, what do you '
          'update?',
      options: [
        'Only the LoginPage class',
        'Every test that logs in',
        'playwright.config.ts',
        'Nothing, it updates itself',
      ],
      answer: 0,
      explain:
          'All tests call `loginPage.login()`, so the fix lives in one place.',
    ),
    blank(
      'a2-q3',
      'Create a test object with a custom fixture.',
      code:
          'export const test = base.____<{ loginPage: LoginPage }>({ /* ... */ });',
      options: ['extend', 'fixture', 'with', 'create'],
      answer: 0,
      explain:
          '`test.extend` returns a new `test` function that knows about your '
          'fixtures. Import it instead of the base one.',
    ),
    mc(
      'a2-q4',
      'In a fixture, what does `await use(value)` do?',
      code: '''loginPage: async ({ page }, use) => {
  await use(new LoginPage(page));
  // cleanup here
},''',
      options: [
        'Hands the value to the test; code after it runs as teardown',
        'Saves the value to disk',
        'Imports a fixture from another file',
        'Logs the value to the console',
      ],
      answer: 0,
      explain:
          'The test runs while `use()` is pending. When the test finishes, '
          'the fixture continues and can clean up.',
    ),
    tf(
      'a2-q5',
      "A page object's constructor typically receives Playwright's `page`, "
          'so its methods can create locators.',
      answer: true,
      explain:
          'Passing `page` in keeps the class simple and lets fixtures build it '
          'for each test.',
    ),
    mc(
      'a2-q6',
      'Which of these is NOT a built-in Playwright Test fixture?',
      options: ['database', 'page', 'context', 'request'],
      answer: 0,
      explain:
          'Built-ins include `page`, `context`, `browser`, `browserName` and '
          '`request`. A database fixture is something you would add yourself '
          'with `test.extend`.',
    ),
    mc(
      'a2-q7',
      'When is a fixture set up?',
      options: [
        'Only when a test (or another fixture) asks for it by name',
        'For every test, whether used or not',
        'Once per machine',
        'When the config file is loaded',
      ],
      answer: 0,
      explain: 'Fixtures are on-demand, so unused ones cost nothing.',
    ),
  ],
);

final _network = lesson(
  'a3',
  title: 'Network & API Testing',
  summary: 'Mock responses with route() and call APIs with request.',
  conceptTitle: 'Control the network',
  conceptBody:
      '`page.route()` intercepts requests the page makes. You can fulfil them '
      'with fake data, modify them, or abort them. That lets you test edge '
      'cases (empty lists, server errors) without touching the backend.\n\n'
      'The `request` fixture sends HTTP requests directly, with no browser. '
      'Use it for API tests, or to create test data quickly before a UI test.',
  conceptCode: '''// Mock an API response
await page.route('**/api/products', route =>
  route.fulfill({ json: [{ id: 1, name: 'Mock Mug' }] }),
);

// Simulate a server error
await page.route('**/api/cart', route => route.fulfill({ status: 500 }));

// API test, no browser needed
test('creates a user', async ({ request }) => {
  const res = await request.post('/api/users', { data: { name: 'Ada' } });
  expect(res.ok()).toBeTruthy();
});''',
  proTip:
      'Seed data through the API, then test the UI. It is faster and far '
      'less flaky than clicking through setup screens.',
  questions: [
    blank(
      'a3-q1',
      'Intercept calls to the products API.',
      code:
          "await page.____('**/api/products', route => route.fulfill({ json: [] }));",
      options: ['route', 'intercept', 'mock', 'stub'],
      answer: 0,
      explain:
          '`page.route(urlPattern, handler)` intercepts matching requests. '
          '`context.route` does the same for every page in the context.',
    ),
    mc(
      'a3-q2',
      'What does `route.fulfill(...)` do?',
      options: [
        'Answers with your fake response without contacting the server',
        'Sends the original request to the server',
        'Blocks all network traffic',
        'Retries the request',
      ],
      answer: 0,
      explain:
          'Perfect for testing how the UI handles specific data or errors.',
    ),
    blank(
      'a3-q3',
      'You want to block all image requests to speed things up. Which call '
          'goes in the handler?',
      code: "await page.route('**/*.{png,jpg}', route => route.____);",
      options: ['abort()', 'fulfill()', 'continue()', 'skip()'],
      answer: 0,
      explain: '`route.abort()` cancels the request as if the network failed.',
    ),
    mc(
      'a3-q4',
      'Which fixture sends HTTP requests without a browser?',
      options: ['request', 'api', 'http', 'fetch'],
      answer: 0,
      explain:
          'The `request` fixture is an APIRequestContext that honours your '
          'baseURL and extra HTTP headers from the config.',
    ),
    blank(
      'a3-q5',
      'Check the response status is 2xx.',
      code:
          "const res = await request.get('/api/health');\n"
          'expect(res.____()).toBeTruthy();',
      options: ['ok', 'success', 'passed', 'isGood'],
      answer: 0,
      explain:
          '`res.ok()` is true for status 200-299. Use `res.status()` for the '
          'exact code and `await res.json()` for the body.',
    ),
    tf(
      'a3-q6',
      '`page.route()` must be set up before the page makes the request you '
          'want to intercept.',
      answer: true,
      explain:
          'Register routes before `page.goto()` or the click that triggers '
          'the request, otherwise the real request has already gone out.',
    ),
    mc(
      'a3-q7',
      'Why create test data through the API in a UI test?',
      options: [
        'It is faster and more reliable than clicking through setup screens',
        'API tests replace the need for UI tests',
        'Browsers cannot send POST requests',
        'Playwright requires it',
      ],
      answer: 0,
      explain:
          'Test the UI you care about; set everything else up in the '
          'background.',
    ),
    mc(
      'a3-q8',
      'You want to add a header but still send the request to the real '
          'server. Which call?',
      options: [
        'route.continue({ headers })',
        'route.fulfill({ headers })',
        'route.abort()',
        'page.goto()',
      ],
      answer: 0,
      explain:
          '`route.continue()` lets the request through, optionally with '
          'changed URL, method, headers or body.',
    ),
  ],
);

// ---------------------------------------------------------------------------
// Act IV · Expert
// ---------------------------------------------------------------------------

final _authState = lesson(
  'e1',
  title: 'Authentication & State',
  summary: 'Log in once, reuse storageState everywhere.',
  conceptTitle: 'Stop logging in 500 times',
  conceptBody:
      'Logging in through the UI in every test is slow. Instead, log in once '
      'in a setup project, save the browser\'s storage state (cookies and '
      'local storage) to a file, and start every other test already '
      'authenticated.\n\n'
      'Projects with `dependencies` make sure setup runs first. Keep '
      'credentials in environment variables and the saved state file out of '
      'git.',
  conceptCode: '''// auth.setup.ts
setup('authenticate', async ({ page }) => {
  await page.goto('/login');
  await page.getByLabel('Email').fill(process.env.USER_EMAIL!);
  await page.getByLabel('Password').fill(process.env.USER_PASSWORD!);
  await page.getByRole('button', { name: 'Sign in' }).click();
  await page.context().storageState({ path: 'playwright/.auth/user.json' });
});

// playwright.config.ts
projects: [
  { name: 'setup', testMatch: /.*\\.setup\\.ts/ },
  {
    name: 'chromium',
    use: { storageState: 'playwright/.auth/user.json' },
    dependencies: ['setup'],
  },
],''',
  proTip:
      'Add `playwright/.auth` to .gitignore. The file contains live session '
      'cookies.',
  questions: [
    mc(
      'e1-q1',
      'What does storageState save?',
      options: [
        'Cookies and local storage (optionally IndexedDB)',
        'Screenshots of every page',
        'Your test source code',
        'Environment variables',
      ],
      answer: 0,
      explain:
          'Loading that state into a new context makes the app think you are '
          'already logged in.',
    ),
    mc(
      'e1-q2',
      'Why log in once and reuse the state?',
      options: [
        'It is faster and less flaky than logging in through the UI each test',
        'Playwright forbids logging in more than once',
        'It encrypts your password',
        'It is required for headless mode',
      ],
      answer: 0,
      explain:
          'Test the login flow in one dedicated test; every other test skips '
          'straight to what it is really testing.',
    ),
    blank(
      'e1-q3',
      'Make the chromium project wait for the login project.',
      code: "{ name: 'chromium', dependencies: ['____'] }",
      options: ['setup', 'before', 'auth.json', 'global'],
      answer: 0,
      explain:
          '`dependencies` lists project names that must pass first. Here the '
          'project named "setup" writes the auth file.',
    ),
    tf(
      'e1-q4',
      'You should commit the saved auth file (playwright/.auth/user.json) '
          'to git.',
      answer: false,
      explain:
          'It contains real session tokens. Ignore it in git and let the '
          'setup project regenerate it on every run.',
    ),
    mc(
      'e1-q5',
      'Where should test account credentials come from?',
      options: [
        'Environment variables or CI secrets',
        'Hard-coded in the test file',
        'A public README',
        'Default values in the page object',
      ],
      answer: 0,
      explain:
          'Use `process.env.X` locally (e.g. via a .env file) and your CI '
          'provider\'s secret store in pipelines.',
    ),
    mc(
      'e1-q6',
      'A test needs an admin and a customer chatting at the same time. How?',
      options: [
        'Two browser contexts, each with its own storageState',
        'Two tabs in the same context',
        'Two workers',
        'It is impossible in Playwright',
      ],
      answer: 0,
      explain:
          'Contexts are isolated like separate browser profiles, so each can '
          'be logged in as a different user within one test.',
    ),
    blank(
      'e1-q7',
      'Start this file\'s tests logged out, overriding the project default.',
      code: 'test.use({ storageState: ____ });',
      options: [
        '{ cookies: [], origins: [] }',
        'null',
        "'logout'",
        'false',
      ],
      answer: 0,
      explain:
          'An empty storage state resets cookies and origins, so the test '
          'starts as an anonymous visitor.',
    ),
  ],
);

final _parallelCi = lesson(
  'e2',
  title: 'Parallel Runs & CI',
  summary: 'Workers, sharding, retries and reporters.',
  conceptTitle: 'Fast, reliable pipelines',
  conceptBody:
      'Playwright runs test files in parallel worker processes. '
      '`fullyParallel: true` also parallelises tests inside a file. For huge '
      'suites, split the work across machines with `--shard`.\n\n'
      'On CI, retries catch flaky tests (reported as "flaky" so you can fix '
      'them), `forbidOnly` prevents a stray `test.only` from silently '
      'skipping everything, and reporters produce HTML, JUnit or JSON '
      'output.\n\n'
      'Parallelism only works if tests are independent: never rely on '
      'another test having run first.',
  conceptCode: '''export default defineConfig({
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 2 : undefined,
  reporter: [['html'], ['junit', { outputFile: 'results.xml' }]],
});

# Split the suite across 4 machines
npx playwright test --shard=1/4''',
  proTip:
      'Treat "flaky" in the report as a bug to fix, not a pass. Retries are a '
      'safety net, not a solution.',
  questions: [
    mc(
      'e2-q1',
      'By default, how does Playwright run tests?',
      options: [
        'Files in parallel across workers; tests within a file in order',
        'Everything strictly one after another',
        'Every test in parallel, always',
        'All tests in a single browser tab',
      ],
      answer: 0,
      explain:
          'That default balances speed with safety. Opt into more with '
          '`fullyParallel`.',
    ),
    blank(
      'e2-q2',
      'Run tests inside the same file in parallel too.',
      code: 'export default defineConfig({ ____: true });',
      options: ['fullyParallel', 'parallelAll', 'concurrent', 'multiThread'],
      answer: 0,
      explain:
          'You can also enable it per file with '
          "`test.describe.configure({ mode: 'parallel' })`.",
    ),
    mc(
      'e2-q3',
      'How do you split a suite across 4 CI machines?',
      options: [
        'Run with --shard=1/4, --shard=2/4, ... on each machine',
        '--workers=4',
        '--split 4',
        '--parallel=4',
      ],
      answer: 0,
      explain:
          'Workers are processes on one machine; shards split the suite '
          'between machines. Merge the results with the blob reporter.',
    ),
    mc(
      'e2-q4',
      'What does `forbidOnly: !!process.env.CI` do?',
      options: [
        'Fails the CI run if a test.only was left in the code',
        'Only allows one browser',
        'Forces a single worker',
        'Disables retries',
      ],
      answer: 0,
      explain:
          'Without it, a forgotten `test.only` would make CI run a single '
          'test and still go green.',
    ),
    tf(
      'e2-q5',
      'With retries enabled, a test that fails first and then passes is '
          'reported as "flaky".',
      answer: true,
      explain:
          'The report separates flaky from passed so you can track and fix '
          'unstable tests.',
    ),
    mc(
      'e2-q6',
      'Why must tests be independent of each other?',
      options: [
        'Workers run them in any order; shared state causes random failures',
        'Playwright deletes shared variables',
        'Independent tests compile faster',
        'Reporters require it',
      ],
      answer: 0,
      explain:
          'Each test should create what it needs (ideally via API) and not '
          'depend on leftovers from another test.',
    ),
    mc(
      'e2-q7',
      'How do you open the HTML report after a run?',
      options: [
        'npx playwright show-report',
        'npx playwright report --open',
        'npx playwright html',
        'open results.xml',
      ],
      answer: 0,
      explain:
          'The HTML report lets you filter by status, see errors, screenshots '
          'and open traces.',
    ),
  ],
);

final _proTechniques = lesson(
  'e3',
  title: 'Pro Techniques',
  summary: 'Filtering, frames, popups, dialogs and visual tests.',
  conceptTitle: 'The tricky stuff, made easy',
  conceptBody:
      'Narrow locators down by chaining and filtering: find the table row '
      'containing "Ada", then the Edit button inside it.\n\n'
      'Iframes need `frameLocator()`. For new tabs, start waiting for the '
      '"popup" event before the click that opens it. Browser dialogs '
      '(alert/confirm) are auto-dismissed unless you handle them.\n\n'
      'Visual regression tests compare a screenshot to a saved baseline with '
      '`toHaveScreenshot()`.',
  conceptCode: '''// Chain & filter
const row = page.getByRole('row').filter({ hasText: 'Ada Lovelace' });
await row.getByRole('button', { name: 'Edit' }).click();

// Inside an iframe
await page.frameLocator('#payment').getByLabel('Card number').fill('4242 4242 4242 4242');

// New tab
const popupPromise = page.waitForEvent('popup');
await page.getByText('Open docs').click();
const popup = await popupPromise;

// Dialogs
page.on('dialog', dialog => dialog.accept());

// Visual check
await expect(page).toHaveScreenshot('home.png');''',
  proTip:
      'Mask dynamic areas (dates, avatars) in screenshots with '
      '`toHaveScreenshot({ mask: [locator] })` to avoid false failures.',
  questions: [
    blank(
      'e3-q1',
      'Find the list item that contains "Milk".',
      code: "page.getByRole('listitem').____({ hasText: 'Milk' })",
      options: ['filter', 'where', 'find', 'has'],
      answer: 0,
      explain:
          '`filter` narrows a locator by text (`hasText`) or by a child '
          'locator (`has`).',
    ),
    mc(
      'e3-q2',
      'How do you interact with a field inside an iframe?',
      options: [
        "page.frameLocator('#frame').getByLabel('Name')",
        "page.getByLabel('Name'); iframes are searched automatically",
        "page.switchTo().frame('#frame')",
        'Iframes cannot be automated',
      ],
      answer: 0,
      explain:
          '`frameLocator` scopes locators into the iframe. `switchTo()` is '
          'Selenium, not Playwright.',
    ),
    mc(
      'e3-q3',
      'A link opens a new tab. What is the right order?',
      options: [
        "Start waitForEvent('popup'), click, then await the promise",
        'Click, then wait 5 seconds',
        'Reload the page',
        'New tabs cannot be automated',
      ],
      answer: 0,
      explain:
          'Starting to wait before the click guarantees you do not miss the '
          'event, however fast the tab opens.',
    ),
    mc(
      'e3-q4',
      'What does `await expect(page).toHaveScreenshot()` compare against?',
      options: [
        'A baseline image saved from an earlier run',
        'The live production website',
        'A Figma design file',
        'The previous test\'s screenshot',
      ],
      answer: 0,
      explain:
          'The first run creates the baseline (golden) image. Later runs fail '
          'if pixels differ beyond the threshold.',
    ),
    blank(
      'e3-q5',
      'The design changed on purpose. Refresh the baseline screenshots.',
      code: 'npx playwright test ____',
      options: [
        '--update-snapshots',
        '--refresh',
        '--new-baseline',
        '--overwrite',
      ],
      answer: 0,
      explain:
          'Review the new images in your pull request like any other code '
          'change.',
    ),
    mc(
      'e3-q6',
      'How do you accept a browser `confirm()` dialog?',
      options: [
        "page.on('dialog', dialog => dialog.accept())",
        "page.getByRole('dialog').click()",
        'page.confirm()',
        "page.keyboard.press('Enter')",
      ],
      answer: 0,
      explain:
          'Native dialogs are auto-dismissed by default. Register a handler '
          'before the action that triggers the dialog.',
    ),
    mc(
      'e3-q7',
      'How do you run tests as an iPhone?',
      options: [
        "use: { ...devices['iPhone 13'] }",
        'Resize the window to 390px',
        'Install Safari on your laptop',
        'Mobile is not supported',
      ],
      answer: 0,
      explain:
          'Device descriptors set viewport, user agent, touch support and '
          'device scale factor in one go.',
    ),
    tf(
      'e3-q8',
      '`.first()` and `.nth(2)` are the most robust way to pick an element.',
      answer: false,
      explain:
          'Positions change when content changes. Prefer filtering by text, '
          'role or a child element, and use position only as a last resort.',
    ),
  ],
);
