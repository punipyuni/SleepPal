// controllers/profileController.js
const ProfileService = require('../services/profileService');

exports.getProfile = async (req, res) => {
  try {
    const profile = await ProfileService.getProfileByUserId(req.user._id);
    if (!profile) return res.status(404).json({ message: 'Profile not found' });
    res.json(profile);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

exports.updateProfile = async (req, res) => {
  try {
    const profileData = req.body;
    const profile = await ProfileService.updateOrCreateProfile(req.user._id, profileData);
    res.json(profile);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};
