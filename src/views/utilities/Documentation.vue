<template>
    <div class="card">
        <div class="font-semibold text-2xl mb-4">Documentation</div>

        <div class="font-semibold text-xl mb-4">Get Started</div>
        <p class="text-lg mb-4">
            Diamond is an application template and is based on <a href="https://github.com/vuejs/create-vue" class="font-medium text-primary hover:underline">create-vue</a>, the recommended way to start a Vite-powered Vue projects.
        </p>
        <p class="text-lg mb-4">To get started, extract the contents of the zip file, cd to the directory and install the dependencies with npm, yarn or pnpm.</p>
        <pre class="app-code">
<code>npm install
npm run dev</code></pre>

        <p class="text-lg mb-4">Navigate to <i class="bg-highlight px-2 py-1 rounded-border not-italic text-base">http://localhost:5173/</i> to view the application in your local environment.</p>

        <div class="font-semibold text-xl mb-4">Structure</div>
        <p class="text-lg mb-4">Diamond consists of a couple folders, demos and layout have been separated so that you can easily remove what is not necessary for your application like the demos.</p>
        <ul class="leading-normal list-disc pl-8 text-lg mb-4">
            <li><span class="text-primary font-medium">src/layout</span>: Main layout files, needs to be present.</li>
            <li><span class="text-primary font-medium">src/views</span>: Demo pages like Dashboard.</li>
            <li><span class="text-primary font-medium">public/demo</span>: Publicly accessible assets used in demos</li>
            <li><span class="text-primary font-medium">public/layout</span>: Publicly accessible assets used in layout</li>
            <li><span class="text-primary font-medium">src/assets/demo</span>: Styles used in demos</li>
            <li><span class="text-primary font-medium">src/assets/layout</span>: Styles of the main layout</li>
        </ul>

        <div class="font-semibold text-xl my-4">Layout Composable</div>
        <p class="text-lg mb-4">
            The <span class="bg-highlight px-2 py-1 rounded-border not-italic text-base">src/layout/composables/layout.js</span> is a composable that manages the layout state changes including dark mode, PrimeVue theme, menu modes and states. Use
            this composable to change the initial configuration and handle changes reactively.
        </p>

        <pre class="app-code"><code>&lt;script setup&gt;
import &#123; useLayout &#125; from '@/layout/composables/layout';

const &#123; layoutConfig &#125; = useLayout();
    layoutConfig.menuMode = 'slim'                             // change to slim mode
    layoutConfig.darkTheme = !layoutConfig.darkTheme;          // change color scheme
&lt;/script&gt;
</code></pre>

        <div class="font-semibold text-xl mb-4">Menu</div>
        <p class="text-lg mb-4">
            Main menu is defined at <span class="bg-highlight px-2 py-1 rounded-border not-italic text-base">src/layout/AppMenu.vue</span> file. Update the <i class="bg-highlight px-2 py-1 rounded-border not-italic text-base">model</i> property to
            define your own menu items.
        </p>
        <pre class="app-code"><code>const model = ref([
&#123;
    label: 'Dashboards',
    icon: 'pi pi-home',
    items: [
        &#123;
            label: 'E-Commerce',
            icon: 'pi pi-fw pi-home',
            to: '/'
        &#125;,
        &#123;
            label: 'Banking',
            icon: 'pi pi-fw pi-image',
            to: '/dashboard-banking'
        &#125;
    ]
&#125;,
//...
</code></pre>

        <div class="font-semibold text-xl mb-4">Breadcrumb</div>
        <p class="text-lg mb-4">
            Breadcrumb component at the topbar section is dynamic and retrieves the path information from the router using the
            <span class="text-primary font-medium">meta.breadcrumb</span> property.
        </p>

        <pre class="app-code"><code>&#123;
    path: '/uikit/formlayout',
    name: 'formlayout',
    meta: {
        breadcrumb: ['UI Kit', 'Form Layout']
    },
    component: () => import('@/views/uikit/FormLayout.vue')
&#125;,</code></pre>

        <div class="font-semibold text-xl my-4">Menu Theme</div>
        <p class="text-lg mb-4">Menu skin has 18 alternatives to choose from in light mode, note that in dark and dim modes menu theme is not applied by design. Possible values for the menu theme are the following.</p>
        <ul class="pl-8 leading-normal list-disc">
            <li>dark</li>
            <li>light</li>
            <li>noir</li>
            <li>emerald</li>
            <li>green</li>
            <li>lime</li>
            <li>orange</li>
            <li>amber</li>
            <li>teal</li>
            <li>cyan</li>
            <li>sky</li>
            <li>blue</li>
            <li>indigo</li>
            <li>violet</li>
            <li>purple</li>
            <li>fuchsia</li>
            <li>pink</li>
            <li>rose</li>
        </ul>

        <p class="text-lg mb-4 mt-2">A custom menu theme can be developed by steps below.</p>
        <ul class="pl-8 mb-4 leading-normal list-disc">
            <li>Choose a custom theme name such as "mymenu".</li>
            <li>Create a file named "_mymenu.scss" under <span class="font-semibold">src/assets/layout/sidebar/themes</span> folder.</li>
            <li>Define the variables listed below in your file.</li>
            <li>Import the file at <span class="font-semibold">src/assets/layout/layout.scss</span>.</li>
            <li>Configure the menutheme property at layoutservice with the name of your sidebar theme e.g. mymenu.</li>
        </ul>

        <pre class="app-code"><code>.layout-sidebar-mymenu &#123;
    --d-sidebar-bg-color:#2196F3;
    --d-sidebar-bg-color-alt:#1769aa;
    --d-sidebar-border:0 none;
    --d-app-name-color:#ffffff;
    --d-menu-separator-border: 1px solid rgba(255,255,255,0.2);
    --d-menuitem-root-text-color: rgba(255,255,255,0.6);
    --d-menuitem-text-color: rgba(255,255,255,0.8);
    --d-menuitem-hover-bg: rgba(255,255,255,0.1);
    --d-menuitem-active-bg: rgba(255,255,255,0.1);
    --d-menuitem-active-text-color: #ffffff;
    --d-menuitem-focus-shadow: 0 0 0 0.2rem rgba(255,255,255,0.1);
&#125;</code></pre>

        <div class="font-semibold text-xl mb-4">Learn More</div>
        <p class="text-lg mb-4">To learn more about how PrimeVue templates are implemented, visit the Sakai open source repository, Diamond utilizes a similar structure as Sakai.</p>

        <div class="video-container mb-4">
            <iframe class="video" width="560" height="315" src="https://www.youtube.com/embed/Ni_Yecfxv_g?si=11QMilH9sf06Xwi5" frameborder="0" allowfullscreen />
        </div>

        <div class="font-semibold text-xl mb-4">Tailwind CSS</div>
        <p class="text-lg mb-4">The demo pages are developed using Tailwind CSS along with tailwind-primeui plugin, whereas the core application shell mainly uses custom CSS.</p>

        <div class="font-semibold text-xl mb-4">Variables</div>
        <p class="text-lg mb-4">
            CSS variables used in the template derive their values from the PrimeVue styled mode presets, use the files under
            <span class="bg-highlight px-2 py-1 rounded-border not-italic text-base">src/assets/layout/variables</span> to customize according to your requirements.
        </p>
    </div>
</template>

<style lang="scss" scoped>
@media screen and (max-width: 991px) {
    .video-container {
        position: relative;
        width: 100%;
        height: 0;
        padding-bottom: 56.25%;

        iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }
    }
}
</style>
