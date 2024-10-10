const ProfileModel = require('../model/profile.model');

class ProfileService {
    static async uploadImageBackground(userId, imageUrl) {
        try {
            return await ProfileModel.findOneAndUpdate(
                { userId },
                { image_background: imageUrl },
                { new: true }
            );
        } catch (err) {
            throw err;
        }
    }

    static async removeImageBackground(userId) {
        try {
            return await ProfileModel.findOneAndUpdate(
                { userId },
                { image_background: '' },
                { new: true }
            );
        } catch (err) {
            throw err;
        }
    }

    static async updateHeight(userId, height) {
        try {
            return await ProfileModel.findOneAndUpdate(
                { userId },
                { height },
                { new: true }
            );
        } catch (err) {
            throw err;
        }
    }

    static async updateWeight(userId, weight) {
        try {
            return await ProfileModel.findOneAndUpdate(
                { userId },
                { weight },
                { new: true }
            );
        } catch (err) {
            throw err;
        }
    }

    static async updateBloodType(userId, bloodType) {
        try {
            return await ProfileModel.findOneAndUpdate(
                { userId },
                { blood_type: bloodType },
                { new: true }
            );
        } catch (err) {
            throw err;
        }
    }

    static async updateMedication(userId, medication) {
        try {
            return await ProfileModel.findOneAndUpdate(
                { userId },
                { medication },
                { new: true }
            );
        } catch (err) {
            throw err;
        }
    }
}

module.exports = ProfileService;