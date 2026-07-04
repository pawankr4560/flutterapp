# Inventory Feature

## Purpose
Owns stock tracking workflows for shopkeepers and retail businesses in FinHub.

## Responsibilities
- Define inventory domain entities.
- Provide product stock state through Riverpod providers.
- Support low-stock detection and immutable stock updates.
- Keep future inventory screens, widgets, use cases, repositories, and data sources isolated inside this feature.

## What Belongs Here
- Inventory-specific entities such as `InventoryItem`.
- Inventory providers such as `inventoryProvider`.
- Product list, stock adjustment, low-stock alert, and inventory report UI.
- Inventory application, domain, and data layer code.

## What Should NOT Be Placed Here
- Loan, dashboard, booking, dairy, plot, or authentication logic.
- Shared design system widgets or theme values.
- Generic API clients, app routing, or cross-feature services.
