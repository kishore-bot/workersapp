const express = require('express');
require('./db/mongoose');
const userRoutes=require('./routes/user');
const workersRoutes=require('./routes/workers');
const forUserRoutes=require('./routes/forUser');
const forWorkerRoutes=require('./routes/forWorker');

const app = express();
const port = process.env.PORT || 9001

app.use(express.json());
app.use(userRoutes);
app.use(workersRoutes);
app.use(forUserRoutes);
app.use(forWorkerRoutes);

app.listen(port, () => {
    console.log('Server is running on port 3000');
});

// cronJob.start();