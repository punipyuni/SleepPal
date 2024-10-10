const router = require('express').Router();
const ProfileControllers = require('../controller/profile.controller');

router.post('/upload-image-background', ProfileControllers.uploadImageBackground);
router.post('/remove-image-background', ProfileControllers.removeImageBackground);
router.post('/update-height', ProfileControllers.updateHeight);
router.post('/update-weight', ProfileControllers.updateWeight);
router.post('/update-blood-type', ProfileControllers.updateBloodType);
router.post('/update-medication', ProfileControllers.updateMedication);