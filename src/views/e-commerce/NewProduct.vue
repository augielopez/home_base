<script setup>
import { computed, ref } from 'vue';

const product = ref({
    name: '',
    code: '158692',
    category: null,
    brand: '',
    gender: 'women',
    price: '',
    sizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
    cargoCompany: null
});

const categories = ref([
    { label: 'Jackets', value: 'jackets' },
    { label: 'Coats', value: 'coats' },
    { label: 'Dresses', value: 'dresses' },
    { label: 'Suits', value: 'suits' }
]);

const cargoCompanies = ref([
    { label: 'FedEx', value: 'fedex' },
    { label: 'DHL', value: 'dhl' },
    { label: 'UPS', value: 'ups' },
    { label: 'USPS', value: 'usps' }
]);

const sizes = ref([{ label: 'XS' }, { label: 'S' }, { label: 'M' }, { label: 'L' }, { label: 'XL' }, { label: 'XXL' }]);
const selectedSizes = ref([]);
const selectedColors = ref(['blue', 'red']);
const colorMenu = ref();

const colorOptions = [
    { name: 'Red', value: 'red', class: 'bg-red-500' },
    { name: 'Blue', value: 'blue', class: 'bg-blue-500' },
    { name: 'Green', value: 'green', class: 'bg-green-500' },
    { name: 'Yellow', value: 'yellow', class: 'bg-yellow-500' },
    { name: 'Purple', value: 'purple', class: 'bg-purple-500' },
    { name: 'Pink', value: 'pink', class: 'bg-pink-500' },
    { name: 'Indigo', value: 'indigo', class: 'bg-indigo-500' },
    { name: 'Gray', value: 'gray', class: 'bg-gray-500' },
    { name: 'Black', value: 'black', class: 'bg-black' },
    { name: 'White', value: 'white', class: 'bg-white border border-gray-300' }
];

const menuItems = computed(() =>
    colorOptions
        .filter((color) => !selectedColors.value.includes(color.value))
        .map((color) => ({
            label: color.name,
            command: () => addColor(color.value)
        }))
);

// File upload
const coverImage = ref(null);
const additionalImages = ref([null, null, null]);
const fileInputs = ref({
    cover: null,
    image1: null,
    image2: null,
    image3: null
});

function triggerFileUpload(type) {
    if (fileInputs.value[type]) {
        fileInputs.value[type].click();
    }
}

function handleCoverUpload(event) {
    const file = event.target.files[0];
    if (file && file.type.startsWith('image/')) {
        const reader = new FileReader();
        reader.onload = (e) => {
            coverImage.value = e.target.result;
        };
        reader.readAsDataURL(file);
    }
    event.target.value = '';
}

function handleImageUpload(event, index) {
    const file = event.target.files[0];
    if (file && file.type.startsWith('image/')) {
        const reader = new FileReader();
        reader.onload = (e) => {
            additionalImages.value[index] = e.target.result;
        };
        reader.readAsDataURL(file);
    }
    event.target.value = '';
}

function toggleSize(sizeLabel) {
    const index = selectedSizes.value.indexOf(sizeLabel);
    if (index > -1) {
        selectedSizes.value.splice(index, 1);
    } else {
        selectedSizes.value.push(sizeLabel);
    }
}

function addColor(colorValue) {
    if (!selectedColors.value.includes(colorValue)) {
        selectedColors.value.push(colorValue);
    }
}

function removeColor(colorValue) {
    const index = selectedColors.value.indexOf(colorValue);
    if (index > -1) {
        selectedColors.value.splice(index, 1);
    }
}

function showColorMenu(event) {
    colorMenu.value.toggle(event);
}

function getColorClass(colorValue) {
    const color = colorOptions.find((c) => c.value === colorValue);
    return color ? color.class : 'bg-gray-500';
}

function removeCoverImage() {
    coverImage.value = null;
}

function removeAdditionalImage(index) {
    additionalImages.value[index] = null;
}

function addProduct() {}
</script>

