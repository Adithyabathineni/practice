const express = require("express");
const bodyParser = require("body-parser");
const ejs = require("ejs");
const app = express();
const port = 8000;
const path = require("path");
const mongoose = require("mongoose");
const fileUpload = require("express-fileupload");
const session = require("express-session");
mongoose.connect("mongodb://127.0.0.1:27017/projectTrail1");

const pageDetails = mongoose.model("pages", {
  pageTitle: String,
  heroImage: String,
  pagebody: String,
});

// app.use(express.static("public"));
app.use(express.static(path.join(__dirname, 'public')));

app.set("view engine", "ejs");
app.use(fileUpload());
const filePath = "public/images/";
app.use(bodyParser.urlencoded({ extended: false }));
app.use(
  session({
    secret: "randomsecretcode",
    resave: false,
    saveUninitialized: true,
  })
);

app.get("/", (req, res) => {
  pageDetails.find({}).then((page) => {
    res.render("index", { page: page });
  });
});

app.get("/admin", (req, res) => {
  pageDetails.find({}).then((page) => {
    res.render("admin", { page: page });
  });
});

app.post("/welcome", (req, res) => {
  const { username, password } = req.body;

  if (username == "admin" && password == "admin") {
    req.session.isLoggedIn = true;
    res.render("welcome");
  }
});

app.get("/addpage", (req, res) => {
  if (req.session.isLoggedIn) {
    res.render("addpage");
  } else {
    res.redirect("/");
  }
});

const addPageSuccessful = {
  bodyMessage: "You have successfully created a new page",
};

const editPageSuccessful = {
  bodyMessage: "You have successfully edited the page",
};
const deletePageSuccessful = {
  bodyMessage: "You have successfully deleted the page",
};

app.post("/success", (req, res) => {
  const { pageTitle, pagebody } = req.body;
  // const { heroImageTest } = req.files;
  var herobodyImage = req.files.heroImage;
  var heroImageName = herobodyImage.name;
  var heroImageSavePath = filePath + heroImageName;
  herobodyImage.mv(heroImageSavePath, function (err) {
    if (err) {
      console.log(err);
    }
  });
  // console.log(heroImageTest);
  var pageData = {
    pageTitle: pageTitle,
    heroImage: "images/" + heroImageName,
    pagebody: pagebody,
  };
  var newPage = new pageDetails(pageData);
  newPage.save();

  res.render("taskcomplete", { addPageSuccessful: addPageSuccessful });
});

app.get("/editpage", (req, res) => {
  if (req.session.isLoggedIn) {
    pageDetails.find({}).then((page) => {
      res.render("editpage", { page: page });
    });
  } else {
    res.redirect("/");
  }
});

app.get("/editpage/:pageid", (req, res) => {
  if (req.session.isLoggedIn) {
    pageDetails.find({ _id: req.params.pageid }).then((page) => {
      // res.send(page[0]._id);
      res.render("editable", {
        page: page[0],
      });
    });
  } else {
    res.redirect("/");
  }
});

app.post("/editsuccess/:id", (req, res) => {
  if (req.session.isLoggedIn) {
    pageDetails.findByIdAndUpdate(req.params.id).then((page) => {
      const { pageTitle, heroImage, pagebody } = req.body;
      page.pageTitle = pageTitle;
      page.pagebody = pagebody;
      page.heroImage = heroImage;

      page.save();
      res.render("taskcomplete", { editPageSuccessful: editPageSuccessful });
    });
  } else {
    res.redirect("/");
  }
  //
  // console.log(page);
  // const _id = req.params._id;
  // console.log({ _id: req.params.pageid });
  // const { pageTitle, heroImage, pagebody } = req.body;
  // var pageData = {
  //   _id: req.params.id,
  //   pageTitle: pageTitle,
  //   heroImage: heroImage,
  //   pagebody: pagebody,
  // };
  // var editPage = new pageDetails(pageData);
  // editPage.save();
  // res.send(pageData);
  //
  // res.render("taskcomplete", { editPageSuccessful: editPageSuccessful });
  // res.render();
});

app.get("/deletepage/:id", (req, res) => {
  if (req.session.isLoggedIn) {
    var id = req.params.id;
    pageDetails.findByIdAndRemove({ _id: id }).then(function (err, page) {
      res.render("taskcomplete", {
        deletePageSuccessful: deletePageSuccessful,
      });
    });
  } else {
    res.redirect("/");
  }
});

app.get("/logout", (req, res) => {
  req.session.destroy();
  res.render("logout");
});


app.get("/edits", (req, res) => {
  // res.send(page[0]._id);
  res.render("edits");
});

app.get("/content/:pageid", (req, res) => {
  pageDetails.find({ _id: req.params.pageid }).then((page) => {
    console.log({ _id: req.params.pageid });
    // res.send(page[0]._id);
    console.log(page);
    pageDetails.find({}).then((navlinkpages) => {
      res.render("content", { navlinkpages: navlinkpages, page: page[0] });
    });
    
    // res.send(page[0].pageTitle);
    // res.render("contentpage", {
      //   page: page[0],
      // });
    });
  });
  console.log(`listening on port http://localhost:${port}`);
  app.listen(port, () => {
  });
