class PeopleController < ApplicationController
  def index
    @people = Person.all.order(:last_name)
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)
    if @person.save
      respond_to do |format|
        format.html { redirect_to people_path, notice: "Person was successfully created." }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end

  end

  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to people_url, notice: "Person was successfully deleted."}
      format.turbo_stream
    end

  end

  def show
    @person = Person.find(params[:id])
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    @person = Person.find(params[:id])
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to people_url, notice: "Person was successfully updated" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def person_params
    params.require(:person).permit(:last_name, :first_name, :date_birth, :date_dc)
  end
  end
