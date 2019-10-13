# insert your copyright here

# see the URL below for information on how to write OpenStudio measures
# http://nrel.github.io/OpenStudio-user-documentation/reference/measure_writing_guide/

# start the measure
class ZombieApocalypse < OpenStudio::Measure::ModelMeasure
  # human readable name
  def name
    # Measure name should be the title case of the class name.
    return 'Zombie Apocalypse'
  end

  # human readable description
  def description
    return 'Just a quick test measure with no real purpose'
  end

  # human readable description of modeling approach
  def modeler_description
    return 'remoes heat gain from people and ventilation requirements from zones.'
  end

  # define the arguments that the user will input
  def arguments(model)
    args = OpenStudio::Measure::OSArgumentVector.new

    # the name of the space to add to the model
    enable_zombie = OpenStudio::Measure::OSArgument.makeBoolArgument('enable_zombie', true)
    enable_zombie.setDisplayName('Enable Zombies')
    enable_zombie.setDescription('Test to show how to change people and ventilation characteristics.')
    enable_zombie.setDefaultValue(true)
    args << enable_zombie

    return args
  end

  # define what happens when the measure is run
  def run(model, runner, user_arguments)
    super(model, runner, user_arguments)

    # use the built-in error checking
    if !runner.validateUserArguments(arguments(model), user_arguments)
      return false
    end

    # assign the user inputs to variables
    enable_zombie = runner.getBoolArgumentValue('enable_zombie', user_arguments)

    # report initial condition of model
    runner.registerInitialCondition("The building started with #{model.getBuilding.numberOfPeople} people.")

    if enable_zombie

      # change heat gain
      runner.registerInfo("Remove heat gain and co2 generation")
      model.getPeopleDefinitions.each do |people|
        people.setCarbonDioxideGenerationRate(0.0)
        people.setFractionRadiant(0.0)
        people.setSensibleHeatFraction(0.0)
      end

      # change zone ventilation requirements
      runner.registerInfo("Remove per person ventilation requirements")
      model.getDesignSpecificationOutdoorAirs.each do |oa|
        oa.setOutdoorAirFlowperPerson(0.0)
      end
      # report final condition of model
      runner.registerFinalCondition("The building finished with #{model.getBuilding.numberOfPeople} zombies.")
    else
      # report final condition of model
      runner.registerFinalCondition("The building finished with #{model.getBuilding.numberOfPeople} people.")
    end


    return true
  end
end

# register the measure to be used by the application
ZombieApocalypse.new.registerWithApplication
