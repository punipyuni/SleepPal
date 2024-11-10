// services/profileService.js
const ProfileModel = require('../models/profileModel');

class ProfileService {
  
  static async getProfileByUserId(userId) {
    try {
      return await ProfileModel.findOne({ userId });
    } catch (error) {
      throw error;
    }
  }

  static async updateOrCreateProfile(userId, profileData) {
    try {
      // Upsert (update if exists, otherwise create)
      return await ProfileModel.findOneAndUpdate(
        { userId },
        { ...profileData },
        { new: true, upsert: true }
      );
    } catch (error) {
      throw error;
    }
  }
}

module.exports = ProfileService;
