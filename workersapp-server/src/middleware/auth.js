
const User = require('../models/user')
const Workers = require('../models/workers');
const jwt = require('jsonwebtoken')
const userAuth = async (req, res, next) => {
    try {
        const token = req.header('Authorization').replace('Bearer ', '')
        const decoded = jwt.verify(token, 'www.userss@gmail.com')
        const user = await User.findOne({ _id: decoded._id, 'tokens.token': token })

        if (!user) {
            throw new Error()
        }

        req.token = token
        req.user = user
        next()
    } catch (e) {
        res.status(401).send({ error: 'Please authenticate.' })
    }
}
const workerAuth = async (req, res, next) => {
    try {
        const token = req.header('Authorization').replace('Bearer ', '')
        const decoded = jwt.verify(token, 'www.workers@gmail.com')
        const worker = await Workers.findOne({ _id: decoded._id, 'tokens.token': token })

        if (!worker) {
            throw new Error()
        }

        req.token = token
        req.worker = worker
        next()
    } catch (e) {
        res.status(401).send({ error: 'Please authenticate.' })
    }
}
module.exports = {
    userAuth,
    workerAuth,
};
