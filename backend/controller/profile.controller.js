const ProfileService = require('../services/profile.services');

exports.uploadImageBackground = async (req, res) => {
  try {
    const { userId, imageUrl } = req.body;
    const successUpload = await ProfileService.uploadImageBackground(userId, imageUrl);

    res.json({ status: true, message: 'Image uploaded successfully' });
  } catch (error) {
    throw error
  }
}

exports.removeImageBackground = async (req, res) => {
  try {
    const { userId } = req.body;
    const successRemove = await ProfileService.removeImageBackground(userId);

    res.json({ status: true, message: 'Image removed successfully' });
  } catch (error) {
    throw error
  }
}

exports.updateHeight = async (req, res) => {
  try {
    const { userId, height } = req.body;
    const successUpdate = await ProfileService.updateHeight(userId, height);

    res.json({ status: true, message: 'Height updated successfully' });
  } catch (error) {
    throw error
  }
}

exports.updateWeight = async (req, res) => {
  try {
    const { userId, weight } = req.body;
    const successUpdate = await ProfileService.updateWeight(userId, weight);

    res.json({ status: true, message: 'Weight updated successfully' });
  } catch (error) {
    throw error
  }
}

exports.updateBloodType = async (req, res) => {
  try {
    const { userId, bloodType } = req.body;
    const successUpdate = await ProfileService.updateBloodType(userId, bloodType);

    res.json({ status: true, message: 'Blood type updated successfully' });
  } catch (error) {
    throw error
  }
}

exports.updateMedication = async (req, res) => {
  try {
    const { userId, medication } = req.body;
    const successUpdate = await ProfileService.updateMedication(userId, medication);

    res.json({ status: true, message: 'Medication updated successfully' });
  } catch (error) {
    throw error
  }
}