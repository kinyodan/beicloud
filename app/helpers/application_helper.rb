# frozen_string_literal: true

module ApplicationHelper
  def applicationHelperGetStackIcons
    {
      ruby: 'https://res.cloudinary.com/selae-learning/image/upload/v1674675578/beimarket-assets/icons8-rails-a-server-side-web-application-framework-written-in-ruby-96_nftlya.png',
      nodejs: 'https://res.cloudinary.com/selae-learning/image/upload/v1674675579/beimarket-assets/icons8-node-js-240_ubeqdf.png',
      javascript: 'https://res.cloudinary.com/selae-learning/image/upload/v1674675580/beimarket-assets/icons8-javascript-144_rr17xw.png',
      golang: 'https://res.cloudinary.com/selae-learning/image/upload/v1674675580/beimarket-assets/icons8-golang-240_nkookf.png',
      flutter: 'https://res.cloudinary.com/selae-learning/image/upload/v1674675581/beimarket-assets/icons8-flutter-48_n8rls7.png',
      flask: 'https://res.cloudinary.com/selae-learning/image/upload/v1674675581/beimarket-assets/icons8-flask-100_ddl6mh.png',
      django: 'https://res.cloudinary.com/selae-learning/image/upload/v1674675582/beimarket-assets/icons8-django-240_kgf4sf.png',
      python: 'https://res.cloudinary.com/selae-learning/image/upload/v1674675582/beimarket-assets/icons8-python-48_xzwi5a.png',
      mariadb: 'https://res.cloudinary.com/selae-learning/image/upload/v1674675583/beimarket-assets/icons8-mariadb-144_ezfing.png',
      mongodb: 'https://res.cloudinary.com/selae-learning/image/upload/v1674675583/beimarket-assets/icons8-mongodb-48_rwt02f.png',
      mysql: 'https://res.cloudinary.com/selae-learning/image/upload/v1674675584/beimarket-assets/icons8-mysql-logo-144_tcscbu.png',
      java: 'https://res.cloudinary.com/selae-learning/image/upload/v1674675586/beimarket-assets/icons8-java-144_uolaa8.png',
      vuejs: 'https://res.cloudinary.com/selae-learning/image/upload/v1674675586/beimarket-assets/icons8-vue.js-an-open-source-javascript-framework-for-building-user-interfaces-and-single-page-applications-48_e1kgb1.png'
    }
  end

  def applicationHelpersetClass(status)
    return 'sucess-deploy' if status.include? 'succesfully'

    'danger-deploy'
  end
end