<template>
    <div class="flex flex-col xl:flex-row card">
        <div class="w-full xl:w-[65%] flex flex-col overflow-hidden">
            <div class="px-6 py-4 flex justify-start items-start gap-4">
                <div class="text-surface-950 dark:text-surface-0 text-xl font-medium leading-7">Add Product</div>
            </div>

            <!-- Divider -->
            <div class="px-6 py-2">
                <Divider class="border-surface-200 dark:border-surface-700" />
            </div>

            <div class="p-6 flex flex-col lg:flex-row justify-start items-start gap-4">
                <div class="flex-1 flex flex-col justify-start items-start gap-2">
                    <div class="text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Product name</div>
                    <div class="text-surface-500 dark:text-surface-400 text-base font-normal leading-normal">Code will be generated automatically</div>
                </div>
                <div class="flex-1 flex flex-col justify-start items-start gap-3 w-full lg:w-auto">
                    <InputText v-model="product.name" placeholder="Enter product name" class="w-full" />
                    <InputGroup>
                        <InputText v-model="product.code" placeholder="158692" readonly />
                        <InputGroupAddon>
                            <i class="pi pi-copy cursor-pointer text-surface-500 dark:text-surface-400 hover:text-surface-700 dark:hover:text-surface-200 transition-colors" />
                        </InputGroupAddon>
                    </InputGroup>
                </div>
            </div>

            <div class="px-6 py-2">
                <Divider class="border-surface-200 dark:border-surface-700" />
            </div>

            <div class="p-6 flex flex-col lg:flex-row justify-start items-start gap-4">
                <div class="flex-1 flex flex-col justify-start items-start gap-2">
                    <div class="text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Category & Brand</div>
                    <div class="text-surface-500 dark:text-surface-400 text-base font-normal leading-normal">It will help customer to find the product</div>
                </div>
                <div class="flex-1 flex flex-col justify-start items-start gap-3 w-full lg:w-auto">
                    <Select v-model="product.category" :options="categories" optionLabel="label" optionValue="value" placeholder="Select category" class="w-full" />
                    <InputText v-model="product.brand" placeholder="Enter brand name" class="w-full" />
                </div>
            </div>

            <div class="px-6 py-2">
                <Divider class="border-surface-200 dark:border-surface-700" />
            </div>

            <div class="p-6 flex flex-col lg:flex-row justify-start items-start lg:items-center gap-4">
                <div class="w-full lg:w-[337px] text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Gender</div>
                <div class="w-full flex-1 flex flex-col sm:flex-row justify-start lg:justify-end items-start sm:items-center gap-4">
                    <div class="flex justify-start items-center gap-2">
                        <RadioButton v-model="product.gender" inputId="women" value="women" />
                        <label for="women" class="text-surface-900 dark:text-surface-0 text-base font-normal">Women</label>
                    </div>
                    <div class="flex justify-start items-center gap-2">
                        <RadioButton v-model="product.gender" inputId="men" value="men" />
                        <label for="men" class="text-surface-900 dark:text-surface-0 text-base font-normal">Men</label>
                    </div>
                    <div class="flex justify-start items-center gap-2">
                        <RadioButton v-model="product.gender" inputId="unisex" value="unisex" />
                        <label for="unisex" class="text-surface-900 dark:text-surface-0 text-base font-normal">Unisex</label>
                    </div>
                </div>
            </div>

            <div class="px-6 py-2">
                <Divider class="border-surface-200 dark:border-surface-700" />
            </div>

            <div class="p-6 flex flex-col lg:flex-row justify-between items-center gap-4">
                <div class="w-full lg:w-96 text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Price</div>
                <div class="w-full lg:w-96">
                    <IconField iconPosition="left">
                        <InputIcon class="pi pi-dollar" />
                        <InputText v-model="product.price" placeholder="Enter price" class="w-full" />
                    </IconField>
                </div>
            </div>

            <div class="px-6 py-2">
                <Divider class="border-surface-200 dark:border-surface-700" />
            </div>

            <div class="p-6 flex flex-col lg:flex-row justify-start items-start gap-4">
                <div class="flex-1 flex flex-col justify-start items-start gap-2">
                    <div class="text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Size</div>
                    <div class="text-surface-500 dark:text-surface-400 text-base font-normal leading-normal">Pick available sizes</div>
                </div>
                <div class="flex-1 flex justify-start lg:justify-end items-center gap-2 flex-wrap">
                    <div
                        v-for="size in sizes"
                        :key="size.label"
                        class="flex-1 min-w-[60px] max-w-[60px] h-8 p-1 rounded-xl transition-colors cursor-pointer border"
                        :class="{
                            'border-primary-500 dark:border-primary-400': selectedSizes.includes(size.label),
                            'border-surface-200 dark:border-surface-700': !selectedSizes.includes(size.label)
                        }"
                        @click="toggleSize(size.label)"
                    >
                        <div
                            class="w-full h-full flex justify-center items-center rounded-lg"
                            :class="{
                                'bg-primary-600': selectedSizes.includes(size.label),
                                'bg-surface-200 dark:bg-surface-700': !selectedSizes.includes(size.label)
                            }"
                        >
                            <span
                                class="text-sm font-medium"
                                :class="{
                                    'text-white': selectedSizes.includes(size.label),
                                    'text-surface-950 dark:text-surface-0': !selectedSizes.includes(size.label)
                                }"
                            >
                                {{ size.label }}
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="px-6 py-2">
                <Divider class="border-surface-200 dark:border-surface-700" />
            </div>

            <div class="p-6 flex flex-col lg:flex-row justify-start items-start gap-4">
                <div class="w-full lg:w-96 flex flex-col justify-start items-start gap-2">
                    <div class="text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Color Variants</div>
                    <div class="text-surface-500 dark:text-surface-400 text-base font-normal leading-normal">Upload pictures with your colors</div>
                </div>
                <div class="flex-1 flex justify-end items-center gap-2 flex-wrap">
                    <div v-for="color in selectedColors" :key="color" class="relative w-8 h-8 rounded-full border border-surface-200 dark:border-surface-700 cursor-pointer group" :class="getColorClass(color)" @click="removeColor(color)">
                        <div class="absolute inset-0 flex justify-center items-center opacity-0 group-hover:opacity-100 transition-opacity bg-black/30 rounded-full">
                            <i class="pi pi-times text-white text-xs" />
                        </div>
                    </div>

                    <div
                        class="w-8 h-8 bg-surface-100 dark:bg-surface-700 rounded-full border border-surface-200 dark:border-surface-700 flex justify-center items-center cursor-pointer hover:bg-surface-200 dark:hover:bg-surface-600 transition-colors"
                        @click="showColorMenu"
                    >
                        <i class="pi pi-plus text-surface-600 dark:text-surface-300 text-xs" />
                    </div>

                    <Menu ref="colorMenu" :model="menuItems" popup />
                </div>
            </div>

            <div class="px-6 py-2">
                <Divider class="border-surface-200 dark:border-surface-700" />
            </div>

            <div class="p-6 flex flex-col lg:flex-row justify-between items-center gap-4">
                <div class="w-full lg:w-96 text-surface-950 dark:text-surface-0 text-lg font-medium leading-7">Cargo Company</div>
                <div class="w-full lg:w-96">
                    <MultiSelect v-model="product.cargoCompany" :options="cargoCompanies" optionLabel="label" optionValue="value" placeholder="Select cargo companies" class="w-full" />
                </div>
            </div>
        </div>

        <div class="w-full xl:w-[35%] bg-surface-50 dark:bg-surface-800 flex flex-col overflow-hidden rounded-2xl border border-surface-200 dark:border-surface-700">
            <div class="px-6 py-4 flex justify-start items-start gap-4">
                <div class="text-surface-950 dark:text-surface-0 text-xl font-medium leading-7">Product Preview</div>
            </div>

            <div class="px-6 py-2">
                <Divider class="border-surface-300 dark:border-surface-600" />
            </div>

            <div class="p-6 flex flex-col justify-start items-start gap-4">
                <div
                    v-if="!coverImage"
                    class="w-full h-96 p-2 bg-surface-50 dark:bg-surface-700 rounded-xl border border-surface-300 dark:border-surface-600 flex flex-col justify-center items-center gap-6 cursor-pointer hover:bg-surface-100 dark:hover:bg-surface-600 transition-colors"
                    @click="triggerFileUpload('cover')"
                >
                    <div class="flex flex-col justify-center items-center gap-4">
                        <div class="w-12 h-12">
                            <i class="pi pi-cloud-upload text-surface-500 dark:text-surface-400 text-4xl!" />
                        </div>
                        <div class="text-center text-surface-500 dark:text-surface-400 text-xl font-medium leading-7">Drop or select a cover image</div>
                        <div class="text-primary-600 dark:text-primary-400 text-lg font-medium underline leading-7">Upload</div>
                    </div>
                </div>

                <div v-else class="w-full h-96 p-4 rounded-3xl flex flex-col justify-end items-start gap-2 overflow-hidden relative group cursor-pointer">
                    <div class="absolute inset-0 rounded-3xl overflow-hidden">
                        <img :src="coverImage" class="w-full h-full object-cover" :alt="product.name || 'Product preview'" />
                        <div class="absolute inset-0 bg-linear-to-t from-black/60 via-transparent to-transparent" />
                        <Button icon="pi pi-trash" severity="danger" size="small" rounded class="absolute! top-2 right-2 w-8 h-8 p-0 shadow-lg z-20" @click.stop="removeCoverImage" />
                    </div>

                    <div class="relative z-10 w-full p-4 bg-surface-0 dark:bg-surface-900 rounded-2xl shadow-xl flex flex-col justify-start items-start gap-2 overflow-hidden">
                        <div class="w-full flex flex-col gap-2">
                            <div class="w-full flex justify-between items-start gap-2">
                                <div class="flex-1 text-surface-500 dark:text-surface-400 text-base sm:text-lg font-medium leading-6 sm:leading-7 line-clamp-2 min-w-0">{{ product.name || 'Product Name' }}</div>
                                <div class="flex justify-start items-center gap-2 shrink-0">
                                    <div class="p-2 rounded-lg border border-surface-200 dark:border-surface-700 flex justify-center items-center cursor-pointer hover:bg-surface-100 dark:hover:bg-surface-700 transition-colors">
                                        <i class="pi pi-heart text-surface-500 dark:text-surface-400 text-sm sm:text-base" />
                                    </div>
                                    <div class="p-2 rounded-lg border border-surface-200 dark:border-surface-700 flex justify-center items-center cursor-pointer hover:bg-surface-100 dark:hover:bg-surface-700 transition-colors">
                                        <i class="pi pi-shopping-cart text-surface-500 dark:text-surface-400 text-sm sm:text-base" />
                                    </div>
                                </div>
                            </div>

                            <div class="w-full flex justify-between items-center">
                                <div class="text-surface-950 dark:text-surface-0 text-xl sm:text-2xl font-medium leading-8 sm:leading-loose break-all">${{ product.price || '0.00' }}</div>
                                <div class="px-2 py-1 bg-yellow-100 dark:bg-yellow-900 rounded-md flex justify-start items-center gap-1">
                                    <i class="pi pi-star-fill text-yellow-600 dark:text-yellow-400 text-xs" />
                                    <div class="text-yellow-600 dark:text-yellow-400 text-sm font-semibold leading-tight">0.0</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="w-full flex justify-start items-start gap-4">
                    <div
                        v-for="(image, index) in additionalImages"
                        :key="index"
                        class="flex-1 aspect-square p-2 bg-surface-50 dark:bg-surface-700 rounded-xl border border-surface-300 dark:border-surface-600 flex flex-col justify-center items-center gap-6 cursor-pointer hover:bg-surface-100 dark:hover:bg-surface-600 transition-colors"
                        @click="triggerFileUpload(`image${index + 1}`)"
                    >
                        <template v-if="image">
                            <div class="relative w-full h-full">
                                <img :src="image" alt="Additional image" class="w-full h-full object-cover rounded-lg" />
                                <Button icon="pi pi-trash" severity="danger" size="small" rounded class="absolute! top-2 right-2 w-6 h-6 p-0 shadow-lg z-20" @click.stop="removeAdditionalImage(index)" />
                            </div>
                        </template>
                        <template v-else>
                            <div class="flex flex-col justify-center items-center gap-2">
                                <i class="pi pi-cloud-upload text-surface-500 dark:text-surface-400 text-lg!" />
                                <div class="text-primary-600 dark:text-primary-400 text-sm font-medium underline leading-tight">Upload</div>
                            </div>
                        </template>
                    </div>
                </div>
            </div>
        </div>

        <input :ref="(el) => (fileInputs.cover = el)" type="file" accept="image/*" class="hidden" @change="handleCoverUpload" />
        <input v-for="index in 3" :key="index" :ref="(el) => (fileInputs[`image${index}`] = el)" type="file" accept="image/*" class="hidden" @change="(event) => handleImageUpload(event, index - 1)" />
    </div>

    <div class="p-6">
        <div class="flex justify-end">
            <Button label="Add Product" class="px-6 py-3 rounded-xl text-base font-medium" @click="addProduct" />
        </div>
    </div>
</template>
