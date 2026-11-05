# Music Forum browser compatibility

## Target browser

The legacy target for this project is Firefox 68 on Android 4.4 (KitKat).

## Current state

- Hebrew is configured as the initial forum language for new installations.
- The Hebrew locale declares right-to-left text direction.
- The default categories and first welcome topic are written for a Hebrew-language music community.
- A small, conservative SCSS layer adds Hebrew typography and mobile spacing.

## Compatibility is not yet certified

NodeBB 4.x and its Harmony theme are modern web applications. A right-to-left locale and conservative CSS do not make the complete application compatible with Firefox 68. The application bundles, dependencies, theme components, editor, uploads, and real-time features must all be tested.

Do not advertise Firefox 68 / KitKat support as guaranteed until the following checks pass on a real Android 4.4 device running Firefox 68:

1. Open the home page and category pages without JavaScript errors.
2. Register, log in, and log out.
3. Open a topic, read replies, and create a reply.
4. Open the composer, type Hebrew and English, and submit a post.
5. Navigate menus, search, notifications, and user profiles.
6. Upload an image and open it.
7. Confirm that RTL layout, mixed Hebrew/English text, dates, and code blocks render correctly.

## Implementation policy

- Prefer CSS syntax with graceful fallbacks.
- Avoid introducing new browser APIs or JavaScript syntax without a tested fallback.
- Keep modern-browser functionality intact.
- Record failures by browser version and fix the narrowest responsible component.
- Re-test after NodeBB or theme upgrades.
