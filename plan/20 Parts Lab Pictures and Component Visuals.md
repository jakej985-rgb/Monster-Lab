# 20 Parts Lab Pictures and Component Visuals

## Goal
Add clear pictures/illustrations to Parts Lab so learners can visually identify the real hardware they are working with.

## Tasks
### Part Images
- Add an image reference to every supported component.
- Use real component photos where practical.
- Use clear illustrations when a real photo is unavailable.
- Keep images consistent in framing and background.
- Make each image clearly show the component being discussed.

### Parts Lab Cards
- Add a component image to each Parts Lab card.
- Keep the existing part number, name, model, and key label.
- Make the image large enough to identify the hardware.
- Keep the grid readable on phones and tablets.
- Preserve fast scrolling and offline-first behavior.

### Part Detail Module
- Add a large component image at the top of the part detail view.
- Show the component name and model beside/under the image.
- Show important visual identifiers.
- Show pin/header locations when useful.
- Add multiple images when one photo cannot clearly explain the component.
- Connect images to the existing purpose, pins, wiring, safety, mistakes, experiments, lessons, and projects content.

### Image Assets
- Create a predictable local asset structure.
- Use stable filenames tied to component IDs.
- Keep assets bundled for offline use.
- Avoid runtime image downloads for core component identification.
- Add a fallback placeholder for missing images.
- Keep asset sizes reasonable for mobile storage and performance.

### Data Model
- Add image metadata to the component model.
- Support a primary image.
- Support optional secondary/detail images.
- Keep image data separate from curriculum text so content can evolve independently.
- Preserve compatibility with existing component data.

### Accessibility
- Add meaningful image descriptions/semantic labels.
- Do not rely on image color alone to identify a component.
- Ensure text remains available when an image fails.
- Keep images readable with larger text/accessibility settings.

### Content Standards
- Verify every image matches the exact component/model.
- Avoid misleading generic photos when the physical layout differs.
- Show important connector, pin, switch, or sensor locations when relevant.
- Use consistent orientation where possible.
- Document image source/licensing requirements for any externally sourced images.

## Tests
### Parts Lab Tests
- Every supported component resolves its primary image.
- Image appears on the component card.
- Image appears in component detail.
- Missing image uses fallback.
- Search/filtering still works.
- Category navigation still works.

### Data Tests
- Image metadata loads from curriculum data.
- Serialization/deserialization preserves image references.
- Existing components without image metadata remain usable.

### Widget Tests
- Part card renders image and text.
- Detail screen renders primary image.
- Multiple images render when supplied.
- Fallback renders when the asset is unavailable.
- Accessibility labels are present.

### Performance Checks
- Parts Lab remains responsive while scrolling.
- Images do not cause excessive memory usage.
- Offline mode displays component images.
- Cold start remains acceptable.

## Validation
flutter analyze
flutter test
Manual Android validation.

## Done When
- Learners can see what each component looks like before opening it.
- Part detail shows a clear picture of the physical hardware.
- Images work offline.
- All supported parts have verified visual assets or an intentional fallback.
- Existing Parts Lab functionality still works.
- Tests and analysis pass.
