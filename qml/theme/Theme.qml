pragma Singleton
import QtQuick

QtObject {
    id: theme

    // ==========================================
    // 1. Color Palette (Dark Cinematic Workstation)
    // ==========================================
    readonly property color background: "#08090C"
    readonly property color surface: "#111318"
    readonly property color surfaceSecondary: "#181B22"
    readonly property color surfaceElevated: surfaceSecondary
    readonly property color surfaceHover: "#1F232B"
    readonly property color surfaceActive: "#242933"

    // Primary Accents
    readonly property color primary: "#7C5CFF"
    readonly property color primaryHover: "#8E72FF"
    readonly property color primaryPressed: "#6644F0"
    readonly property color primarySubtle: "#231B40"

    // Secondary Accent
    readonly property color accent: "#00D4FF"
    readonly property color accentHover: "#33DDFF"
    readonly property color accentPressed: "#00B8DE"
    readonly property color accentSubtle: "#0D2C38"

    // Text Hierarchy
    readonly property color textPrimary: "#F5F7FA"
    readonly property color textMuted: "#8B93A1"
    readonly property color textSubtle: "#585F6D"
    readonly property color textOnPrimary: "#FFFFFF"

    // Borders & Dividers
    readonly property color border: "#292E36"
    readonly property color borderSubtle: "#1C2027"
    readonly property color borderFocus: "#7C5CFF"
    readonly property color borderHover: "#3D4450"

    // Status Colors
    readonly property color success: "#35D39A"
    readonly property color successHover: "#42E8AB"
    readonly property color successPressed: "#28B884"
    readonly property color successSubtle: "#102D22"
    readonly property color warning: "#FFB547"
    readonly property color warningSubtle: "#33240D"
    readonly property color error: "#FF5C68"
    readonly property color errorSubtle: "#381518"

    // Overlay
    readonly property color overlay: "#80000000"

    // ==========================================
    // 2. Typography Scale
    // ==========================================
    readonly property string fontFamily: "Segoe UI"

    readonly property int fontApplicationTitle: 18
    readonly property int fontPageTitle: 22
    readonly property int fontSectionHeading: 15
    readonly property int fontBody: 13
    readonly property int fontSecondaryText: 12
    readonly property int fontLabel: 11
    readonly property int fontCaption: 10
    readonly property int fontButton: 12
    readonly property int fontMetadata: 11
    readonly property int fontStatus: 11

    readonly property int fontSizeXs: 10          // Eyebrow badges, micro metadata
    readonly property int fontSizeSm: 12          // Secondary labels, captions, button text
    readonly property int fontSizeBase: 13        // Body text, standard inputs, list titles
    readonly property int fontSizeMd: 15          // Card titles, module subtitles
    readonly property int fontSizeLg: 18          // Brand title, section headers
    readonly property int fontSizeXl: 22          // Main page titles
    readonly property int fontSizeDisplay: 28     // Large display numbers/metrics
    readonly property int iconDisplay: 30

    readonly property int weightNormal: Font.Normal       // 400
    readonly property int weightMedium: Font.Medium       // 500
    readonly property int weightDemiBold: Font.DemiBold   // 600
    readonly property int weightBold: Font.Bold           // 700

    readonly property int weightApplicationTitle: weightBold
    readonly property int weightPageTitle: weightBold
    readonly property int weightSectionHeading: weightDemiBold
    readonly property int weightBody: weightNormal
    readonly property int weightSecondaryText: weightNormal
    readonly property int weightLabel: weightDemiBold
    readonly property int weightCaption: weightMedium
    readonly property int weightButton: weightDemiBold
    readonly property int weightMetadata: weightNormal
    readonly property int weightStatus: weightDemiBold

    // ==========================================
    // 3. Spacing System
    // ==========================================
    readonly property int spacingXs: 4            // Micro gaps between title & subtitle
    readonly property int spacingSm: 8            // Icon to label gap, tag margins
    readonly property int spacingMd: 16           // Internal card padding, column gap
    readonly property int spacingLg: 24           // Page section separation
    readonly property int spacingXl: 32           // Major page canvas padding
    readonly property int spacingXxl: 48          // Hero spacing

    // ==========================================
    // 4. Corner Radius System
    // ==========================================
    readonly property int radiusXs: 4             // Subtle tags, small badges
    readonly property int radiusSm: 6             // Action buttons, text inputs
    readonly property int radiusMd: 8             // Inner cards, list item selections
    readonly property int radiusLg: 12            // Main workstation cards, drop zones
    readonly property int radiusPill: 999         // Status pills, circular avatars

    // ==========================================
    // 5. Animation Timings
    // ==========================================
    readonly property int animFast: 120           // Hover feedback, button press
    readonly property int animNormal: 200         // Card expansion, selection shifts
    readonly property int animSlow: 300           // View transitions, notifications
}
